
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 70 11 00 	lgdtl  0x117018
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
c010001e:	bc 00 70 11 c0       	mov    $0xc0117000,%esp
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
c0100030:	ba 68 89 11 c0       	mov    $0xc0118968,%edx
c0100035:	b8 36 7a 11 c0       	mov    $0xc0117a36,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 36 7a 11 c0 	movl   $0xc0117a36,(%esp)
c0100051:	e8 92 5c 00 00       	call   c0105ce8 <memset>

    cons_init();                // init the console
c0100056:	e8 70 15 00 00       	call   c01015cb <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 80 5e 10 c0 	movl   $0xc0105e80,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 9c 5e 10 c0 	movl   $0xc0105e9c,(%esp)
c0100070:	e8 c7 02 00 00       	call   c010033c <cprintf>

    print_kerninfo();
c0100075:	e8 f6 07 00 00       	call   c0100870 <print_kerninfo>

    grade_backtrace();
c010007a:	e8 86 00 00 00       	call   c0100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 6d 41 00 00       	call   c01041f1 <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 ab 16 00 00       	call   c0101734 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 fd 17 00 00       	call   c010188b <idt_init>

    clock_init();               // init clock interrupt
c010008e:	e8 ee 0c 00 00       	call   c0100d81 <clock_init>
    intr_enable();              // enable irq interrupt
c0100093:	e8 0a 16 00 00       	call   c01016a2 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c0100098:	eb fe                	jmp    c0100098 <kern_init+0x6e>

c010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c010009a:	55                   	push   %ebp
c010009b:	89 e5                	mov    %esp,%ebp
c010009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000a7:	00 
c01000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000af:	00 
c01000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000b7:	e8 f7 0b 00 00       	call   c0100cb3 <mon_backtrace>
}
c01000bc:	c9                   	leave  
c01000bd:	c3                   	ret    

c01000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000be:	55                   	push   %ebp
c01000bf:	89 e5                	mov    %esp,%ebp
c01000c1:	53                   	push   %ebx
c01000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000cb:	8d 55 08             	lea    0x8(%ebp),%edx
c01000ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000dd:	89 04 24             	mov    %eax,(%esp)
c01000e0:	e8 b5 ff ff ff       	call   c010009a <grade_backtrace2>
}
c01000e5:	83 c4 14             	add    $0x14,%esp
c01000e8:	5b                   	pop    %ebx
c01000e9:	5d                   	pop    %ebp
c01000ea:	c3                   	ret    

c01000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000eb:	55                   	push   %ebp
c01000ec:	89 e5                	mov    %esp,%ebp
c01000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c01000f1:	8b 45 10             	mov    0x10(%ebp),%eax
c01000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01000f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01000fb:	89 04 24             	mov    %eax,(%esp)
c01000fe:	e8 bb ff ff ff       	call   c01000be <grade_backtrace1>
}
c0100103:	c9                   	leave  
c0100104:	c3                   	ret    

c0100105 <grade_backtrace>:

void
grade_backtrace(void) {
c0100105:	55                   	push   %ebp
c0100106:	89 e5                	mov    %esp,%ebp
c0100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010010b:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c0100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100117:	ff 
c0100118:	89 44 24 04          	mov    %eax,0x4(%esp)
c010011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100123:	e8 c3 ff ff ff       	call   c01000eb <grade_backtrace0>
}
c0100128:	c9                   	leave  
c0100129:	c3                   	ret    

c010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010012a:	55                   	push   %ebp
c010012b:	89 e5                	mov    %esp,%ebp
c010012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c010013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100140:	0f b7 c0             	movzwl %ax,%eax
c0100143:	83 e0 03             	and    $0x3,%eax
c0100146:	89 c2                	mov    %eax,%edx
c0100148:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010014d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100151:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100155:	c7 04 24 a1 5e 10 c0 	movl   $0xc0105ea1,(%esp)
c010015c:	e8 db 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100165:	0f b7 d0             	movzwl %ax,%edx
c0100168:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010016d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100171:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100175:	c7 04 24 af 5e 10 c0 	movl   $0xc0105eaf,(%esp)
c010017c:	e8 bb 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100185:	0f b7 d0             	movzwl %ax,%edx
c0100188:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010018d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100191:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100195:	c7 04 24 bd 5e 10 c0 	movl   $0xc0105ebd,(%esp)
c010019c:	e8 9b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001a5:	0f b7 d0             	movzwl %ax,%edx
c01001a8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b5:	c7 04 24 cb 5e 10 c0 	movl   $0xc0105ecb,(%esp)
c01001bc:	e8 7b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001c5:	0f b7 d0             	movzwl %ax,%edx
c01001c8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d5:	c7 04 24 d9 5e 10 c0 	movl   $0xc0105ed9,(%esp)
c01001dc:	e8 5b 01 00 00       	call   c010033c <cprintf>
    round ++;
c01001e1:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001e6:	83 c0 01             	add    $0x1,%eax
c01001e9:	a3 40 7a 11 c0       	mov    %eax,0xc0117a40
}
c01001ee:	c9                   	leave  
c01001ef:	c3                   	ret    

c01001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001f0:	55                   	push   %ebp
c01001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001f3:	5d                   	pop    %ebp
c01001f4:	c3                   	ret    

c01001f5 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001f5:	55                   	push   %ebp
c01001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c01001f8:	5d                   	pop    %ebp
c01001f9:	c3                   	ret    

c01001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
c01001fa:	55                   	push   %ebp
c01001fb:	89 e5                	mov    %esp,%ebp
c01001fd:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100200:	e8 25 ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100205:	c7 04 24 e8 5e 10 c0 	movl   $0xc0105ee8,(%esp)
c010020c:	e8 2b 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_user();
c0100211:	e8 da ff ff ff       	call   c01001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100216:	e8 0f ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010021b:	c7 04 24 08 5f 10 c0 	movl   $0xc0105f08,(%esp)
c0100222:	e8 15 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_kernel();
c0100227:	e8 c9 ff ff ff       	call   c01001f5 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010022c:	e8 f9 fe ff ff       	call   c010012a <lab1_print_cur_status>
}
c0100231:	c9                   	leave  
c0100232:	c3                   	ret    

c0100233 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100233:	55                   	push   %ebp
c0100234:	89 e5                	mov    %esp,%ebp
c0100236:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010023d:	74 13                	je     c0100252 <readline+0x1f>
        cprintf("%s", prompt);
c010023f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100242:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100246:	c7 04 24 27 5f 10 c0 	movl   $0xc0105f27,(%esp)
c010024d:	e8 ea 00 00 00       	call   c010033c <cprintf>
    }
    int i = 0, c;
c0100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100259:	e8 66 01 00 00       	call   c01003c4 <getchar>
c010025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100265:	79 07                	jns    c010026e <readline+0x3b>
            return NULL;
c0100267:	b8 00 00 00 00       	mov    $0x0,%eax
c010026c:	eb 79                	jmp    c01002e7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010026e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100272:	7e 28                	jle    c010029c <readline+0x69>
c0100274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010027b:	7f 1f                	jg     c010029c <readline+0x69>
            cputchar(c);
c010027d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100280:	89 04 24             	mov    %eax,(%esp)
c0100283:	e8 da 00 00 00       	call   c0100362 <cputchar>
            buf[i ++] = c;
c0100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010028b:	8d 50 01             	lea    0x1(%eax),%edx
c010028e:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100291:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100294:	88 90 60 7a 11 c0    	mov    %dl,-0x3fee85a0(%eax)
c010029a:	eb 46                	jmp    c01002e2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c010029c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002a0:	75 17                	jne    c01002b9 <readline+0x86>
c01002a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002a6:	7e 11                	jle    c01002b9 <readline+0x86>
            cputchar(c);
c01002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002ab:	89 04 24             	mov    %eax,(%esp)
c01002ae:	e8 af 00 00 00       	call   c0100362 <cputchar>
            i --;
c01002b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002b7:	eb 29                	jmp    c01002e2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002bd:	74 06                	je     c01002c5 <readline+0x92>
c01002bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002c3:	75 1d                	jne    c01002e2 <readline+0xaf>
            cputchar(c);
c01002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002c8:	89 04 24             	mov    %eax,(%esp)
c01002cb:	e8 92 00 00 00       	call   c0100362 <cputchar>
            buf[i] = '\0';
c01002d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002d3:	05 60 7a 11 c0       	add    $0xc0117a60,%eax
c01002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002db:	b8 60 7a 11 c0       	mov    $0xc0117a60,%eax
c01002e0:	eb 05                	jmp    c01002e7 <readline+0xb4>
        }
    }
c01002e2:	e9 72 ff ff ff       	jmp    c0100259 <readline+0x26>
}
c01002e7:	c9                   	leave  
c01002e8:	c3                   	ret    

c01002e9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002e9:	55                   	push   %ebp
c01002ea:	89 e5                	mov    %esp,%ebp
c01002ec:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01002f2:	89 04 24             	mov    %eax,(%esp)
c01002f5:	e8 fd 12 00 00       	call   c01015f7 <cons_putc>
    (*cnt) ++;
c01002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01002fd:	8b 00                	mov    (%eax),%eax
c01002ff:	8d 50 01             	lea    0x1(%eax),%edx
c0100302:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100305:	89 10                	mov    %edx,(%eax)
}
c0100307:	c9                   	leave  
c0100308:	c3                   	ret    

c0100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100309:	55                   	push   %ebp
c010030a:	89 e5                	mov    %esp,%ebp
c010030c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100316:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100319:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010031d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100320:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100324:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100327:	89 44 24 04          	mov    %eax,0x4(%esp)
c010032b:	c7 04 24 e9 02 10 c0 	movl   $0xc01002e9,(%esp)
c0100332:	e8 ca 51 00 00       	call   c0105501 <vprintfmt>
    return cnt;
c0100337:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010033a:	c9                   	leave  
c010033b:	c3                   	ret    

c010033c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010033c:	55                   	push   %ebp
c010033d:	89 e5                	mov    %esp,%ebp
c010033f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100342:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010034b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010034f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100352:	89 04 24             	mov    %eax,(%esp)
c0100355:	e8 af ff ff ff       	call   c0100309 <vcprintf>
c010035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100360:	c9                   	leave  
c0100361:	c3                   	ret    

c0100362 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100362:	55                   	push   %ebp
c0100363:	89 e5                	mov    %esp,%ebp
c0100365:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100368:	8b 45 08             	mov    0x8(%ebp),%eax
c010036b:	89 04 24             	mov    %eax,(%esp)
c010036e:	e8 84 12 00 00       	call   c01015f7 <cons_putc>
}
c0100373:	c9                   	leave  
c0100374:	c3                   	ret    

c0100375 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100375:	55                   	push   %ebp
c0100376:	89 e5                	mov    %esp,%ebp
c0100378:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100382:	eb 13                	jmp    c0100397 <cputs+0x22>
        cputch(c, &cnt);
c0100384:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100388:	8d 55 f0             	lea    -0x10(%ebp),%edx
c010038b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010038f:	89 04 24             	mov    %eax,(%esp)
c0100392:	e8 52 ff ff ff       	call   c01002e9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c0100397:	8b 45 08             	mov    0x8(%ebp),%eax
c010039a:	8d 50 01             	lea    0x1(%eax),%edx
c010039d:	89 55 08             	mov    %edx,0x8(%ebp)
c01003a0:	0f b6 00             	movzbl (%eax),%eax
c01003a3:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003a6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003aa:	75 d8                	jne    c0100384 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003af:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003ba:	e8 2a ff ff ff       	call   c01002e9 <cputch>
    return cnt;
c01003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003c2:	c9                   	leave  
c01003c3:	c3                   	ret    

c01003c4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003c4:	55                   	push   %ebp
c01003c5:	89 e5                	mov    %esp,%ebp
c01003c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003ca:	e8 64 12 00 00       	call   c0101633 <cons_getc>
c01003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003d6:	74 f2                	je     c01003ca <getchar+0x6>
        /* do nothing */;
    return c;
c01003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003db:	c9                   	leave  
c01003dc:	c3                   	ret    

c01003dd <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003dd:	55                   	push   %ebp
c01003de:	89 e5                	mov    %esp,%ebp
c01003e0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003e6:	8b 00                	mov    (%eax),%eax
c01003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01003ee:	8b 00                	mov    (%eax),%eax
c01003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01003f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01003fa:	e9 d2 00 00 00       	jmp    c01004d1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c01003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100402:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100405:	01 d0                	add    %edx,%eax
c0100407:	89 c2                	mov    %eax,%edx
c0100409:	c1 ea 1f             	shr    $0x1f,%edx
c010040c:	01 d0                	add    %edx,%eax
c010040e:	d1 f8                	sar    %eax
c0100410:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100413:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100416:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100419:	eb 04                	jmp    c010041f <stab_binsearch+0x42>
            m --;
c010041b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100422:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100425:	7c 1f                	jl     c0100446 <stab_binsearch+0x69>
c0100427:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010042a:	89 d0                	mov    %edx,%eax
c010042c:	01 c0                	add    %eax,%eax
c010042e:	01 d0                	add    %edx,%eax
c0100430:	c1 e0 02             	shl    $0x2,%eax
c0100433:	89 c2                	mov    %eax,%edx
c0100435:	8b 45 08             	mov    0x8(%ebp),%eax
c0100438:	01 d0                	add    %edx,%eax
c010043a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010043e:	0f b6 c0             	movzbl %al,%eax
c0100441:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100444:	75 d5                	jne    c010041b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100446:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100449:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010044c:	7d 0b                	jge    c0100459 <stab_binsearch+0x7c>
            l = true_m + 1;
c010044e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100451:	83 c0 01             	add    $0x1,%eax
c0100454:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100457:	eb 78                	jmp    c01004d1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100459:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100460:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100463:	89 d0                	mov    %edx,%eax
c0100465:	01 c0                	add    %eax,%eax
c0100467:	01 d0                	add    %edx,%eax
c0100469:	c1 e0 02             	shl    $0x2,%eax
c010046c:	89 c2                	mov    %eax,%edx
c010046e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100471:	01 d0                	add    %edx,%eax
c0100473:	8b 40 08             	mov    0x8(%eax),%eax
c0100476:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100479:	73 13                	jae    c010048e <stab_binsearch+0xb1>
            *region_left = m;
c010047b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010047e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100481:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100483:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100486:	83 c0 01             	add    $0x1,%eax
c0100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010048c:	eb 43                	jmp    c01004d1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100491:	89 d0                	mov    %edx,%eax
c0100493:	01 c0                	add    %eax,%eax
c0100495:	01 d0                	add    %edx,%eax
c0100497:	c1 e0 02             	shl    $0x2,%eax
c010049a:	89 c2                	mov    %eax,%edx
c010049c:	8b 45 08             	mov    0x8(%ebp),%eax
c010049f:	01 d0                	add    %edx,%eax
c01004a1:	8b 40 08             	mov    0x8(%eax),%eax
c01004a4:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004a7:	76 16                	jbe    c01004bf <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004af:	8b 45 10             	mov    0x10(%ebp),%eax
c01004b2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004b7:	83 e8 01             	sub    $0x1,%eax
c01004ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004bd:	eb 12                	jmp    c01004d1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004c5:	89 10                	mov    %edx,(%eax)
            l = m;
c01004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004cd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004d7:	0f 8e 22 ff ff ff    	jle    c01003ff <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004e1:	75 0f                	jne    c01004f2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004e6:	8b 00                	mov    (%eax),%eax
c01004e8:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01004ee:	89 10                	mov    %edx,(%eax)
c01004f0:	eb 3f                	jmp    c0100531 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01004f2:	8b 45 10             	mov    0x10(%ebp),%eax
c01004f5:	8b 00                	mov    (%eax),%eax
c01004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01004fa:	eb 04                	jmp    c0100500 <stab_binsearch+0x123>
c01004fc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c0100500:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100503:	8b 00                	mov    (%eax),%eax
c0100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100508:	7d 1f                	jge    c0100529 <stab_binsearch+0x14c>
c010050a:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010050d:	89 d0                	mov    %edx,%eax
c010050f:	01 c0                	add    %eax,%eax
c0100511:	01 d0                	add    %edx,%eax
c0100513:	c1 e0 02             	shl    $0x2,%eax
c0100516:	89 c2                	mov    %eax,%edx
c0100518:	8b 45 08             	mov    0x8(%ebp),%eax
c010051b:	01 d0                	add    %edx,%eax
c010051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100521:	0f b6 c0             	movzbl %al,%eax
c0100524:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100527:	75 d3                	jne    c01004fc <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100529:	8b 45 0c             	mov    0xc(%ebp),%eax
c010052c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010052f:	89 10                	mov    %edx,(%eax)
    }
}
c0100531:	c9                   	leave  
c0100532:	c3                   	ret    

c0100533 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100533:	55                   	push   %ebp
c0100534:	89 e5                	mov    %esp,%ebp
c0100536:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100539:	8b 45 0c             	mov    0xc(%ebp),%eax
c010053c:	c7 00 2c 5f 10 c0    	movl   $0xc0105f2c,(%eax)
    info->eip_line = 0;
c0100542:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010054c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010054f:	c7 40 08 2c 5f 10 c0 	movl   $0xc0105f2c,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100556:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100559:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100560:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100563:	8b 55 08             	mov    0x8(%ebp),%edx
c0100566:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100569:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100573:	c7 45 f4 58 71 10 c0 	movl   $0xc0107158,-0xc(%ebp)
    stab_end = __STAB_END__;
c010057a:	c7 45 f0 18 1d 11 c0 	movl   $0xc0111d18,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100581:	c7 45 ec 19 1d 11 c0 	movl   $0xc0111d19,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100588:	c7 45 e8 47 47 11 c0 	movl   $0xc0114747,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100595:	76 0d                	jbe    c01005a4 <debuginfo_eip+0x71>
c0100597:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010059a:	83 e8 01             	sub    $0x1,%eax
c010059d:	0f b6 00             	movzbl (%eax),%eax
c01005a0:	84 c0                	test   %al,%al
c01005a2:	74 0a                	je     c01005ae <debuginfo_eip+0x7b>
        return -1;
c01005a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005a9:	e9 c0 02 00 00       	jmp    c010086e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005bb:	29 c2                	sub    %eax,%edx
c01005bd:	89 d0                	mov    %edx,%eax
c01005bf:	c1 f8 02             	sar    $0x2,%eax
c01005c2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005c8:	83 e8 01             	sub    $0x1,%eax
c01005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01005d1:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005d5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005dc:	00 
c01005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005e0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005ee:	89 04 24             	mov    %eax,(%esp)
c01005f1:	e8 e7 fd ff ff       	call   c01003dd <stab_binsearch>
    if (lfile == 0)
c01005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01005f9:	85 c0                	test   %eax,%eax
c01005fb:	75 0a                	jne    c0100607 <debuginfo_eip+0xd4>
        return -1;
c01005fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100602:	e9 67 02 00 00       	jmp    c010086e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100610:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100613:	8b 45 08             	mov    0x8(%ebp),%eax
c0100616:	89 44 24 10          	mov    %eax,0x10(%esp)
c010061a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100621:	00 
c0100622:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100625:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100629:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010062c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100633:	89 04 24             	mov    %eax,(%esp)
c0100636:	e8 a2 fd ff ff       	call   c01003dd <stab_binsearch>

    if (lfun <= rfun) {
c010063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010063e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100641:	39 c2                	cmp    %eax,%edx
c0100643:	7f 7c                	jg     c01006c1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100648:	89 c2                	mov    %eax,%edx
c010064a:	89 d0                	mov    %edx,%eax
c010064c:	01 c0                	add    %eax,%eax
c010064e:	01 d0                	add    %edx,%eax
c0100650:	c1 e0 02             	shl    $0x2,%eax
c0100653:	89 c2                	mov    %eax,%edx
c0100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100658:	01 d0                	add    %edx,%eax
c010065a:	8b 10                	mov    (%eax),%edx
c010065c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100662:	29 c1                	sub    %eax,%ecx
c0100664:	89 c8                	mov    %ecx,%eax
c0100666:	39 c2                	cmp    %eax,%edx
c0100668:	73 22                	jae    c010068c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010066d:	89 c2                	mov    %eax,%edx
c010066f:	89 d0                	mov    %edx,%eax
c0100671:	01 c0                	add    %eax,%eax
c0100673:	01 d0                	add    %edx,%eax
c0100675:	c1 e0 02             	shl    $0x2,%eax
c0100678:	89 c2                	mov    %eax,%edx
c010067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010067d:	01 d0                	add    %edx,%eax
c010067f:	8b 10                	mov    (%eax),%edx
c0100681:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100684:	01 c2                	add    %eax,%edx
c0100686:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010068f:	89 c2                	mov    %eax,%edx
c0100691:	89 d0                	mov    %edx,%eax
c0100693:	01 c0                	add    %eax,%eax
c0100695:	01 d0                	add    %edx,%eax
c0100697:	c1 e0 02             	shl    $0x2,%eax
c010069a:	89 c2                	mov    %eax,%edx
c010069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010069f:	01 d0                	add    %edx,%eax
c01006a1:	8b 50 08             	mov    0x8(%eax),%edx
c01006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006a7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006ad:	8b 40 10             	mov    0x10(%eax),%eax
c01006b0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006bf:	eb 15                	jmp    c01006d6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006c4:	8b 55 08             	mov    0x8(%ebp),%edx
c01006c7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d9:	8b 40 08             	mov    0x8(%eax),%eax
c01006dc:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006e3:	00 
c01006e4:	89 04 24             	mov    %eax,(%esp)
c01006e7:	e8 70 54 00 00       	call   c0105b5c <strfind>
c01006ec:	89 c2                	mov    %eax,%edx
c01006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f1:	8b 40 08             	mov    0x8(%eax),%eax
c01006f4:	29 c2                	sub    %eax,%edx
c01006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01006fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100703:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c010070a:	00 
c010070b:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010070e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100712:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100715:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010071c:	89 04 24             	mov    %eax,(%esp)
c010071f:	e8 b9 fc ff ff       	call   c01003dd <stab_binsearch>
    if (lline <= rline) {
c0100724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100727:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010072a:	39 c2                	cmp    %eax,%edx
c010072c:	7f 24                	jg     c0100752 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c010072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100731:	89 c2                	mov    %eax,%edx
c0100733:	89 d0                	mov    %edx,%eax
c0100735:	01 c0                	add    %eax,%eax
c0100737:	01 d0                	add    %edx,%eax
c0100739:	c1 e0 02             	shl    $0x2,%eax
c010073c:	89 c2                	mov    %eax,%edx
c010073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100741:	01 d0                	add    %edx,%eax
c0100743:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100747:	0f b7 d0             	movzwl %ax,%edx
c010074a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010074d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100750:	eb 13                	jmp    c0100765 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100757:	e9 12 01 00 00       	jmp    c010086e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010075c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010075f:	83 e8 01             	sub    $0x1,%eax
c0100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010076b:	39 c2                	cmp    %eax,%edx
c010076d:	7c 56                	jl     c01007c5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c010076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100772:	89 c2                	mov    %eax,%edx
c0100774:	89 d0                	mov    %edx,%eax
c0100776:	01 c0                	add    %eax,%eax
c0100778:	01 d0                	add    %edx,%eax
c010077a:	c1 e0 02             	shl    $0x2,%eax
c010077d:	89 c2                	mov    %eax,%edx
c010077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100782:	01 d0                	add    %edx,%eax
c0100784:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100788:	3c 84                	cmp    $0x84,%al
c010078a:	74 39                	je     c01007c5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010078c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010078f:	89 c2                	mov    %eax,%edx
c0100791:	89 d0                	mov    %edx,%eax
c0100793:	01 c0                	add    %eax,%eax
c0100795:	01 d0                	add    %edx,%eax
c0100797:	c1 e0 02             	shl    $0x2,%eax
c010079a:	89 c2                	mov    %eax,%edx
c010079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010079f:	01 d0                	add    %edx,%eax
c01007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007a5:	3c 64                	cmp    $0x64,%al
c01007a7:	75 b3                	jne    c010075c <debuginfo_eip+0x229>
c01007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007ac:	89 c2                	mov    %eax,%edx
c01007ae:	89 d0                	mov    %edx,%eax
c01007b0:	01 c0                	add    %eax,%eax
c01007b2:	01 d0                	add    %edx,%eax
c01007b4:	c1 e0 02             	shl    $0x2,%eax
c01007b7:	89 c2                	mov    %eax,%edx
c01007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007bc:	01 d0                	add    %edx,%eax
c01007be:	8b 40 08             	mov    0x8(%eax),%eax
c01007c1:	85 c0                	test   %eax,%eax
c01007c3:	74 97                	je     c010075c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007cb:	39 c2                	cmp    %eax,%edx
c01007cd:	7c 46                	jl     c0100815 <debuginfo_eip+0x2e2>
c01007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007d2:	89 c2                	mov    %eax,%edx
c01007d4:	89 d0                	mov    %edx,%eax
c01007d6:	01 c0                	add    %eax,%eax
c01007d8:	01 d0                	add    %edx,%eax
c01007da:	c1 e0 02             	shl    $0x2,%eax
c01007dd:	89 c2                	mov    %eax,%edx
c01007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007e2:	01 d0                	add    %edx,%eax
c01007e4:	8b 10                	mov    (%eax),%edx
c01007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007ec:	29 c1                	sub    %eax,%ecx
c01007ee:	89 c8                	mov    %ecx,%eax
c01007f0:	39 c2                	cmp    %eax,%edx
c01007f2:	73 21                	jae    c0100815 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007f7:	89 c2                	mov    %eax,%edx
c01007f9:	89 d0                	mov    %edx,%eax
c01007fb:	01 c0                	add    %eax,%eax
c01007fd:	01 d0                	add    %edx,%eax
c01007ff:	c1 e0 02             	shl    $0x2,%eax
c0100802:	89 c2                	mov    %eax,%edx
c0100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100807:	01 d0                	add    %edx,%eax
c0100809:	8b 10                	mov    (%eax),%edx
c010080b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010080e:	01 c2                	add    %eax,%edx
c0100810:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100813:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100815:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100818:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010081b:	39 c2                	cmp    %eax,%edx
c010081d:	7d 4a                	jge    c0100869 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c010081f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100822:	83 c0 01             	add    $0x1,%eax
c0100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100828:	eb 18                	jmp    c0100842 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c010082a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010082d:	8b 40 14             	mov    0x14(%eax),%eax
c0100830:	8d 50 01             	lea    0x1(%eax),%edx
c0100833:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100836:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010083c:	83 c0 01             	add    $0x1,%eax
c010083f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100845:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100848:	39 c2                	cmp    %eax,%edx
c010084a:	7d 1d                	jge    c0100869 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010084f:	89 c2                	mov    %eax,%edx
c0100851:	89 d0                	mov    %edx,%eax
c0100853:	01 c0                	add    %eax,%eax
c0100855:	01 d0                	add    %edx,%eax
c0100857:	c1 e0 02             	shl    $0x2,%eax
c010085a:	89 c2                	mov    %eax,%edx
c010085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010085f:	01 d0                	add    %edx,%eax
c0100861:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100865:	3c a0                	cmp    $0xa0,%al
c0100867:	74 c1                	je     c010082a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100869:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010086e:	c9                   	leave  
c010086f:	c3                   	ret    

c0100870 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100870:	55                   	push   %ebp
c0100871:	89 e5                	mov    %esp,%ebp
c0100873:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100876:	c7 04 24 36 5f 10 c0 	movl   $0xc0105f36,(%esp)
c010087d:	e8 ba fa ff ff       	call   c010033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100882:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c0100889:	c0 
c010088a:	c7 04 24 4f 5f 10 c0 	movl   $0xc0105f4f,(%esp)
c0100891:	e8 a6 fa ff ff       	call   c010033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100896:	c7 44 24 04 71 5e 10 	movl   $0xc0105e71,0x4(%esp)
c010089d:	c0 
c010089e:	c7 04 24 67 5f 10 c0 	movl   $0xc0105f67,(%esp)
c01008a5:	e8 92 fa ff ff       	call   c010033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008aa:	c7 44 24 04 36 7a 11 	movl   $0xc0117a36,0x4(%esp)
c01008b1:	c0 
c01008b2:	c7 04 24 7f 5f 10 c0 	movl   $0xc0105f7f,(%esp)
c01008b9:	e8 7e fa ff ff       	call   c010033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008be:	c7 44 24 04 68 89 11 	movl   $0xc0118968,0x4(%esp)
c01008c5:	c0 
c01008c6:	c7 04 24 97 5f 10 c0 	movl   $0xc0105f97,(%esp)
c01008cd:	e8 6a fa ff ff       	call   c010033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008d2:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c01008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008dd:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01008e2:	29 c2                	sub    %eax,%edx
c01008e4:	89 d0                	mov    %edx,%eax
c01008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008ec:	85 c0                	test   %eax,%eax
c01008ee:	0f 48 c2             	cmovs  %edx,%eax
c01008f1:	c1 f8 0a             	sar    $0xa,%eax
c01008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01008f8:	c7 04 24 b0 5f 10 c0 	movl   $0xc0105fb0,(%esp)
c01008ff:	e8 38 fa ff ff       	call   c010033c <cprintf>
}
c0100904:	c9                   	leave  
c0100905:	c3                   	ret    

c0100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100906:	55                   	push   %ebp
c0100907:	89 e5                	mov    %esp,%ebp
c0100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100912:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100916:	8b 45 08             	mov    0x8(%ebp),%eax
c0100919:	89 04 24             	mov    %eax,(%esp)
c010091c:	e8 12 fc ff ff       	call   c0100533 <debuginfo_eip>
c0100921:	85 c0                	test   %eax,%eax
c0100923:	74 15                	je     c010093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100925:	8b 45 08             	mov    0x8(%ebp),%eax
c0100928:	89 44 24 04          	mov    %eax,0x4(%esp)
c010092c:	c7 04 24 da 5f 10 c0 	movl   $0xc0105fda,(%esp)
c0100933:	e8 04 fa ff ff       	call   c010033c <cprintf>
c0100938:	eb 6d                	jmp    c01009a7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100941:	eb 1c                	jmp    c010095f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100949:	01 d0                	add    %edx,%eax
c010094b:	0f b6 00             	movzbl (%eax),%eax
c010094e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100954:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100957:	01 ca                	add    %ecx,%edx
c0100959:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010095b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010095f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100965:	7f dc                	jg     c0100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100967:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c010096d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100970:	01 d0                	add    %edx,%eax
c0100972:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100975:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100978:	8b 55 08             	mov    0x8(%ebp),%edx
c010097b:	89 d1                	mov    %edx,%ecx
c010097d:	29 c1                	sub    %eax,%ecx
c010097f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100982:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100985:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100989:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010098f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100993:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100997:	89 44 24 04          	mov    %eax,0x4(%esp)
c010099b:	c7 04 24 f6 5f 10 c0 	movl   $0xc0105ff6,(%esp)
c01009a2:	e8 95 f9 ff ff       	call   c010033c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009a7:	c9                   	leave  
c01009a8:	c3                   	ret    

c01009a9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009a9:	55                   	push   %ebp
c01009aa:	89 e5                	mov    %esp,%ebp
c01009ac:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009af:	8b 45 04             	mov    0x4(%ebp),%eax
c01009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009b8:	c9                   	leave  
c01009b9:	c3                   	ret    

c01009ba <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009ba:	55                   	push   %ebp
c01009bb:	89 e5                	mov    %esp,%ebp
c01009bd:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009c0:	89 e8                	mov    %ebp,%eax
c01009c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
c01009c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
c01009c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip = read_eip();
c01009cb:	e8 d9 ff ff ff       	call   c01009a9 <read_eip>
c01009d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i;
	for (i = 0; i < STACKFRAME_DEPTH; ++i) {
c01009d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009da:	e9 8d 00 00 00       	jmp    c0100a6c <print_stackframe+0xb2>
		if (ebp == 0) break;
c01009df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01009e3:	75 05                	jne    c01009ea <print_stackframe+0x30>
c01009e5:	e9 8c 00 00 00       	jmp    c0100a76 <print_stackframe+0xbc>
		cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c01009ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009ed:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009f8:	c7 04 24 08 60 10 c0 	movl   $0xc0106008,(%esp)
c01009ff:	e8 38 f9 ff ff       	call   c010033c <cprintf>
		int j;
		for (j = 0; j < 4; ++j) cprintf("0x%08x ", ((uint32_t *) ebp + 2)[j]);
c0100a04:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a0b:	eb 28                	jmp    c0100a35 <print_stackframe+0x7b>
c0100a0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a10:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a1a:	01 d0                	add    %edx,%eax
c0100a1c:	83 c0 08             	add    $0x8,%eax
c0100a1f:	8b 00                	mov    (%eax),%eax
c0100a21:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a25:	c7 04 24 24 60 10 c0 	movl   $0xc0106024,(%esp)
c0100a2c:	e8 0b f9 ff ff       	call   c010033c <cprintf>
c0100a31:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100a35:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a39:	7e d2                	jle    c0100a0d <print_stackframe+0x53>
		cprintf("\n");
c0100a3b:	c7 04 24 2c 60 10 c0 	movl   $0xc010602c,(%esp)
c0100a42:	e8 f5 f8 ff ff       	call   c010033c <cprintf>
		print_debuginfo(eip - 1);
c0100a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a4a:	83 e8 01             	sub    $0x1,%eax
c0100a4d:	89 04 24             	mov    %eax,(%esp)
c0100a50:	e8 b1 fe ff ff       	call   c0100906 <print_debuginfo>
		eip = *((uint32_t *) ebp + 1);
c0100a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a58:	83 c0 04             	add    $0x4,%eax
c0100a5b:	8b 00                	mov    (%eax),%eax
c0100a5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp = *((uint32_t *) ebp);
c0100a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a63:	8b 00                	mov    (%eax),%eax
c0100a65:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
	uint32_t eip = read_eip();
	int i;
	for (i = 0; i < STACKFRAME_DEPTH; ++i) {
c0100a68:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a6c:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a70:	0f 8e 69 ff ff ff    	jle    c01009df <print_stackframe+0x25>
		cprintf("\n");
		print_debuginfo(eip - 1);
		eip = *((uint32_t *) ebp + 1);
		ebp = *((uint32_t *) ebp);
	}
}
c0100a76:	c9                   	leave  
c0100a77:	c3                   	ret    

c0100a78 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a78:	55                   	push   %ebp
c0100a79:	89 e5                	mov    %esp,%ebp
c0100a7b:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a7e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a85:	eb 0c                	jmp    c0100a93 <parse+0x1b>
            *buf ++ = '\0';
c0100a87:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a8a:	8d 50 01             	lea    0x1(%eax),%edx
c0100a8d:	89 55 08             	mov    %edx,0x8(%ebp)
c0100a90:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a93:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a96:	0f b6 00             	movzbl (%eax),%eax
c0100a99:	84 c0                	test   %al,%al
c0100a9b:	74 1d                	je     c0100aba <parse+0x42>
c0100a9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa0:	0f b6 00             	movzbl (%eax),%eax
c0100aa3:	0f be c0             	movsbl %al,%eax
c0100aa6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100aaa:	c7 04 24 b0 60 10 c0 	movl   $0xc01060b0,(%esp)
c0100ab1:	e8 73 50 00 00       	call   c0105b29 <strchr>
c0100ab6:	85 c0                	test   %eax,%eax
c0100ab8:	75 cd                	jne    c0100a87 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100aba:	8b 45 08             	mov    0x8(%ebp),%eax
c0100abd:	0f b6 00             	movzbl (%eax),%eax
c0100ac0:	84 c0                	test   %al,%al
c0100ac2:	75 02                	jne    c0100ac6 <parse+0x4e>
            break;
c0100ac4:	eb 67                	jmp    c0100b2d <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ac6:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100aca:	75 14                	jne    c0100ae0 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100acc:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100ad3:	00 
c0100ad4:	c7 04 24 b5 60 10 c0 	movl   $0xc01060b5,(%esp)
c0100adb:	e8 5c f8 ff ff       	call   c010033c <cprintf>
        }
        argv[argc ++] = buf;
c0100ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ae3:	8d 50 01             	lea    0x1(%eax),%edx
c0100ae6:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100ae9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100af0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100af3:	01 c2                	add    %eax,%edx
c0100af5:	8b 45 08             	mov    0x8(%ebp),%eax
c0100af8:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100afa:	eb 04                	jmp    c0100b00 <parse+0x88>
            buf ++;
c0100afc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b00:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b03:	0f b6 00             	movzbl (%eax),%eax
c0100b06:	84 c0                	test   %al,%al
c0100b08:	74 1d                	je     c0100b27 <parse+0xaf>
c0100b0a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b0d:	0f b6 00             	movzbl (%eax),%eax
c0100b10:	0f be c0             	movsbl %al,%eax
c0100b13:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b17:	c7 04 24 b0 60 10 c0 	movl   $0xc01060b0,(%esp)
c0100b1e:	e8 06 50 00 00       	call   c0105b29 <strchr>
c0100b23:	85 c0                	test   %eax,%eax
c0100b25:	74 d5                	je     c0100afc <parse+0x84>
            buf ++;
        }
    }
c0100b27:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b28:	e9 66 ff ff ff       	jmp    c0100a93 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b30:	c9                   	leave  
c0100b31:	c3                   	ret    

c0100b32 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b32:	55                   	push   %ebp
c0100b33:	89 e5                	mov    %esp,%ebp
c0100b35:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b38:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b3b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b42:	89 04 24             	mov    %eax,(%esp)
c0100b45:	e8 2e ff ff ff       	call   c0100a78 <parse>
c0100b4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b4d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b51:	75 0a                	jne    c0100b5d <runcmd+0x2b>
        return 0;
c0100b53:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b58:	e9 85 00 00 00       	jmp    c0100be2 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b64:	eb 5c                	jmp    c0100bc2 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b66:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b69:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b6c:	89 d0                	mov    %edx,%eax
c0100b6e:	01 c0                	add    %eax,%eax
c0100b70:	01 d0                	add    %edx,%eax
c0100b72:	c1 e0 02             	shl    $0x2,%eax
c0100b75:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100b7a:	8b 00                	mov    (%eax),%eax
c0100b7c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b80:	89 04 24             	mov    %eax,(%esp)
c0100b83:	e8 02 4f 00 00       	call   c0105a8a <strcmp>
c0100b88:	85 c0                	test   %eax,%eax
c0100b8a:	75 32                	jne    c0100bbe <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b8f:	89 d0                	mov    %edx,%eax
c0100b91:	01 c0                	add    %eax,%eax
c0100b93:	01 d0                	add    %edx,%eax
c0100b95:	c1 e0 02             	shl    $0x2,%eax
c0100b98:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100b9d:	8b 40 08             	mov    0x8(%eax),%eax
c0100ba0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100ba3:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100ba6:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100ba9:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bad:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100bb0:	83 c2 04             	add    $0x4,%edx
c0100bb3:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bb7:	89 0c 24             	mov    %ecx,(%esp)
c0100bba:	ff d0                	call   *%eax
c0100bbc:	eb 24                	jmp    c0100be2 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bbe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bc5:	83 f8 02             	cmp    $0x2,%eax
c0100bc8:	76 9c                	jbe    c0100b66 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bca:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bcd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bd1:	c7 04 24 d3 60 10 c0 	movl   $0xc01060d3,(%esp)
c0100bd8:	e8 5f f7 ff ff       	call   c010033c <cprintf>
    return 0;
c0100bdd:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100be2:	c9                   	leave  
c0100be3:	c3                   	ret    

c0100be4 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100be4:	55                   	push   %ebp
c0100be5:	89 e5                	mov    %esp,%ebp
c0100be7:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100bea:	c7 04 24 ec 60 10 c0 	movl   $0xc01060ec,(%esp)
c0100bf1:	e8 46 f7 ff ff       	call   c010033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100bf6:	c7 04 24 14 61 10 c0 	movl   $0xc0106114,(%esp)
c0100bfd:	e8 3a f7 ff ff       	call   c010033c <cprintf>

    if (tf != NULL) {
c0100c02:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c06:	74 0b                	je     c0100c13 <kmonitor+0x2f>
        print_trapframe(tf);
c0100c08:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c0b:	89 04 24             	mov    %eax,(%esp)
c0100c0e:	e8 cf 0d 00 00       	call   c01019e2 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c13:	c7 04 24 39 61 10 c0 	movl   $0xc0106139,(%esp)
c0100c1a:	e8 14 f6 ff ff       	call   c0100233 <readline>
c0100c1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c26:	74 18                	je     c0100c40 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c28:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c2b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c32:	89 04 24             	mov    %eax,(%esp)
c0100c35:	e8 f8 fe ff ff       	call   c0100b32 <runcmd>
c0100c3a:	85 c0                	test   %eax,%eax
c0100c3c:	79 02                	jns    c0100c40 <kmonitor+0x5c>
                break;
c0100c3e:	eb 02                	jmp    c0100c42 <kmonitor+0x5e>
            }
        }
    }
c0100c40:	eb d1                	jmp    c0100c13 <kmonitor+0x2f>
}
c0100c42:	c9                   	leave  
c0100c43:	c3                   	ret    

c0100c44 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c44:	55                   	push   %ebp
c0100c45:	89 e5                	mov    %esp,%ebp
c0100c47:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c4a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c51:	eb 3f                	jmp    c0100c92 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c53:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c56:	89 d0                	mov    %edx,%eax
c0100c58:	01 c0                	add    %eax,%eax
c0100c5a:	01 d0                	add    %edx,%eax
c0100c5c:	c1 e0 02             	shl    $0x2,%eax
c0100c5f:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c64:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c67:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c6a:	89 d0                	mov    %edx,%eax
c0100c6c:	01 c0                	add    %eax,%eax
c0100c6e:	01 d0                	add    %edx,%eax
c0100c70:	c1 e0 02             	shl    $0x2,%eax
c0100c73:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c78:	8b 00                	mov    (%eax),%eax
c0100c7a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c7e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c82:	c7 04 24 3d 61 10 c0 	movl   $0xc010613d,(%esp)
c0100c89:	e8 ae f6 ff ff       	call   c010033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c8e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c95:	83 f8 02             	cmp    $0x2,%eax
c0100c98:	76 b9                	jbe    c0100c53 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100c9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c9f:	c9                   	leave  
c0100ca0:	c3                   	ret    

c0100ca1 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100ca1:	55                   	push   %ebp
c0100ca2:	89 e5                	mov    %esp,%ebp
c0100ca4:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100ca7:	e8 c4 fb ff ff       	call   c0100870 <print_kerninfo>
    return 0;
c0100cac:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cb1:	c9                   	leave  
c0100cb2:	c3                   	ret    

c0100cb3 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cb3:	55                   	push   %ebp
c0100cb4:	89 e5                	mov    %esp,%ebp
c0100cb6:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cb9:	e8 fc fc ff ff       	call   c01009ba <print_stackframe>
    return 0;
c0100cbe:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cc3:	c9                   	leave  
c0100cc4:	c3                   	ret    

c0100cc5 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100cc5:	55                   	push   %ebp
c0100cc6:	89 e5                	mov    %esp,%ebp
c0100cc8:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100ccb:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
c0100cd0:	85 c0                	test   %eax,%eax
c0100cd2:	74 02                	je     c0100cd6 <__panic+0x11>
        goto panic_dead;
c0100cd4:	eb 48                	jmp    c0100d1e <__panic+0x59>
    }
    is_panic = 1;
c0100cd6:	c7 05 60 7e 11 c0 01 	movl   $0x1,0xc0117e60
c0100cdd:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100ce0:	8d 45 14             	lea    0x14(%ebp),%eax
c0100ce3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100ce6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100ce9:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100ced:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cf0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cf4:	c7 04 24 46 61 10 c0 	movl   $0xc0106146,(%esp)
c0100cfb:	e8 3c f6 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100d00:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d03:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d07:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d0a:	89 04 24             	mov    %eax,(%esp)
c0100d0d:	e8 f7 f5 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100d12:	c7 04 24 62 61 10 c0 	movl   $0xc0106162,(%esp)
c0100d19:	e8 1e f6 ff ff       	call   c010033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100d1e:	e8 85 09 00 00       	call   c01016a8 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d23:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d2a:	e8 b5 fe ff ff       	call   c0100be4 <kmonitor>
    }
c0100d2f:	eb f2                	jmp    c0100d23 <__panic+0x5e>

c0100d31 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d31:	55                   	push   %ebp
c0100d32:	89 e5                	mov    %esp,%ebp
c0100d34:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d37:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d40:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d44:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d47:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d4b:	c7 04 24 64 61 10 c0 	movl   $0xc0106164,(%esp)
c0100d52:	e8 e5 f5 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d5a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d5e:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d61:	89 04 24             	mov    %eax,(%esp)
c0100d64:	e8 a0 f5 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100d69:	c7 04 24 62 61 10 c0 	movl   $0xc0106162,(%esp)
c0100d70:	e8 c7 f5 ff ff       	call   c010033c <cprintf>
    va_end(ap);
}
c0100d75:	c9                   	leave  
c0100d76:	c3                   	ret    

c0100d77 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d77:	55                   	push   %ebp
c0100d78:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d7a:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
}
c0100d7f:	5d                   	pop    %ebp
c0100d80:	c3                   	ret    

c0100d81 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d81:	55                   	push   %ebp
c0100d82:	89 e5                	mov    %esp,%ebp
c0100d84:	83 ec 28             	sub    $0x28,%esp
c0100d87:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100d8d:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d91:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100d95:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100d99:	ee                   	out    %al,(%dx)
c0100d9a:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100da0:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100da4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100da8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100dac:	ee                   	out    %al,(%dx)
c0100dad:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100db3:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100db7:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dbb:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dbf:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dc0:	c7 05 4c 89 11 c0 00 	movl   $0x0,0xc011894c
c0100dc7:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100dca:	c7 04 24 82 61 10 c0 	movl   $0xc0106182,(%esp)
c0100dd1:	e8 66 f5 ff ff       	call   c010033c <cprintf>
    pic_enable(IRQ_TIMER);
c0100dd6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100ddd:	e8 24 09 00 00       	call   c0101706 <pic_enable>
}
c0100de2:	c9                   	leave  
c0100de3:	c3                   	ret    

c0100de4 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100de4:	55                   	push   %ebp
c0100de5:	89 e5                	mov    %esp,%ebp
c0100de7:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100dea:	9c                   	pushf  
c0100deb:	58                   	pop    %eax
c0100dec:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100def:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100df2:	25 00 02 00 00       	and    $0x200,%eax
c0100df7:	85 c0                	test   %eax,%eax
c0100df9:	74 0c                	je     c0100e07 <__intr_save+0x23>
        intr_disable();
c0100dfb:	e8 a8 08 00 00       	call   c01016a8 <intr_disable>
        return 1;
c0100e00:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e05:	eb 05                	jmp    c0100e0c <__intr_save+0x28>
    }
    return 0;
c0100e07:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e0c:	c9                   	leave  
c0100e0d:	c3                   	ret    

c0100e0e <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e0e:	55                   	push   %ebp
c0100e0f:	89 e5                	mov    %esp,%ebp
c0100e11:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e14:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e18:	74 05                	je     c0100e1f <__intr_restore+0x11>
        intr_enable();
c0100e1a:	e8 83 08 00 00       	call   c01016a2 <intr_enable>
    }
}
c0100e1f:	c9                   	leave  
c0100e20:	c3                   	ret    

c0100e21 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e21:	55                   	push   %ebp
c0100e22:	89 e5                	mov    %esp,%ebp
c0100e24:	83 ec 10             	sub    $0x10,%esp
c0100e27:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e2d:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e31:	89 c2                	mov    %eax,%edx
c0100e33:	ec                   	in     (%dx),%al
c0100e34:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e37:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e3d:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e41:	89 c2                	mov    %eax,%edx
c0100e43:	ec                   	in     (%dx),%al
c0100e44:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e47:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e4d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e51:	89 c2                	mov    %eax,%edx
c0100e53:	ec                   	in     (%dx),%al
c0100e54:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e57:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e5d:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e61:	89 c2                	mov    %eax,%edx
c0100e63:	ec                   	in     (%dx),%al
c0100e64:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e67:	c9                   	leave  
c0100e68:	c3                   	ret    

c0100e69 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e69:	55                   	push   %ebp
c0100e6a:	89 e5                	mov    %esp,%ebp
c0100e6c:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e6f:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e76:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e79:	0f b7 00             	movzwl (%eax),%eax
c0100e7c:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e80:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e83:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e88:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e8b:	0f b7 00             	movzwl (%eax),%eax
c0100e8e:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100e92:	74 12                	je     c0100ea6 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100e94:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100e9b:	66 c7 05 86 7e 11 c0 	movw   $0x3b4,0xc0117e86
c0100ea2:	b4 03 
c0100ea4:	eb 13                	jmp    c0100eb9 <cga_init+0x50>
    } else {
        *cp = was;
c0100ea6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ea9:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100ead:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100eb0:	66 c7 05 86 7e 11 c0 	movw   $0x3d4,0xc0117e86
c0100eb7:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100eb9:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ec0:	0f b7 c0             	movzwl %ax,%eax
c0100ec3:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100ec7:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ecb:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100ecf:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100ed3:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100ed4:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100edb:	83 c0 01             	add    $0x1,%eax
c0100ede:	0f b7 c0             	movzwl %ax,%eax
c0100ee1:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ee5:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100ee9:	89 c2                	mov    %eax,%edx
c0100eeb:	ec                   	in     (%dx),%al
c0100eec:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100eef:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100ef3:	0f b6 c0             	movzbl %al,%eax
c0100ef6:	c1 e0 08             	shl    $0x8,%eax
c0100ef9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100efc:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100f03:	0f b7 c0             	movzwl %ax,%eax
c0100f06:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f0a:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f0e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f12:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f16:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f17:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100f1e:	83 c0 01             	add    $0x1,%eax
c0100f21:	0f b7 c0             	movzwl %ax,%eax
c0100f24:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f28:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f2c:	89 c2                	mov    %eax,%edx
c0100f2e:	ec                   	in     (%dx),%al
c0100f2f:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f32:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f36:	0f b6 c0             	movzbl %al,%eax
c0100f39:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f3f:	a3 80 7e 11 c0       	mov    %eax,0xc0117e80
    crt_pos = pos;
c0100f44:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f47:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
}
c0100f4d:	c9                   	leave  
c0100f4e:	c3                   	ret    

c0100f4f <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f4f:	55                   	push   %ebp
c0100f50:	89 e5                	mov    %esp,%ebp
c0100f52:	83 ec 48             	sub    $0x48,%esp
c0100f55:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f5b:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f5f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f63:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f67:	ee                   	out    %al,(%dx)
c0100f68:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f6e:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f72:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f76:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f7a:	ee                   	out    %al,(%dx)
c0100f7b:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100f81:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100f85:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f89:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f8d:	ee                   	out    %al,(%dx)
c0100f8e:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100f94:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100f98:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f9c:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fa0:	ee                   	out    %al,(%dx)
c0100fa1:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fa7:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fab:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100faf:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fb3:	ee                   	out    %al,(%dx)
c0100fb4:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fba:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fbe:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fc2:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fc6:	ee                   	out    %al,(%dx)
c0100fc7:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fcd:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100fd1:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fd5:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100fd9:	ee                   	out    %al,(%dx)
c0100fda:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fe0:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100fe4:	89 c2                	mov    %eax,%edx
c0100fe6:	ec                   	in     (%dx),%al
c0100fe7:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0100fea:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100fee:	3c ff                	cmp    $0xff,%al
c0100ff0:	0f 95 c0             	setne  %al
c0100ff3:	0f b6 c0             	movzbl %al,%eax
c0100ff6:	a3 88 7e 11 c0       	mov    %eax,0xc0117e88
c0100ffb:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101001:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c0101005:	89 c2                	mov    %eax,%edx
c0101007:	ec                   	in     (%dx),%al
c0101008:	88 45 d5             	mov    %al,-0x2b(%ebp)
c010100b:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0101011:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0101015:	89 c2                	mov    %eax,%edx
c0101017:	ec                   	in     (%dx),%al
c0101018:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c010101b:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c0101020:	85 c0                	test   %eax,%eax
c0101022:	74 0c                	je     c0101030 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c0101024:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010102b:	e8 d6 06 00 00       	call   c0101706 <pic_enable>
    }
}
c0101030:	c9                   	leave  
c0101031:	c3                   	ret    

c0101032 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101032:	55                   	push   %ebp
c0101033:	89 e5                	mov    %esp,%ebp
c0101035:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101038:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010103f:	eb 09                	jmp    c010104a <lpt_putc_sub+0x18>
        delay();
c0101041:	e8 db fd ff ff       	call   c0100e21 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101046:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010104a:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101050:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101054:	89 c2                	mov    %eax,%edx
c0101056:	ec                   	in     (%dx),%al
c0101057:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010105a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010105e:	84 c0                	test   %al,%al
c0101060:	78 09                	js     c010106b <lpt_putc_sub+0x39>
c0101062:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101069:	7e d6                	jle    c0101041 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c010106b:	8b 45 08             	mov    0x8(%ebp),%eax
c010106e:	0f b6 c0             	movzbl %al,%eax
c0101071:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c0101077:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010107a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010107e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101082:	ee                   	out    %al,(%dx)
c0101083:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0101089:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c010108d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101091:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101095:	ee                   	out    %al,(%dx)
c0101096:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c010109c:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010a0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010a4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010a8:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010a9:	c9                   	leave  
c01010aa:	c3                   	ret    

c01010ab <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010ab:	55                   	push   %ebp
c01010ac:	89 e5                	mov    %esp,%ebp
c01010ae:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010b1:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010b5:	74 0d                	je     c01010c4 <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01010ba:	89 04 24             	mov    %eax,(%esp)
c01010bd:	e8 70 ff ff ff       	call   c0101032 <lpt_putc_sub>
c01010c2:	eb 24                	jmp    c01010e8 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010c4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010cb:	e8 62 ff ff ff       	call   c0101032 <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010d0:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010d7:	e8 56 ff ff ff       	call   c0101032 <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010dc:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010e3:	e8 4a ff ff ff       	call   c0101032 <lpt_putc_sub>
    }
}
c01010e8:	c9                   	leave  
c01010e9:	c3                   	ret    

c01010ea <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010ea:	55                   	push   %ebp
c01010eb:	89 e5                	mov    %esp,%ebp
c01010ed:	53                   	push   %ebx
c01010ee:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c01010f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01010f4:	b0 00                	mov    $0x0,%al
c01010f6:	85 c0                	test   %eax,%eax
c01010f8:	75 07                	jne    c0101101 <cga_putc+0x17>
        c |= 0x0700;
c01010fa:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101101:	8b 45 08             	mov    0x8(%ebp),%eax
c0101104:	0f b6 c0             	movzbl %al,%eax
c0101107:	83 f8 0a             	cmp    $0xa,%eax
c010110a:	74 4c                	je     c0101158 <cga_putc+0x6e>
c010110c:	83 f8 0d             	cmp    $0xd,%eax
c010110f:	74 57                	je     c0101168 <cga_putc+0x7e>
c0101111:	83 f8 08             	cmp    $0x8,%eax
c0101114:	0f 85 88 00 00 00    	jne    c01011a2 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c010111a:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101121:	66 85 c0             	test   %ax,%ax
c0101124:	74 30                	je     c0101156 <cga_putc+0x6c>
            crt_pos --;
c0101126:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010112d:	83 e8 01             	sub    $0x1,%eax
c0101130:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101136:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c010113b:	0f b7 15 84 7e 11 c0 	movzwl 0xc0117e84,%edx
c0101142:	0f b7 d2             	movzwl %dx,%edx
c0101145:	01 d2                	add    %edx,%edx
c0101147:	01 c2                	add    %eax,%edx
c0101149:	8b 45 08             	mov    0x8(%ebp),%eax
c010114c:	b0 00                	mov    $0x0,%al
c010114e:	83 c8 20             	or     $0x20,%eax
c0101151:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101154:	eb 72                	jmp    c01011c8 <cga_putc+0xde>
c0101156:	eb 70                	jmp    c01011c8 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c0101158:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010115f:	83 c0 50             	add    $0x50,%eax
c0101162:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101168:	0f b7 1d 84 7e 11 c0 	movzwl 0xc0117e84,%ebx
c010116f:	0f b7 0d 84 7e 11 c0 	movzwl 0xc0117e84,%ecx
c0101176:	0f b7 c1             	movzwl %cx,%eax
c0101179:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c010117f:	c1 e8 10             	shr    $0x10,%eax
c0101182:	89 c2                	mov    %eax,%edx
c0101184:	66 c1 ea 06          	shr    $0x6,%dx
c0101188:	89 d0                	mov    %edx,%eax
c010118a:	c1 e0 02             	shl    $0x2,%eax
c010118d:	01 d0                	add    %edx,%eax
c010118f:	c1 e0 04             	shl    $0x4,%eax
c0101192:	29 c1                	sub    %eax,%ecx
c0101194:	89 ca                	mov    %ecx,%edx
c0101196:	89 d8                	mov    %ebx,%eax
c0101198:	29 d0                	sub    %edx,%eax
c010119a:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
        break;
c01011a0:	eb 26                	jmp    c01011c8 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011a2:	8b 0d 80 7e 11 c0    	mov    0xc0117e80,%ecx
c01011a8:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011af:	8d 50 01             	lea    0x1(%eax),%edx
c01011b2:	66 89 15 84 7e 11 c0 	mov    %dx,0xc0117e84
c01011b9:	0f b7 c0             	movzwl %ax,%eax
c01011bc:	01 c0                	add    %eax,%eax
c01011be:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01011c4:	66 89 02             	mov    %ax,(%edx)
        break;
c01011c7:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011c8:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011cf:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011d3:	76 5b                	jbe    c0101230 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011d5:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011da:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011e0:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011e5:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01011ec:	00 
c01011ed:	89 54 24 04          	mov    %edx,0x4(%esp)
c01011f1:	89 04 24             	mov    %eax,(%esp)
c01011f4:	e8 2e 4b 00 00       	call   c0105d27 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01011f9:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101200:	eb 15                	jmp    c0101217 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c0101202:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c0101207:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010120a:	01 d2                	add    %edx,%edx
c010120c:	01 d0                	add    %edx,%eax
c010120e:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101213:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101217:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c010121e:	7e e2                	jle    c0101202 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101220:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101227:	83 e8 50             	sub    $0x50,%eax
c010122a:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101230:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0101237:	0f b7 c0             	movzwl %ax,%eax
c010123a:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c010123e:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c0101242:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101246:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010124a:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c010124b:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101252:	66 c1 e8 08          	shr    $0x8,%ax
c0101256:	0f b6 c0             	movzbl %al,%eax
c0101259:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c0101260:	83 c2 01             	add    $0x1,%edx
c0101263:	0f b7 d2             	movzwl %dx,%edx
c0101266:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c010126a:	88 45 ed             	mov    %al,-0x13(%ebp)
c010126d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101271:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101275:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101276:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c010127d:	0f b7 c0             	movzwl %ax,%eax
c0101280:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0101284:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c0101288:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010128c:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101290:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c0101291:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101298:	0f b6 c0             	movzbl %al,%eax
c010129b:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c01012a2:	83 c2 01             	add    $0x1,%edx
c01012a5:	0f b7 d2             	movzwl %dx,%edx
c01012a8:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012ac:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012af:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012b3:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012b7:	ee                   	out    %al,(%dx)
}
c01012b8:	83 c4 34             	add    $0x34,%esp
c01012bb:	5b                   	pop    %ebx
c01012bc:	5d                   	pop    %ebp
c01012bd:	c3                   	ret    

c01012be <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012be:	55                   	push   %ebp
c01012bf:	89 e5                	mov    %esp,%ebp
c01012c1:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012cb:	eb 09                	jmp    c01012d6 <serial_putc_sub+0x18>
        delay();
c01012cd:	e8 4f fb ff ff       	call   c0100e21 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012d2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012d6:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012dc:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012e0:	89 c2                	mov    %eax,%edx
c01012e2:	ec                   	in     (%dx),%al
c01012e3:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012e6:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01012ea:	0f b6 c0             	movzbl %al,%eax
c01012ed:	83 e0 20             	and    $0x20,%eax
c01012f0:	85 c0                	test   %eax,%eax
c01012f2:	75 09                	jne    c01012fd <serial_putc_sub+0x3f>
c01012f4:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01012fb:	7e d0                	jle    c01012cd <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c01012fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101300:	0f b6 c0             	movzbl %al,%eax
c0101303:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101309:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010130c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101310:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101314:	ee                   	out    %al,(%dx)
}
c0101315:	c9                   	leave  
c0101316:	c3                   	ret    

c0101317 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101317:	55                   	push   %ebp
c0101318:	89 e5                	mov    %esp,%ebp
c010131a:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c010131d:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101321:	74 0d                	je     c0101330 <serial_putc+0x19>
        serial_putc_sub(c);
c0101323:	8b 45 08             	mov    0x8(%ebp),%eax
c0101326:	89 04 24             	mov    %eax,(%esp)
c0101329:	e8 90 ff ff ff       	call   c01012be <serial_putc_sub>
c010132e:	eb 24                	jmp    c0101354 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101330:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101337:	e8 82 ff ff ff       	call   c01012be <serial_putc_sub>
        serial_putc_sub(' ');
c010133c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101343:	e8 76 ff ff ff       	call   c01012be <serial_putc_sub>
        serial_putc_sub('\b');
c0101348:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010134f:	e8 6a ff ff ff       	call   c01012be <serial_putc_sub>
    }
}
c0101354:	c9                   	leave  
c0101355:	c3                   	ret    

c0101356 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101356:	55                   	push   %ebp
c0101357:	89 e5                	mov    %esp,%ebp
c0101359:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c010135c:	eb 33                	jmp    c0101391 <cons_intr+0x3b>
        if (c != 0) {
c010135e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101362:	74 2d                	je     c0101391 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101364:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101369:	8d 50 01             	lea    0x1(%eax),%edx
c010136c:	89 15 a4 80 11 c0    	mov    %edx,0xc01180a4
c0101372:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101375:	88 90 a0 7e 11 c0    	mov    %dl,-0x3fee8160(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c010137b:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101380:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101385:	75 0a                	jne    c0101391 <cons_intr+0x3b>
                cons.wpos = 0;
c0101387:	c7 05 a4 80 11 c0 00 	movl   $0x0,0xc01180a4
c010138e:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c0101391:	8b 45 08             	mov    0x8(%ebp),%eax
c0101394:	ff d0                	call   *%eax
c0101396:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101399:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c010139d:	75 bf                	jne    c010135e <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c010139f:	c9                   	leave  
c01013a0:	c3                   	ret    

c01013a1 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013a1:	55                   	push   %ebp
c01013a2:	89 e5                	mov    %esp,%ebp
c01013a4:	83 ec 10             	sub    $0x10,%esp
c01013a7:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013ad:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013b1:	89 c2                	mov    %eax,%edx
c01013b3:	ec                   	in     (%dx),%al
c01013b4:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013b7:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013bb:	0f b6 c0             	movzbl %al,%eax
c01013be:	83 e0 01             	and    $0x1,%eax
c01013c1:	85 c0                	test   %eax,%eax
c01013c3:	75 07                	jne    c01013cc <serial_proc_data+0x2b>
        return -1;
c01013c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013ca:	eb 2a                	jmp    c01013f6 <serial_proc_data+0x55>
c01013cc:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013d2:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013d6:	89 c2                	mov    %eax,%edx
c01013d8:	ec                   	in     (%dx),%al
c01013d9:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013dc:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013e0:	0f b6 c0             	movzbl %al,%eax
c01013e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013e6:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013ea:	75 07                	jne    c01013f3 <serial_proc_data+0x52>
        c = '\b';
c01013ec:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01013f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01013f6:	c9                   	leave  
c01013f7:	c3                   	ret    

c01013f8 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c01013f8:	55                   	push   %ebp
c01013f9:	89 e5                	mov    %esp,%ebp
c01013fb:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c01013fe:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c0101403:	85 c0                	test   %eax,%eax
c0101405:	74 0c                	je     c0101413 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101407:	c7 04 24 a1 13 10 c0 	movl   $0xc01013a1,(%esp)
c010140e:	e8 43 ff ff ff       	call   c0101356 <cons_intr>
    }
}
c0101413:	c9                   	leave  
c0101414:	c3                   	ret    

c0101415 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101415:	55                   	push   %ebp
c0101416:	89 e5                	mov    %esp,%ebp
c0101418:	83 ec 38             	sub    $0x38,%esp
c010141b:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101421:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101425:	89 c2                	mov    %eax,%edx
c0101427:	ec                   	in     (%dx),%al
c0101428:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c010142b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c010142f:	0f b6 c0             	movzbl %al,%eax
c0101432:	83 e0 01             	and    $0x1,%eax
c0101435:	85 c0                	test   %eax,%eax
c0101437:	75 0a                	jne    c0101443 <kbd_proc_data+0x2e>
        return -1;
c0101439:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010143e:	e9 59 01 00 00       	jmp    c010159c <kbd_proc_data+0x187>
c0101443:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101449:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c010144d:	89 c2                	mov    %eax,%edx
c010144f:	ec                   	in     (%dx),%al
c0101450:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101453:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101457:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c010145a:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c010145e:	75 17                	jne    c0101477 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101460:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101465:	83 c8 40             	or     $0x40,%eax
c0101468:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c010146d:	b8 00 00 00 00       	mov    $0x0,%eax
c0101472:	e9 25 01 00 00       	jmp    c010159c <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c0101477:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010147b:	84 c0                	test   %al,%al
c010147d:	79 47                	jns    c01014c6 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c010147f:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101484:	83 e0 40             	and    $0x40,%eax
c0101487:	85 c0                	test   %eax,%eax
c0101489:	75 09                	jne    c0101494 <kbd_proc_data+0x7f>
c010148b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010148f:	83 e0 7f             	and    $0x7f,%eax
c0101492:	eb 04                	jmp    c0101498 <kbd_proc_data+0x83>
c0101494:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101498:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c010149b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010149f:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014a6:	83 c8 40             	or     $0x40,%eax
c01014a9:	0f b6 c0             	movzbl %al,%eax
c01014ac:	f7 d0                	not    %eax
c01014ae:	89 c2                	mov    %eax,%edx
c01014b0:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014b5:	21 d0                	and    %edx,%eax
c01014b7:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c01014bc:	b8 00 00 00 00       	mov    $0x0,%eax
c01014c1:	e9 d6 00 00 00       	jmp    c010159c <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014c6:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014cb:	83 e0 40             	and    $0x40,%eax
c01014ce:	85 c0                	test   %eax,%eax
c01014d0:	74 11                	je     c01014e3 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014d2:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014d6:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014db:	83 e0 bf             	and    $0xffffffbf,%eax
c01014de:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    }

    shift |= shiftcode[data];
c01014e3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014e7:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014ee:	0f b6 d0             	movzbl %al,%edx
c01014f1:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014f6:	09 d0                	or     %edx,%eax
c01014f8:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    shift ^= togglecode[data];
c01014fd:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101501:	0f b6 80 60 71 11 c0 	movzbl -0x3fee8ea0(%eax),%eax
c0101508:	0f b6 d0             	movzbl %al,%edx
c010150b:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101510:	31 d0                	xor    %edx,%eax
c0101512:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8

    c = charcode[shift & (CTL | SHIFT)][data];
c0101517:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010151c:	83 e0 03             	and    $0x3,%eax
c010151f:	8b 14 85 60 75 11 c0 	mov    -0x3fee8aa0(,%eax,4),%edx
c0101526:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010152a:	01 d0                	add    %edx,%eax
c010152c:	0f b6 00             	movzbl (%eax),%eax
c010152f:	0f b6 c0             	movzbl %al,%eax
c0101532:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101535:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010153a:	83 e0 08             	and    $0x8,%eax
c010153d:	85 c0                	test   %eax,%eax
c010153f:	74 22                	je     c0101563 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101541:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101545:	7e 0c                	jle    c0101553 <kbd_proc_data+0x13e>
c0101547:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c010154b:	7f 06                	jg     c0101553 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c010154d:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101551:	eb 10                	jmp    c0101563 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101553:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101557:	7e 0a                	jle    c0101563 <kbd_proc_data+0x14e>
c0101559:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c010155d:	7f 04                	jg     c0101563 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c010155f:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101563:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101568:	f7 d0                	not    %eax
c010156a:	83 e0 06             	and    $0x6,%eax
c010156d:	85 c0                	test   %eax,%eax
c010156f:	75 28                	jne    c0101599 <kbd_proc_data+0x184>
c0101571:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101578:	75 1f                	jne    c0101599 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c010157a:	c7 04 24 9d 61 10 c0 	movl   $0xc010619d,(%esp)
c0101581:	e8 b6 ed ff ff       	call   c010033c <cprintf>
c0101586:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c010158c:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101590:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101594:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c0101598:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c0101599:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010159c:	c9                   	leave  
c010159d:	c3                   	ret    

c010159e <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c010159e:	55                   	push   %ebp
c010159f:	89 e5                	mov    %esp,%ebp
c01015a1:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015a4:	c7 04 24 15 14 10 c0 	movl   $0xc0101415,(%esp)
c01015ab:	e8 a6 fd ff ff       	call   c0101356 <cons_intr>
}
c01015b0:	c9                   	leave  
c01015b1:	c3                   	ret    

c01015b2 <kbd_init>:

static void
kbd_init(void) {
c01015b2:	55                   	push   %ebp
c01015b3:	89 e5                	mov    %esp,%ebp
c01015b5:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015b8:	e8 e1 ff ff ff       	call   c010159e <kbd_intr>
    pic_enable(IRQ_KBD);
c01015bd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015c4:	e8 3d 01 00 00       	call   c0101706 <pic_enable>
}
c01015c9:	c9                   	leave  
c01015ca:	c3                   	ret    

c01015cb <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015cb:	55                   	push   %ebp
c01015cc:	89 e5                	mov    %esp,%ebp
c01015ce:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015d1:	e8 93 f8 ff ff       	call   c0100e69 <cga_init>
    serial_init();
c01015d6:	e8 74 f9 ff ff       	call   c0100f4f <serial_init>
    kbd_init();
c01015db:	e8 d2 ff ff ff       	call   c01015b2 <kbd_init>
    if (!serial_exists) {
c01015e0:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c01015e5:	85 c0                	test   %eax,%eax
c01015e7:	75 0c                	jne    c01015f5 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c01015e9:	c7 04 24 a9 61 10 c0 	movl   $0xc01061a9,(%esp)
c01015f0:	e8 47 ed ff ff       	call   c010033c <cprintf>
    }
}
c01015f5:	c9                   	leave  
c01015f6:	c3                   	ret    

c01015f7 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c01015f7:	55                   	push   %ebp
c01015f8:	89 e5                	mov    %esp,%ebp
c01015fa:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01015fd:	e8 e2 f7 ff ff       	call   c0100de4 <__intr_save>
c0101602:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101605:	8b 45 08             	mov    0x8(%ebp),%eax
c0101608:	89 04 24             	mov    %eax,(%esp)
c010160b:	e8 9b fa ff ff       	call   c01010ab <lpt_putc>
        cga_putc(c);
c0101610:	8b 45 08             	mov    0x8(%ebp),%eax
c0101613:	89 04 24             	mov    %eax,(%esp)
c0101616:	e8 cf fa ff ff       	call   c01010ea <cga_putc>
        serial_putc(c);
c010161b:	8b 45 08             	mov    0x8(%ebp),%eax
c010161e:	89 04 24             	mov    %eax,(%esp)
c0101621:	e8 f1 fc ff ff       	call   c0101317 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101626:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101629:	89 04 24             	mov    %eax,(%esp)
c010162c:	e8 dd f7 ff ff       	call   c0100e0e <__intr_restore>
}
c0101631:	c9                   	leave  
c0101632:	c3                   	ret    

c0101633 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101633:	55                   	push   %ebp
c0101634:	89 e5                	mov    %esp,%ebp
c0101636:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101639:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101640:	e8 9f f7 ff ff       	call   c0100de4 <__intr_save>
c0101645:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101648:	e8 ab fd ff ff       	call   c01013f8 <serial_intr>
        kbd_intr();
c010164d:	e8 4c ff ff ff       	call   c010159e <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101652:	8b 15 a0 80 11 c0    	mov    0xc01180a0,%edx
c0101658:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c010165d:	39 c2                	cmp    %eax,%edx
c010165f:	74 31                	je     c0101692 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101661:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c0101666:	8d 50 01             	lea    0x1(%eax),%edx
c0101669:	89 15 a0 80 11 c0    	mov    %edx,0xc01180a0
c010166f:	0f b6 80 a0 7e 11 c0 	movzbl -0x3fee8160(%eax),%eax
c0101676:	0f b6 c0             	movzbl %al,%eax
c0101679:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c010167c:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c0101681:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101686:	75 0a                	jne    c0101692 <cons_getc+0x5f>
                cons.rpos = 0;
c0101688:	c7 05 a0 80 11 c0 00 	movl   $0x0,0xc01180a0
c010168f:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101692:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101695:	89 04 24             	mov    %eax,(%esp)
c0101698:	e8 71 f7 ff ff       	call   c0100e0e <__intr_restore>
    return c;
c010169d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016a0:	c9                   	leave  
c01016a1:	c3                   	ret    

c01016a2 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c01016a2:	55                   	push   %ebp
c01016a3:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c01016a5:	fb                   	sti    
    sti();
}
c01016a6:	5d                   	pop    %ebp
c01016a7:	c3                   	ret    

c01016a8 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c01016a8:	55                   	push   %ebp
c01016a9:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c01016ab:	fa                   	cli    
    cli();
}
c01016ac:	5d                   	pop    %ebp
c01016ad:	c3                   	ret    

c01016ae <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016ae:	55                   	push   %ebp
c01016af:	89 e5                	mov    %esp,%ebp
c01016b1:	83 ec 14             	sub    $0x14,%esp
c01016b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01016b7:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016bb:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016bf:	66 a3 70 75 11 c0    	mov    %ax,0xc0117570
    if (did_init) {
c01016c5:	a1 ac 80 11 c0       	mov    0xc01180ac,%eax
c01016ca:	85 c0                	test   %eax,%eax
c01016cc:	74 36                	je     c0101704 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016ce:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016d2:	0f b6 c0             	movzbl %al,%eax
c01016d5:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01016db:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01016de:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01016e2:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01016e6:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c01016e7:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016eb:	66 c1 e8 08          	shr    $0x8,%ax
c01016ef:	0f b6 c0             	movzbl %al,%eax
c01016f2:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c01016f8:	88 45 f9             	mov    %al,-0x7(%ebp)
c01016fb:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01016ff:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101703:	ee                   	out    %al,(%dx)
    }
}
c0101704:	c9                   	leave  
c0101705:	c3                   	ret    

c0101706 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101706:	55                   	push   %ebp
c0101707:	89 e5                	mov    %esp,%ebp
c0101709:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c010170c:	8b 45 08             	mov    0x8(%ebp),%eax
c010170f:	ba 01 00 00 00       	mov    $0x1,%edx
c0101714:	89 c1                	mov    %eax,%ecx
c0101716:	d3 e2                	shl    %cl,%edx
c0101718:	89 d0                	mov    %edx,%eax
c010171a:	f7 d0                	not    %eax
c010171c:	89 c2                	mov    %eax,%edx
c010171e:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101725:	21 d0                	and    %edx,%eax
c0101727:	0f b7 c0             	movzwl %ax,%eax
c010172a:	89 04 24             	mov    %eax,(%esp)
c010172d:	e8 7c ff ff ff       	call   c01016ae <pic_setmask>
}
c0101732:	c9                   	leave  
c0101733:	c3                   	ret    

c0101734 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101734:	55                   	push   %ebp
c0101735:	89 e5                	mov    %esp,%ebp
c0101737:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c010173a:	c7 05 ac 80 11 c0 01 	movl   $0x1,0xc01180ac
c0101741:	00 00 00 
c0101744:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c010174a:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c010174e:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101752:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101756:	ee                   	out    %al,(%dx)
c0101757:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c010175d:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c0101761:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101765:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101769:	ee                   	out    %al,(%dx)
c010176a:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101770:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c0101774:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101778:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010177c:	ee                   	out    %al,(%dx)
c010177d:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c0101783:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c0101787:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010178b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010178f:	ee                   	out    %al,(%dx)
c0101790:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c0101796:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c010179a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010179e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01017a2:	ee                   	out    %al,(%dx)
c01017a3:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c01017a9:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c01017ad:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01017b1:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017b5:	ee                   	out    %al,(%dx)
c01017b6:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c01017bc:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c01017c0:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01017c4:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01017c8:	ee                   	out    %al,(%dx)
c01017c9:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c01017cf:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c01017d3:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017d7:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01017db:	ee                   	out    %al,(%dx)
c01017dc:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c01017e2:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c01017e6:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017ea:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01017ee:	ee                   	out    %al,(%dx)
c01017ef:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c01017f5:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c01017f9:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c01017fd:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101801:	ee                   	out    %al,(%dx)
c0101802:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c0101808:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c010180c:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101810:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101814:	ee                   	out    %al,(%dx)
c0101815:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c010181b:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c010181f:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101823:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101827:	ee                   	out    %al,(%dx)
c0101828:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c010182e:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c0101832:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101836:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c010183a:	ee                   	out    %al,(%dx)
c010183b:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c0101841:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c0101845:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101849:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c010184d:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c010184e:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101855:	66 83 f8 ff          	cmp    $0xffff,%ax
c0101859:	74 12                	je     c010186d <pic_init+0x139>
        pic_setmask(irq_mask);
c010185b:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101862:	0f b7 c0             	movzwl %ax,%eax
c0101865:	89 04 24             	mov    %eax,(%esp)
c0101868:	e8 41 fe ff ff       	call   c01016ae <pic_setmask>
    }
}
c010186d:	c9                   	leave  
c010186e:	c3                   	ret    

c010186f <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c010186f:	55                   	push   %ebp
c0101870:	89 e5                	mov    %esp,%ebp
c0101872:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0101875:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c010187c:	00 
c010187d:	c7 04 24 e0 61 10 c0 	movl   $0xc01061e0,(%esp)
c0101884:	e8 b3 ea ff ff       	call   c010033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c0101889:	c9                   	leave  
c010188a:	c3                   	ret    

c010188b <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c010188b:	55                   	push   %ebp
c010188c:	89 e5                	mov    %esp,%ebp
c010188e:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	   extern uintptr_t __vectors[];
	    int i;
	    for (i = 0; i < 256; i++)
c0101891:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101898:	e9 e2 00 00 00       	jmp    c010197f <idt_init+0xf4>
	        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], i == T_SYSCALL ? DPL_USER : DPL_KERNEL);
c010189d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018a0:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c01018a7:	89 c2                	mov    %eax,%edx
c01018a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018ac:	66 89 14 c5 c0 80 11 	mov    %dx,-0x3fee7f40(,%eax,8)
c01018b3:	c0 
c01018b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018b7:	66 c7 04 c5 c2 80 11 	movw   $0x8,-0x3fee7f3e(,%eax,8)
c01018be:	c0 08 00 
c01018c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018c4:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01018cb:	c0 
c01018cc:	83 e2 e0             	and    $0xffffffe0,%edx
c01018cf:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c01018d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018d9:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01018e0:	c0 
c01018e1:	83 e2 1f             	and    $0x1f,%edx
c01018e4:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c01018eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018ee:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c01018f5:	c0 
c01018f6:	83 e2 f0             	and    $0xfffffff0,%edx
c01018f9:	83 ca 0e             	or     $0xe,%edx
c01018fc:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101903:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101906:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c010190d:	c0 
c010190e:	83 e2 ef             	and    $0xffffffef,%edx
c0101911:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101918:	81 7d fc 80 00 00 00 	cmpl   $0x80,-0x4(%ebp)
c010191f:	75 07                	jne    c0101928 <idt_init+0x9d>
c0101921:	ba 03 00 00 00       	mov    $0x3,%edx
c0101926:	eb 05                	jmp    c010192d <idt_init+0xa2>
c0101928:	ba 00 00 00 00       	mov    $0x0,%edx
c010192d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101930:	83 e2 03             	and    $0x3,%edx
c0101933:	89 d1                	mov    %edx,%ecx
c0101935:	c1 e1 05             	shl    $0x5,%ecx
c0101938:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c010193f:	c0 
c0101940:	83 e2 9f             	and    $0xffffff9f,%edx
c0101943:	09 ca                	or     %ecx,%edx
c0101945:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c010194c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010194f:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101956:	c0 
c0101957:	83 ca 80             	or     $0xffffff80,%edx
c010195a:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101961:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101964:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c010196b:	c1 e8 10             	shr    $0x10,%eax
c010196e:	89 c2                	mov    %eax,%edx
c0101970:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101973:	66 89 14 c5 c6 80 11 	mov    %dx,-0x3fee7f3a(,%eax,8)
c010197a:	c0 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	   extern uintptr_t __vectors[];
	    int i;
	    for (i = 0; i < 256; i++)
c010197b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010197f:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0101986:	0f 8e 11 ff ff ff    	jle    c010189d <idt_init+0x12>
c010198c:	c7 45 f8 80 75 11 c0 	movl   $0xc0117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101993:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101996:	0f 01 18             	lidtl  (%eax)
	        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], i == T_SYSCALL ? DPL_USER : DPL_KERNEL);
	    lidt(&idt_pd);
}
c0101999:	c9                   	leave  
c010199a:	c3                   	ret    

c010199b <trapname>:

static const char *
trapname(int trapno) {
c010199b:	55                   	push   %ebp
c010199c:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c010199e:	8b 45 08             	mov    0x8(%ebp),%eax
c01019a1:	83 f8 13             	cmp    $0x13,%eax
c01019a4:	77 0c                	ja     c01019b2 <trapname+0x17>
        return excnames[trapno];
c01019a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01019a9:	8b 04 85 40 65 10 c0 	mov    -0x3fef9ac0(,%eax,4),%eax
c01019b0:	eb 18                	jmp    c01019ca <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c01019b2:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c01019b6:	7e 0d                	jle    c01019c5 <trapname+0x2a>
c01019b8:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c01019bc:	7f 07                	jg     c01019c5 <trapname+0x2a>
        return "Hardware Interrupt";
c01019be:	b8 ea 61 10 c0       	mov    $0xc01061ea,%eax
c01019c3:	eb 05                	jmp    c01019ca <trapname+0x2f>
    }
    return "(unknown trap)";
c01019c5:	b8 fd 61 10 c0       	mov    $0xc01061fd,%eax
}
c01019ca:	5d                   	pop    %ebp
c01019cb:	c3                   	ret    

c01019cc <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c01019cc:	55                   	push   %ebp
c01019cd:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c01019cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01019d2:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01019d6:	66 83 f8 08          	cmp    $0x8,%ax
c01019da:	0f 94 c0             	sete   %al
c01019dd:	0f b6 c0             	movzbl %al,%eax
}
c01019e0:	5d                   	pop    %ebp
c01019e1:	c3                   	ret    

c01019e2 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c01019e2:	55                   	push   %ebp
c01019e3:	89 e5                	mov    %esp,%ebp
c01019e5:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c01019e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01019eb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019ef:	c7 04 24 3e 62 10 c0 	movl   $0xc010623e,(%esp)
c01019f6:	e8 41 e9 ff ff       	call   c010033c <cprintf>
    print_regs(&tf->tf_regs);
c01019fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01019fe:	89 04 24             	mov    %eax,(%esp)
c0101a01:	e8 a1 01 00 00       	call   c0101ba7 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101a06:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a09:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101a0d:	0f b7 c0             	movzwl %ax,%eax
c0101a10:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a14:	c7 04 24 4f 62 10 c0 	movl   $0xc010624f,(%esp)
c0101a1b:	e8 1c e9 ff ff       	call   c010033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101a20:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a23:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101a27:	0f b7 c0             	movzwl %ax,%eax
c0101a2a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a2e:	c7 04 24 62 62 10 c0 	movl   $0xc0106262,(%esp)
c0101a35:	e8 02 e9 ff ff       	call   c010033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101a3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a3d:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101a41:	0f b7 c0             	movzwl %ax,%eax
c0101a44:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a48:	c7 04 24 75 62 10 c0 	movl   $0xc0106275,(%esp)
c0101a4f:	e8 e8 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101a54:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a57:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101a5b:	0f b7 c0             	movzwl %ax,%eax
c0101a5e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a62:	c7 04 24 88 62 10 c0 	movl   $0xc0106288,(%esp)
c0101a69:	e8 ce e8 ff ff       	call   c010033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101a6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a71:	8b 40 30             	mov    0x30(%eax),%eax
c0101a74:	89 04 24             	mov    %eax,(%esp)
c0101a77:	e8 1f ff ff ff       	call   c010199b <trapname>
c0101a7c:	8b 55 08             	mov    0x8(%ebp),%edx
c0101a7f:	8b 52 30             	mov    0x30(%edx),%edx
c0101a82:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101a86:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101a8a:	c7 04 24 9b 62 10 c0 	movl   $0xc010629b,(%esp)
c0101a91:	e8 a6 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101a96:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a99:	8b 40 34             	mov    0x34(%eax),%eax
c0101a9c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101aa0:	c7 04 24 ad 62 10 c0 	movl   $0xc01062ad,(%esp)
c0101aa7:	e8 90 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101aac:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aaf:	8b 40 38             	mov    0x38(%eax),%eax
c0101ab2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ab6:	c7 04 24 bc 62 10 c0 	movl   $0xc01062bc,(%esp)
c0101abd:	e8 7a e8 ff ff       	call   c010033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101ac2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ac5:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101ac9:	0f b7 c0             	movzwl %ax,%eax
c0101acc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ad0:	c7 04 24 cb 62 10 c0 	movl   $0xc01062cb,(%esp)
c0101ad7:	e8 60 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101adc:	8b 45 08             	mov    0x8(%ebp),%eax
c0101adf:	8b 40 40             	mov    0x40(%eax),%eax
c0101ae2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ae6:	c7 04 24 de 62 10 c0 	movl   $0xc01062de,(%esp)
c0101aed:	e8 4a e8 ff ff       	call   c010033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101af2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101af9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101b00:	eb 3e                	jmp    c0101b40 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101b02:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b05:	8b 50 40             	mov    0x40(%eax),%edx
c0101b08:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101b0b:	21 d0                	and    %edx,%eax
c0101b0d:	85 c0                	test   %eax,%eax
c0101b0f:	74 28                	je     c0101b39 <print_trapframe+0x157>
c0101b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b14:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101b1b:	85 c0                	test   %eax,%eax
c0101b1d:	74 1a                	je     c0101b39 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0101b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b22:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101b29:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b2d:	c7 04 24 ed 62 10 c0 	movl   $0xc01062ed,(%esp)
c0101b34:	e8 03 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b39:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101b3d:	d1 65 f0             	shll   -0x10(%ebp)
c0101b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b43:	83 f8 17             	cmp    $0x17,%eax
c0101b46:	76 ba                	jbe    c0101b02 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101b48:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b4b:	8b 40 40             	mov    0x40(%eax),%eax
c0101b4e:	25 00 30 00 00       	and    $0x3000,%eax
c0101b53:	c1 e8 0c             	shr    $0xc,%eax
c0101b56:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b5a:	c7 04 24 f1 62 10 c0 	movl   $0xc01062f1,(%esp)
c0101b61:	e8 d6 e7 ff ff       	call   c010033c <cprintf>

    if (!trap_in_kernel(tf)) {
c0101b66:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b69:	89 04 24             	mov    %eax,(%esp)
c0101b6c:	e8 5b fe ff ff       	call   c01019cc <trap_in_kernel>
c0101b71:	85 c0                	test   %eax,%eax
c0101b73:	75 30                	jne    c0101ba5 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101b75:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b78:	8b 40 44             	mov    0x44(%eax),%eax
c0101b7b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b7f:	c7 04 24 fa 62 10 c0 	movl   $0xc01062fa,(%esp)
c0101b86:	e8 b1 e7 ff ff       	call   c010033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101b8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b8e:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101b92:	0f b7 c0             	movzwl %ax,%eax
c0101b95:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b99:	c7 04 24 09 63 10 c0 	movl   $0xc0106309,(%esp)
c0101ba0:	e8 97 e7 ff ff       	call   c010033c <cprintf>
    }
}
c0101ba5:	c9                   	leave  
c0101ba6:	c3                   	ret    

c0101ba7 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101ba7:	55                   	push   %ebp
c0101ba8:	89 e5                	mov    %esp,%ebp
c0101baa:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101bad:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bb0:	8b 00                	mov    (%eax),%eax
c0101bb2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bb6:	c7 04 24 1c 63 10 c0 	movl   $0xc010631c,(%esp)
c0101bbd:	e8 7a e7 ff ff       	call   c010033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101bc2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bc5:	8b 40 04             	mov    0x4(%eax),%eax
c0101bc8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bcc:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c0101bd3:	e8 64 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101bd8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bdb:	8b 40 08             	mov    0x8(%eax),%eax
c0101bde:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101be2:	c7 04 24 3a 63 10 c0 	movl   $0xc010633a,(%esp)
c0101be9:	e8 4e e7 ff ff       	call   c010033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101bee:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bf1:	8b 40 0c             	mov    0xc(%eax),%eax
c0101bf4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bf8:	c7 04 24 49 63 10 c0 	movl   $0xc0106349,(%esp)
c0101bff:	e8 38 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101c04:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c07:	8b 40 10             	mov    0x10(%eax),%eax
c0101c0a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c0e:	c7 04 24 58 63 10 c0 	movl   $0xc0106358,(%esp)
c0101c15:	e8 22 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101c1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c1d:	8b 40 14             	mov    0x14(%eax),%eax
c0101c20:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c24:	c7 04 24 67 63 10 c0 	movl   $0xc0106367,(%esp)
c0101c2b:	e8 0c e7 ff ff       	call   c010033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101c30:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c33:	8b 40 18             	mov    0x18(%eax),%eax
c0101c36:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c3a:	c7 04 24 76 63 10 c0 	movl   $0xc0106376,(%esp)
c0101c41:	e8 f6 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101c46:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c49:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101c4c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c50:	c7 04 24 85 63 10 c0 	movl   $0xc0106385,(%esp)
c0101c57:	e8 e0 e6 ff ff       	call   c010033c <cprintf>
}
c0101c5c:	c9                   	leave  
c0101c5d:	c3                   	ret    

c0101c5e <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101c5e:	55                   	push   %ebp
c0101c5f:	89 e5                	mov    %esp,%ebp
c0101c61:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101c64:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c67:	8b 40 30             	mov    0x30(%eax),%eax
c0101c6a:	83 f8 2f             	cmp    $0x2f,%eax
c0101c6d:	77 1d                	ja     c0101c8c <trap_dispatch+0x2e>
c0101c6f:	83 f8 2e             	cmp    $0x2e,%eax
c0101c72:	0f 83 ed 00 00 00    	jae    c0101d65 <trap_dispatch+0x107>
c0101c78:	83 f8 21             	cmp    $0x21,%eax
c0101c7b:	74 6e                	je     c0101ceb <trap_dispatch+0x8d>
c0101c7d:	83 f8 24             	cmp    $0x24,%eax
c0101c80:	74 43                	je     c0101cc5 <trap_dispatch+0x67>
c0101c82:	83 f8 20             	cmp    $0x20,%eax
c0101c85:	74 13                	je     c0101c9a <trap_dispatch+0x3c>
c0101c87:	e9 a1 00 00 00       	jmp    c0101d2d <trap_dispatch+0xcf>
c0101c8c:	83 e8 78             	sub    $0x78,%eax
c0101c8f:	83 f8 01             	cmp    $0x1,%eax
c0101c92:	0f 87 95 00 00 00    	ja     c0101d2d <trap_dispatch+0xcf>
c0101c98:	eb 77                	jmp    c0101d11 <trap_dispatch+0xb3>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
    	if (++ticks == TICK_NUM) {
c0101c9a:	a1 4c 89 11 c0       	mov    0xc011894c,%eax
c0101c9f:	83 c0 01             	add    $0x1,%eax
c0101ca2:	a3 4c 89 11 c0       	mov    %eax,0xc011894c
c0101ca7:	83 f8 64             	cmp    $0x64,%eax
c0101caa:	75 14                	jne    c0101cc0 <trap_dispatch+0x62>
    		print_ticks();
c0101cac:	e8 be fb ff ff       	call   c010186f <print_ticks>
    		ticks = 0;
c0101cb1:	c7 05 4c 89 11 c0 00 	movl   $0x0,0xc011894c
c0101cb8:	00 00 00 
    	}
        break;
c0101cbb:	e9 a6 00 00 00       	jmp    c0101d66 <trap_dispatch+0x108>
c0101cc0:	e9 a1 00 00 00       	jmp    c0101d66 <trap_dispatch+0x108>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101cc5:	e8 69 f9 ff ff       	call   c0101633 <cons_getc>
c0101cca:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101ccd:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101cd1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101cd5:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101cd9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cdd:	c7 04 24 94 63 10 c0 	movl   $0xc0106394,(%esp)
c0101ce4:	e8 53 e6 ff ff       	call   c010033c <cprintf>
        break;
c0101ce9:	eb 7b                	jmp    c0101d66 <trap_dispatch+0x108>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101ceb:	e8 43 f9 ff ff       	call   c0101633 <cons_getc>
c0101cf0:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101cf3:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101cf7:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101cfb:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101cff:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d03:	c7 04 24 a6 63 10 c0 	movl   $0xc01063a6,(%esp)
c0101d0a:	e8 2d e6 ff ff       	call   c010033c <cprintf>
        break;
c0101d0f:	eb 55                	jmp    c0101d66 <trap_dispatch+0x108>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101d11:	c7 44 24 08 b5 63 10 	movl   $0xc01063b5,0x8(%esp)
c0101d18:	c0 
c0101d19:	c7 44 24 04 ab 00 00 	movl   $0xab,0x4(%esp)
c0101d20:	00 
c0101d21:	c7 04 24 c5 63 10 c0 	movl   $0xc01063c5,(%esp)
c0101d28:	e8 98 ef ff ff       	call   c0100cc5 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101d2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d30:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101d34:	0f b7 c0             	movzwl %ax,%eax
c0101d37:	83 e0 03             	and    $0x3,%eax
c0101d3a:	85 c0                	test   %eax,%eax
c0101d3c:	75 28                	jne    c0101d66 <trap_dispatch+0x108>
            print_trapframe(tf);
c0101d3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d41:	89 04 24             	mov    %eax,(%esp)
c0101d44:	e8 99 fc ff ff       	call   c01019e2 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101d49:	c7 44 24 08 d6 63 10 	movl   $0xc01063d6,0x8(%esp)
c0101d50:	c0 
c0101d51:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
c0101d58:	00 
c0101d59:	c7 04 24 c5 63 10 c0 	movl   $0xc01063c5,(%esp)
c0101d60:	e8 60 ef ff ff       	call   c0100cc5 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101d65:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101d66:	c9                   	leave  
c0101d67:	c3                   	ret    

c0101d68 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101d68:	55                   	push   %ebp
c0101d69:	89 e5                	mov    %esp,%ebp
c0101d6b:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101d6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d71:	89 04 24             	mov    %eax,(%esp)
c0101d74:	e8 e5 fe ff ff       	call   c0101c5e <trap_dispatch>
}
c0101d79:	c9                   	leave  
c0101d7a:	c3                   	ret    

c0101d7b <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101d7b:	1e                   	push   %ds
    pushl %es
c0101d7c:	06                   	push   %es
    pushl %fs
c0101d7d:	0f a0                	push   %fs
    pushl %gs
c0101d7f:	0f a8                	push   %gs
    pushal
c0101d81:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101d82:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101d87:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101d89:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101d8b:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101d8c:	e8 d7 ff ff ff       	call   c0101d68 <trap>

    # pop the pushed stack pointer
    popl %esp
c0101d91:	5c                   	pop    %esp

c0101d92 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101d92:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101d93:	0f a9                	pop    %gs
    popl %fs
c0101d95:	0f a1                	pop    %fs
    popl %es
c0101d97:	07                   	pop    %es
    popl %ds
c0101d98:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101d99:	83 c4 08             	add    $0x8,%esp
    iret
c0101d9c:	cf                   	iret   

c0101d9d <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101d9d:	6a 00                	push   $0x0
  pushl $0
c0101d9f:	6a 00                	push   $0x0
  jmp __alltraps
c0101da1:	e9 d5 ff ff ff       	jmp    c0101d7b <__alltraps>

c0101da6 <vector1>:
.globl vector1
vector1:
  pushl $0
c0101da6:	6a 00                	push   $0x0
  pushl $1
c0101da8:	6a 01                	push   $0x1
  jmp __alltraps
c0101daa:	e9 cc ff ff ff       	jmp    c0101d7b <__alltraps>

c0101daf <vector2>:
.globl vector2
vector2:
  pushl $0
c0101daf:	6a 00                	push   $0x0
  pushl $2
c0101db1:	6a 02                	push   $0x2
  jmp __alltraps
c0101db3:	e9 c3 ff ff ff       	jmp    c0101d7b <__alltraps>

c0101db8 <vector3>:
.globl vector3
vector3:
  pushl $0
c0101db8:	6a 00                	push   $0x0
  pushl $3
c0101dba:	6a 03                	push   $0x3
  jmp __alltraps
c0101dbc:	e9 ba ff ff ff       	jmp    c0101d7b <__alltraps>

c0101dc1 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101dc1:	6a 00                	push   $0x0
  pushl $4
c0101dc3:	6a 04                	push   $0x4
  jmp __alltraps
c0101dc5:	e9 b1 ff ff ff       	jmp    c0101d7b <__alltraps>

c0101dca <vector5>:
.globl vector5
vector5:
  pushl $0
c0101dca:	6a 00                	push   $0x0
  pushl $5
c0101dcc:	6a 05                	push   $0x5
  jmp __alltraps
c0101dce:	e9 a8 ff ff ff       	jmp    c0101d7b <__alltraps>

c0101dd3 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101dd3:	6a 00                	push   $0x0
  pushl $6
c0101dd5:	6a 06                	push   $0x6
  jmp __alltraps
c0101dd7:	e9 9f ff ff ff       	jmp    c0101d7b <__alltraps>

c0101ddc <vector7>:
.globl vector7
vector7:
  pushl $0
c0101ddc:	6a 00                	push   $0x0
  pushl $7
c0101dde:	6a 07                	push   $0x7
  jmp __alltraps
c0101de0:	e9 96 ff ff ff       	jmp    c0101d7b <__alltraps>

c0101de5 <vector8>:
.globl vector8
vector8:
  pushl $8
c0101de5:	6a 08                	push   $0x8
  jmp __alltraps
c0101de7:	e9 8f ff ff ff       	jmp    c0101d7b <__alltraps>

c0101dec <vector9>:
.globl vector9
vector9:
  pushl $9
c0101dec:	6a 09                	push   $0x9
  jmp __alltraps
c0101dee:	e9 88 ff ff ff       	jmp    c0101d7b <__alltraps>

c0101df3 <vector10>:
.globl vector10
vector10:
  pushl $10
c0101df3:	6a 0a                	push   $0xa
  jmp __alltraps
c0101df5:	e9 81 ff ff ff       	jmp    c0101d7b <__alltraps>

c0101dfa <vector11>:
.globl vector11
vector11:
  pushl $11
c0101dfa:	6a 0b                	push   $0xb
  jmp __alltraps
c0101dfc:	e9 7a ff ff ff       	jmp    c0101d7b <__alltraps>

c0101e01 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101e01:	6a 0c                	push   $0xc
  jmp __alltraps
c0101e03:	e9 73 ff ff ff       	jmp    c0101d7b <__alltraps>

c0101e08 <vector13>:
.globl vector13
vector13:
  pushl $13
c0101e08:	6a 0d                	push   $0xd
  jmp __alltraps
c0101e0a:	e9 6c ff ff ff       	jmp    c0101d7b <__alltraps>

c0101e0f <vector14>:
.globl vector14
vector14:
  pushl $14
c0101e0f:	6a 0e                	push   $0xe
  jmp __alltraps
c0101e11:	e9 65 ff ff ff       	jmp    c0101d7b <__alltraps>

c0101e16 <vector15>:
.globl vector15
vector15:
  pushl $0
c0101e16:	6a 00                	push   $0x0
  pushl $15
c0101e18:	6a 0f                	push   $0xf
  jmp __alltraps
c0101e1a:	e9 5c ff ff ff       	jmp    c0101d7b <__alltraps>

c0101e1f <vector16>:
.globl vector16
vector16:
  pushl $0
c0101e1f:	6a 00                	push   $0x0
  pushl $16
c0101e21:	6a 10                	push   $0x10
  jmp __alltraps
c0101e23:	e9 53 ff ff ff       	jmp    c0101d7b <__alltraps>

c0101e28 <vector17>:
.globl vector17
vector17:
  pushl $17
c0101e28:	6a 11                	push   $0x11
  jmp __alltraps
c0101e2a:	e9 4c ff ff ff       	jmp    c0101d7b <__alltraps>

c0101e2f <vector18>:
.globl vector18
vector18:
  pushl $0
c0101e2f:	6a 00                	push   $0x0
  pushl $18
c0101e31:	6a 12                	push   $0x12
  jmp __alltraps
c0101e33:	e9 43 ff ff ff       	jmp    c0101d7b <__alltraps>

c0101e38 <vector19>:
.globl vector19
vector19:
  pushl $0
c0101e38:	6a 00                	push   $0x0
  pushl $19
c0101e3a:	6a 13                	push   $0x13
  jmp __alltraps
c0101e3c:	e9 3a ff ff ff       	jmp    c0101d7b <__alltraps>

c0101e41 <vector20>:
.globl vector20
vector20:
  pushl $0
c0101e41:	6a 00                	push   $0x0
  pushl $20
c0101e43:	6a 14                	push   $0x14
  jmp __alltraps
c0101e45:	e9 31 ff ff ff       	jmp    c0101d7b <__alltraps>

c0101e4a <vector21>:
.globl vector21
vector21:
  pushl $0
c0101e4a:	6a 00                	push   $0x0
  pushl $21
c0101e4c:	6a 15                	push   $0x15
  jmp __alltraps
c0101e4e:	e9 28 ff ff ff       	jmp    c0101d7b <__alltraps>

c0101e53 <vector22>:
.globl vector22
vector22:
  pushl $0
c0101e53:	6a 00                	push   $0x0
  pushl $22
c0101e55:	6a 16                	push   $0x16
  jmp __alltraps
c0101e57:	e9 1f ff ff ff       	jmp    c0101d7b <__alltraps>

c0101e5c <vector23>:
.globl vector23
vector23:
  pushl $0
c0101e5c:	6a 00                	push   $0x0
  pushl $23
c0101e5e:	6a 17                	push   $0x17
  jmp __alltraps
c0101e60:	e9 16 ff ff ff       	jmp    c0101d7b <__alltraps>

c0101e65 <vector24>:
.globl vector24
vector24:
  pushl $0
c0101e65:	6a 00                	push   $0x0
  pushl $24
c0101e67:	6a 18                	push   $0x18
  jmp __alltraps
c0101e69:	e9 0d ff ff ff       	jmp    c0101d7b <__alltraps>

c0101e6e <vector25>:
.globl vector25
vector25:
  pushl $0
c0101e6e:	6a 00                	push   $0x0
  pushl $25
c0101e70:	6a 19                	push   $0x19
  jmp __alltraps
c0101e72:	e9 04 ff ff ff       	jmp    c0101d7b <__alltraps>

c0101e77 <vector26>:
.globl vector26
vector26:
  pushl $0
c0101e77:	6a 00                	push   $0x0
  pushl $26
c0101e79:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101e7b:	e9 fb fe ff ff       	jmp    c0101d7b <__alltraps>

c0101e80 <vector27>:
.globl vector27
vector27:
  pushl $0
c0101e80:	6a 00                	push   $0x0
  pushl $27
c0101e82:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101e84:	e9 f2 fe ff ff       	jmp    c0101d7b <__alltraps>

c0101e89 <vector28>:
.globl vector28
vector28:
  pushl $0
c0101e89:	6a 00                	push   $0x0
  pushl $28
c0101e8b:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101e8d:	e9 e9 fe ff ff       	jmp    c0101d7b <__alltraps>

c0101e92 <vector29>:
.globl vector29
vector29:
  pushl $0
c0101e92:	6a 00                	push   $0x0
  pushl $29
c0101e94:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101e96:	e9 e0 fe ff ff       	jmp    c0101d7b <__alltraps>

c0101e9b <vector30>:
.globl vector30
vector30:
  pushl $0
c0101e9b:	6a 00                	push   $0x0
  pushl $30
c0101e9d:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101e9f:	e9 d7 fe ff ff       	jmp    c0101d7b <__alltraps>

c0101ea4 <vector31>:
.globl vector31
vector31:
  pushl $0
c0101ea4:	6a 00                	push   $0x0
  pushl $31
c0101ea6:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101ea8:	e9 ce fe ff ff       	jmp    c0101d7b <__alltraps>

c0101ead <vector32>:
.globl vector32
vector32:
  pushl $0
c0101ead:	6a 00                	push   $0x0
  pushl $32
c0101eaf:	6a 20                	push   $0x20
  jmp __alltraps
c0101eb1:	e9 c5 fe ff ff       	jmp    c0101d7b <__alltraps>

c0101eb6 <vector33>:
.globl vector33
vector33:
  pushl $0
c0101eb6:	6a 00                	push   $0x0
  pushl $33
c0101eb8:	6a 21                	push   $0x21
  jmp __alltraps
c0101eba:	e9 bc fe ff ff       	jmp    c0101d7b <__alltraps>

c0101ebf <vector34>:
.globl vector34
vector34:
  pushl $0
c0101ebf:	6a 00                	push   $0x0
  pushl $34
c0101ec1:	6a 22                	push   $0x22
  jmp __alltraps
c0101ec3:	e9 b3 fe ff ff       	jmp    c0101d7b <__alltraps>

c0101ec8 <vector35>:
.globl vector35
vector35:
  pushl $0
c0101ec8:	6a 00                	push   $0x0
  pushl $35
c0101eca:	6a 23                	push   $0x23
  jmp __alltraps
c0101ecc:	e9 aa fe ff ff       	jmp    c0101d7b <__alltraps>

c0101ed1 <vector36>:
.globl vector36
vector36:
  pushl $0
c0101ed1:	6a 00                	push   $0x0
  pushl $36
c0101ed3:	6a 24                	push   $0x24
  jmp __alltraps
c0101ed5:	e9 a1 fe ff ff       	jmp    c0101d7b <__alltraps>

c0101eda <vector37>:
.globl vector37
vector37:
  pushl $0
c0101eda:	6a 00                	push   $0x0
  pushl $37
c0101edc:	6a 25                	push   $0x25
  jmp __alltraps
c0101ede:	e9 98 fe ff ff       	jmp    c0101d7b <__alltraps>

c0101ee3 <vector38>:
.globl vector38
vector38:
  pushl $0
c0101ee3:	6a 00                	push   $0x0
  pushl $38
c0101ee5:	6a 26                	push   $0x26
  jmp __alltraps
c0101ee7:	e9 8f fe ff ff       	jmp    c0101d7b <__alltraps>

c0101eec <vector39>:
.globl vector39
vector39:
  pushl $0
c0101eec:	6a 00                	push   $0x0
  pushl $39
c0101eee:	6a 27                	push   $0x27
  jmp __alltraps
c0101ef0:	e9 86 fe ff ff       	jmp    c0101d7b <__alltraps>

c0101ef5 <vector40>:
.globl vector40
vector40:
  pushl $0
c0101ef5:	6a 00                	push   $0x0
  pushl $40
c0101ef7:	6a 28                	push   $0x28
  jmp __alltraps
c0101ef9:	e9 7d fe ff ff       	jmp    c0101d7b <__alltraps>

c0101efe <vector41>:
.globl vector41
vector41:
  pushl $0
c0101efe:	6a 00                	push   $0x0
  pushl $41
c0101f00:	6a 29                	push   $0x29
  jmp __alltraps
c0101f02:	e9 74 fe ff ff       	jmp    c0101d7b <__alltraps>

c0101f07 <vector42>:
.globl vector42
vector42:
  pushl $0
c0101f07:	6a 00                	push   $0x0
  pushl $42
c0101f09:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101f0b:	e9 6b fe ff ff       	jmp    c0101d7b <__alltraps>

c0101f10 <vector43>:
.globl vector43
vector43:
  pushl $0
c0101f10:	6a 00                	push   $0x0
  pushl $43
c0101f12:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101f14:	e9 62 fe ff ff       	jmp    c0101d7b <__alltraps>

c0101f19 <vector44>:
.globl vector44
vector44:
  pushl $0
c0101f19:	6a 00                	push   $0x0
  pushl $44
c0101f1b:	6a 2c                	push   $0x2c
  jmp __alltraps
c0101f1d:	e9 59 fe ff ff       	jmp    c0101d7b <__alltraps>

c0101f22 <vector45>:
.globl vector45
vector45:
  pushl $0
c0101f22:	6a 00                	push   $0x0
  pushl $45
c0101f24:	6a 2d                	push   $0x2d
  jmp __alltraps
c0101f26:	e9 50 fe ff ff       	jmp    c0101d7b <__alltraps>

c0101f2b <vector46>:
.globl vector46
vector46:
  pushl $0
c0101f2b:	6a 00                	push   $0x0
  pushl $46
c0101f2d:	6a 2e                	push   $0x2e
  jmp __alltraps
c0101f2f:	e9 47 fe ff ff       	jmp    c0101d7b <__alltraps>

c0101f34 <vector47>:
.globl vector47
vector47:
  pushl $0
c0101f34:	6a 00                	push   $0x0
  pushl $47
c0101f36:	6a 2f                	push   $0x2f
  jmp __alltraps
c0101f38:	e9 3e fe ff ff       	jmp    c0101d7b <__alltraps>

c0101f3d <vector48>:
.globl vector48
vector48:
  pushl $0
c0101f3d:	6a 00                	push   $0x0
  pushl $48
c0101f3f:	6a 30                	push   $0x30
  jmp __alltraps
c0101f41:	e9 35 fe ff ff       	jmp    c0101d7b <__alltraps>

c0101f46 <vector49>:
.globl vector49
vector49:
  pushl $0
c0101f46:	6a 00                	push   $0x0
  pushl $49
c0101f48:	6a 31                	push   $0x31
  jmp __alltraps
c0101f4a:	e9 2c fe ff ff       	jmp    c0101d7b <__alltraps>

c0101f4f <vector50>:
.globl vector50
vector50:
  pushl $0
c0101f4f:	6a 00                	push   $0x0
  pushl $50
c0101f51:	6a 32                	push   $0x32
  jmp __alltraps
c0101f53:	e9 23 fe ff ff       	jmp    c0101d7b <__alltraps>

c0101f58 <vector51>:
.globl vector51
vector51:
  pushl $0
c0101f58:	6a 00                	push   $0x0
  pushl $51
c0101f5a:	6a 33                	push   $0x33
  jmp __alltraps
c0101f5c:	e9 1a fe ff ff       	jmp    c0101d7b <__alltraps>

c0101f61 <vector52>:
.globl vector52
vector52:
  pushl $0
c0101f61:	6a 00                	push   $0x0
  pushl $52
c0101f63:	6a 34                	push   $0x34
  jmp __alltraps
c0101f65:	e9 11 fe ff ff       	jmp    c0101d7b <__alltraps>

c0101f6a <vector53>:
.globl vector53
vector53:
  pushl $0
c0101f6a:	6a 00                	push   $0x0
  pushl $53
c0101f6c:	6a 35                	push   $0x35
  jmp __alltraps
c0101f6e:	e9 08 fe ff ff       	jmp    c0101d7b <__alltraps>

c0101f73 <vector54>:
.globl vector54
vector54:
  pushl $0
c0101f73:	6a 00                	push   $0x0
  pushl $54
c0101f75:	6a 36                	push   $0x36
  jmp __alltraps
c0101f77:	e9 ff fd ff ff       	jmp    c0101d7b <__alltraps>

c0101f7c <vector55>:
.globl vector55
vector55:
  pushl $0
c0101f7c:	6a 00                	push   $0x0
  pushl $55
c0101f7e:	6a 37                	push   $0x37
  jmp __alltraps
c0101f80:	e9 f6 fd ff ff       	jmp    c0101d7b <__alltraps>

c0101f85 <vector56>:
.globl vector56
vector56:
  pushl $0
c0101f85:	6a 00                	push   $0x0
  pushl $56
c0101f87:	6a 38                	push   $0x38
  jmp __alltraps
c0101f89:	e9 ed fd ff ff       	jmp    c0101d7b <__alltraps>

c0101f8e <vector57>:
.globl vector57
vector57:
  pushl $0
c0101f8e:	6a 00                	push   $0x0
  pushl $57
c0101f90:	6a 39                	push   $0x39
  jmp __alltraps
c0101f92:	e9 e4 fd ff ff       	jmp    c0101d7b <__alltraps>

c0101f97 <vector58>:
.globl vector58
vector58:
  pushl $0
c0101f97:	6a 00                	push   $0x0
  pushl $58
c0101f99:	6a 3a                	push   $0x3a
  jmp __alltraps
c0101f9b:	e9 db fd ff ff       	jmp    c0101d7b <__alltraps>

c0101fa0 <vector59>:
.globl vector59
vector59:
  pushl $0
c0101fa0:	6a 00                	push   $0x0
  pushl $59
c0101fa2:	6a 3b                	push   $0x3b
  jmp __alltraps
c0101fa4:	e9 d2 fd ff ff       	jmp    c0101d7b <__alltraps>

c0101fa9 <vector60>:
.globl vector60
vector60:
  pushl $0
c0101fa9:	6a 00                	push   $0x0
  pushl $60
c0101fab:	6a 3c                	push   $0x3c
  jmp __alltraps
c0101fad:	e9 c9 fd ff ff       	jmp    c0101d7b <__alltraps>

c0101fb2 <vector61>:
.globl vector61
vector61:
  pushl $0
c0101fb2:	6a 00                	push   $0x0
  pushl $61
c0101fb4:	6a 3d                	push   $0x3d
  jmp __alltraps
c0101fb6:	e9 c0 fd ff ff       	jmp    c0101d7b <__alltraps>

c0101fbb <vector62>:
.globl vector62
vector62:
  pushl $0
c0101fbb:	6a 00                	push   $0x0
  pushl $62
c0101fbd:	6a 3e                	push   $0x3e
  jmp __alltraps
c0101fbf:	e9 b7 fd ff ff       	jmp    c0101d7b <__alltraps>

c0101fc4 <vector63>:
.globl vector63
vector63:
  pushl $0
c0101fc4:	6a 00                	push   $0x0
  pushl $63
c0101fc6:	6a 3f                	push   $0x3f
  jmp __alltraps
c0101fc8:	e9 ae fd ff ff       	jmp    c0101d7b <__alltraps>

c0101fcd <vector64>:
.globl vector64
vector64:
  pushl $0
c0101fcd:	6a 00                	push   $0x0
  pushl $64
c0101fcf:	6a 40                	push   $0x40
  jmp __alltraps
c0101fd1:	e9 a5 fd ff ff       	jmp    c0101d7b <__alltraps>

c0101fd6 <vector65>:
.globl vector65
vector65:
  pushl $0
c0101fd6:	6a 00                	push   $0x0
  pushl $65
c0101fd8:	6a 41                	push   $0x41
  jmp __alltraps
c0101fda:	e9 9c fd ff ff       	jmp    c0101d7b <__alltraps>

c0101fdf <vector66>:
.globl vector66
vector66:
  pushl $0
c0101fdf:	6a 00                	push   $0x0
  pushl $66
c0101fe1:	6a 42                	push   $0x42
  jmp __alltraps
c0101fe3:	e9 93 fd ff ff       	jmp    c0101d7b <__alltraps>

c0101fe8 <vector67>:
.globl vector67
vector67:
  pushl $0
c0101fe8:	6a 00                	push   $0x0
  pushl $67
c0101fea:	6a 43                	push   $0x43
  jmp __alltraps
c0101fec:	e9 8a fd ff ff       	jmp    c0101d7b <__alltraps>

c0101ff1 <vector68>:
.globl vector68
vector68:
  pushl $0
c0101ff1:	6a 00                	push   $0x0
  pushl $68
c0101ff3:	6a 44                	push   $0x44
  jmp __alltraps
c0101ff5:	e9 81 fd ff ff       	jmp    c0101d7b <__alltraps>

c0101ffa <vector69>:
.globl vector69
vector69:
  pushl $0
c0101ffa:	6a 00                	push   $0x0
  pushl $69
c0101ffc:	6a 45                	push   $0x45
  jmp __alltraps
c0101ffe:	e9 78 fd ff ff       	jmp    c0101d7b <__alltraps>

c0102003 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102003:	6a 00                	push   $0x0
  pushl $70
c0102005:	6a 46                	push   $0x46
  jmp __alltraps
c0102007:	e9 6f fd ff ff       	jmp    c0101d7b <__alltraps>

c010200c <vector71>:
.globl vector71
vector71:
  pushl $0
c010200c:	6a 00                	push   $0x0
  pushl $71
c010200e:	6a 47                	push   $0x47
  jmp __alltraps
c0102010:	e9 66 fd ff ff       	jmp    c0101d7b <__alltraps>

c0102015 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102015:	6a 00                	push   $0x0
  pushl $72
c0102017:	6a 48                	push   $0x48
  jmp __alltraps
c0102019:	e9 5d fd ff ff       	jmp    c0101d7b <__alltraps>

c010201e <vector73>:
.globl vector73
vector73:
  pushl $0
c010201e:	6a 00                	push   $0x0
  pushl $73
c0102020:	6a 49                	push   $0x49
  jmp __alltraps
c0102022:	e9 54 fd ff ff       	jmp    c0101d7b <__alltraps>

c0102027 <vector74>:
.globl vector74
vector74:
  pushl $0
c0102027:	6a 00                	push   $0x0
  pushl $74
c0102029:	6a 4a                	push   $0x4a
  jmp __alltraps
c010202b:	e9 4b fd ff ff       	jmp    c0101d7b <__alltraps>

c0102030 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102030:	6a 00                	push   $0x0
  pushl $75
c0102032:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102034:	e9 42 fd ff ff       	jmp    c0101d7b <__alltraps>

c0102039 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102039:	6a 00                	push   $0x0
  pushl $76
c010203b:	6a 4c                	push   $0x4c
  jmp __alltraps
c010203d:	e9 39 fd ff ff       	jmp    c0101d7b <__alltraps>

c0102042 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102042:	6a 00                	push   $0x0
  pushl $77
c0102044:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102046:	e9 30 fd ff ff       	jmp    c0101d7b <__alltraps>

c010204b <vector78>:
.globl vector78
vector78:
  pushl $0
c010204b:	6a 00                	push   $0x0
  pushl $78
c010204d:	6a 4e                	push   $0x4e
  jmp __alltraps
c010204f:	e9 27 fd ff ff       	jmp    c0101d7b <__alltraps>

c0102054 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102054:	6a 00                	push   $0x0
  pushl $79
c0102056:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102058:	e9 1e fd ff ff       	jmp    c0101d7b <__alltraps>

c010205d <vector80>:
.globl vector80
vector80:
  pushl $0
c010205d:	6a 00                	push   $0x0
  pushl $80
c010205f:	6a 50                	push   $0x50
  jmp __alltraps
c0102061:	e9 15 fd ff ff       	jmp    c0101d7b <__alltraps>

c0102066 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102066:	6a 00                	push   $0x0
  pushl $81
c0102068:	6a 51                	push   $0x51
  jmp __alltraps
c010206a:	e9 0c fd ff ff       	jmp    c0101d7b <__alltraps>

c010206f <vector82>:
.globl vector82
vector82:
  pushl $0
c010206f:	6a 00                	push   $0x0
  pushl $82
c0102071:	6a 52                	push   $0x52
  jmp __alltraps
c0102073:	e9 03 fd ff ff       	jmp    c0101d7b <__alltraps>

c0102078 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102078:	6a 00                	push   $0x0
  pushl $83
c010207a:	6a 53                	push   $0x53
  jmp __alltraps
c010207c:	e9 fa fc ff ff       	jmp    c0101d7b <__alltraps>

c0102081 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102081:	6a 00                	push   $0x0
  pushl $84
c0102083:	6a 54                	push   $0x54
  jmp __alltraps
c0102085:	e9 f1 fc ff ff       	jmp    c0101d7b <__alltraps>

c010208a <vector85>:
.globl vector85
vector85:
  pushl $0
c010208a:	6a 00                	push   $0x0
  pushl $85
c010208c:	6a 55                	push   $0x55
  jmp __alltraps
c010208e:	e9 e8 fc ff ff       	jmp    c0101d7b <__alltraps>

c0102093 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102093:	6a 00                	push   $0x0
  pushl $86
c0102095:	6a 56                	push   $0x56
  jmp __alltraps
c0102097:	e9 df fc ff ff       	jmp    c0101d7b <__alltraps>

c010209c <vector87>:
.globl vector87
vector87:
  pushl $0
c010209c:	6a 00                	push   $0x0
  pushl $87
c010209e:	6a 57                	push   $0x57
  jmp __alltraps
c01020a0:	e9 d6 fc ff ff       	jmp    c0101d7b <__alltraps>

c01020a5 <vector88>:
.globl vector88
vector88:
  pushl $0
c01020a5:	6a 00                	push   $0x0
  pushl $88
c01020a7:	6a 58                	push   $0x58
  jmp __alltraps
c01020a9:	e9 cd fc ff ff       	jmp    c0101d7b <__alltraps>

c01020ae <vector89>:
.globl vector89
vector89:
  pushl $0
c01020ae:	6a 00                	push   $0x0
  pushl $89
c01020b0:	6a 59                	push   $0x59
  jmp __alltraps
c01020b2:	e9 c4 fc ff ff       	jmp    c0101d7b <__alltraps>

c01020b7 <vector90>:
.globl vector90
vector90:
  pushl $0
c01020b7:	6a 00                	push   $0x0
  pushl $90
c01020b9:	6a 5a                	push   $0x5a
  jmp __alltraps
c01020bb:	e9 bb fc ff ff       	jmp    c0101d7b <__alltraps>

c01020c0 <vector91>:
.globl vector91
vector91:
  pushl $0
c01020c0:	6a 00                	push   $0x0
  pushl $91
c01020c2:	6a 5b                	push   $0x5b
  jmp __alltraps
c01020c4:	e9 b2 fc ff ff       	jmp    c0101d7b <__alltraps>

c01020c9 <vector92>:
.globl vector92
vector92:
  pushl $0
c01020c9:	6a 00                	push   $0x0
  pushl $92
c01020cb:	6a 5c                	push   $0x5c
  jmp __alltraps
c01020cd:	e9 a9 fc ff ff       	jmp    c0101d7b <__alltraps>

c01020d2 <vector93>:
.globl vector93
vector93:
  pushl $0
c01020d2:	6a 00                	push   $0x0
  pushl $93
c01020d4:	6a 5d                	push   $0x5d
  jmp __alltraps
c01020d6:	e9 a0 fc ff ff       	jmp    c0101d7b <__alltraps>

c01020db <vector94>:
.globl vector94
vector94:
  pushl $0
c01020db:	6a 00                	push   $0x0
  pushl $94
c01020dd:	6a 5e                	push   $0x5e
  jmp __alltraps
c01020df:	e9 97 fc ff ff       	jmp    c0101d7b <__alltraps>

c01020e4 <vector95>:
.globl vector95
vector95:
  pushl $0
c01020e4:	6a 00                	push   $0x0
  pushl $95
c01020e6:	6a 5f                	push   $0x5f
  jmp __alltraps
c01020e8:	e9 8e fc ff ff       	jmp    c0101d7b <__alltraps>

c01020ed <vector96>:
.globl vector96
vector96:
  pushl $0
c01020ed:	6a 00                	push   $0x0
  pushl $96
c01020ef:	6a 60                	push   $0x60
  jmp __alltraps
c01020f1:	e9 85 fc ff ff       	jmp    c0101d7b <__alltraps>

c01020f6 <vector97>:
.globl vector97
vector97:
  pushl $0
c01020f6:	6a 00                	push   $0x0
  pushl $97
c01020f8:	6a 61                	push   $0x61
  jmp __alltraps
c01020fa:	e9 7c fc ff ff       	jmp    c0101d7b <__alltraps>

c01020ff <vector98>:
.globl vector98
vector98:
  pushl $0
c01020ff:	6a 00                	push   $0x0
  pushl $98
c0102101:	6a 62                	push   $0x62
  jmp __alltraps
c0102103:	e9 73 fc ff ff       	jmp    c0101d7b <__alltraps>

c0102108 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102108:	6a 00                	push   $0x0
  pushl $99
c010210a:	6a 63                	push   $0x63
  jmp __alltraps
c010210c:	e9 6a fc ff ff       	jmp    c0101d7b <__alltraps>

c0102111 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102111:	6a 00                	push   $0x0
  pushl $100
c0102113:	6a 64                	push   $0x64
  jmp __alltraps
c0102115:	e9 61 fc ff ff       	jmp    c0101d7b <__alltraps>

c010211a <vector101>:
.globl vector101
vector101:
  pushl $0
c010211a:	6a 00                	push   $0x0
  pushl $101
c010211c:	6a 65                	push   $0x65
  jmp __alltraps
c010211e:	e9 58 fc ff ff       	jmp    c0101d7b <__alltraps>

c0102123 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102123:	6a 00                	push   $0x0
  pushl $102
c0102125:	6a 66                	push   $0x66
  jmp __alltraps
c0102127:	e9 4f fc ff ff       	jmp    c0101d7b <__alltraps>

c010212c <vector103>:
.globl vector103
vector103:
  pushl $0
c010212c:	6a 00                	push   $0x0
  pushl $103
c010212e:	6a 67                	push   $0x67
  jmp __alltraps
c0102130:	e9 46 fc ff ff       	jmp    c0101d7b <__alltraps>

c0102135 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102135:	6a 00                	push   $0x0
  pushl $104
c0102137:	6a 68                	push   $0x68
  jmp __alltraps
c0102139:	e9 3d fc ff ff       	jmp    c0101d7b <__alltraps>

c010213e <vector105>:
.globl vector105
vector105:
  pushl $0
c010213e:	6a 00                	push   $0x0
  pushl $105
c0102140:	6a 69                	push   $0x69
  jmp __alltraps
c0102142:	e9 34 fc ff ff       	jmp    c0101d7b <__alltraps>

c0102147 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102147:	6a 00                	push   $0x0
  pushl $106
c0102149:	6a 6a                	push   $0x6a
  jmp __alltraps
c010214b:	e9 2b fc ff ff       	jmp    c0101d7b <__alltraps>

c0102150 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102150:	6a 00                	push   $0x0
  pushl $107
c0102152:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102154:	e9 22 fc ff ff       	jmp    c0101d7b <__alltraps>

c0102159 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102159:	6a 00                	push   $0x0
  pushl $108
c010215b:	6a 6c                	push   $0x6c
  jmp __alltraps
c010215d:	e9 19 fc ff ff       	jmp    c0101d7b <__alltraps>

c0102162 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102162:	6a 00                	push   $0x0
  pushl $109
c0102164:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102166:	e9 10 fc ff ff       	jmp    c0101d7b <__alltraps>

c010216b <vector110>:
.globl vector110
vector110:
  pushl $0
c010216b:	6a 00                	push   $0x0
  pushl $110
c010216d:	6a 6e                	push   $0x6e
  jmp __alltraps
c010216f:	e9 07 fc ff ff       	jmp    c0101d7b <__alltraps>

c0102174 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102174:	6a 00                	push   $0x0
  pushl $111
c0102176:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102178:	e9 fe fb ff ff       	jmp    c0101d7b <__alltraps>

c010217d <vector112>:
.globl vector112
vector112:
  pushl $0
c010217d:	6a 00                	push   $0x0
  pushl $112
c010217f:	6a 70                	push   $0x70
  jmp __alltraps
c0102181:	e9 f5 fb ff ff       	jmp    c0101d7b <__alltraps>

c0102186 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102186:	6a 00                	push   $0x0
  pushl $113
c0102188:	6a 71                	push   $0x71
  jmp __alltraps
c010218a:	e9 ec fb ff ff       	jmp    c0101d7b <__alltraps>

c010218f <vector114>:
.globl vector114
vector114:
  pushl $0
c010218f:	6a 00                	push   $0x0
  pushl $114
c0102191:	6a 72                	push   $0x72
  jmp __alltraps
c0102193:	e9 e3 fb ff ff       	jmp    c0101d7b <__alltraps>

c0102198 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102198:	6a 00                	push   $0x0
  pushl $115
c010219a:	6a 73                	push   $0x73
  jmp __alltraps
c010219c:	e9 da fb ff ff       	jmp    c0101d7b <__alltraps>

c01021a1 <vector116>:
.globl vector116
vector116:
  pushl $0
c01021a1:	6a 00                	push   $0x0
  pushl $116
c01021a3:	6a 74                	push   $0x74
  jmp __alltraps
c01021a5:	e9 d1 fb ff ff       	jmp    c0101d7b <__alltraps>

c01021aa <vector117>:
.globl vector117
vector117:
  pushl $0
c01021aa:	6a 00                	push   $0x0
  pushl $117
c01021ac:	6a 75                	push   $0x75
  jmp __alltraps
c01021ae:	e9 c8 fb ff ff       	jmp    c0101d7b <__alltraps>

c01021b3 <vector118>:
.globl vector118
vector118:
  pushl $0
c01021b3:	6a 00                	push   $0x0
  pushl $118
c01021b5:	6a 76                	push   $0x76
  jmp __alltraps
c01021b7:	e9 bf fb ff ff       	jmp    c0101d7b <__alltraps>

c01021bc <vector119>:
.globl vector119
vector119:
  pushl $0
c01021bc:	6a 00                	push   $0x0
  pushl $119
c01021be:	6a 77                	push   $0x77
  jmp __alltraps
c01021c0:	e9 b6 fb ff ff       	jmp    c0101d7b <__alltraps>

c01021c5 <vector120>:
.globl vector120
vector120:
  pushl $0
c01021c5:	6a 00                	push   $0x0
  pushl $120
c01021c7:	6a 78                	push   $0x78
  jmp __alltraps
c01021c9:	e9 ad fb ff ff       	jmp    c0101d7b <__alltraps>

c01021ce <vector121>:
.globl vector121
vector121:
  pushl $0
c01021ce:	6a 00                	push   $0x0
  pushl $121
c01021d0:	6a 79                	push   $0x79
  jmp __alltraps
c01021d2:	e9 a4 fb ff ff       	jmp    c0101d7b <__alltraps>

c01021d7 <vector122>:
.globl vector122
vector122:
  pushl $0
c01021d7:	6a 00                	push   $0x0
  pushl $122
c01021d9:	6a 7a                	push   $0x7a
  jmp __alltraps
c01021db:	e9 9b fb ff ff       	jmp    c0101d7b <__alltraps>

c01021e0 <vector123>:
.globl vector123
vector123:
  pushl $0
c01021e0:	6a 00                	push   $0x0
  pushl $123
c01021e2:	6a 7b                	push   $0x7b
  jmp __alltraps
c01021e4:	e9 92 fb ff ff       	jmp    c0101d7b <__alltraps>

c01021e9 <vector124>:
.globl vector124
vector124:
  pushl $0
c01021e9:	6a 00                	push   $0x0
  pushl $124
c01021eb:	6a 7c                	push   $0x7c
  jmp __alltraps
c01021ed:	e9 89 fb ff ff       	jmp    c0101d7b <__alltraps>

c01021f2 <vector125>:
.globl vector125
vector125:
  pushl $0
c01021f2:	6a 00                	push   $0x0
  pushl $125
c01021f4:	6a 7d                	push   $0x7d
  jmp __alltraps
c01021f6:	e9 80 fb ff ff       	jmp    c0101d7b <__alltraps>

c01021fb <vector126>:
.globl vector126
vector126:
  pushl $0
c01021fb:	6a 00                	push   $0x0
  pushl $126
c01021fd:	6a 7e                	push   $0x7e
  jmp __alltraps
c01021ff:	e9 77 fb ff ff       	jmp    c0101d7b <__alltraps>

c0102204 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102204:	6a 00                	push   $0x0
  pushl $127
c0102206:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102208:	e9 6e fb ff ff       	jmp    c0101d7b <__alltraps>

c010220d <vector128>:
.globl vector128
vector128:
  pushl $0
c010220d:	6a 00                	push   $0x0
  pushl $128
c010220f:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102214:	e9 62 fb ff ff       	jmp    c0101d7b <__alltraps>

c0102219 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102219:	6a 00                	push   $0x0
  pushl $129
c010221b:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102220:	e9 56 fb ff ff       	jmp    c0101d7b <__alltraps>

c0102225 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102225:	6a 00                	push   $0x0
  pushl $130
c0102227:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c010222c:	e9 4a fb ff ff       	jmp    c0101d7b <__alltraps>

c0102231 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102231:	6a 00                	push   $0x0
  pushl $131
c0102233:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102238:	e9 3e fb ff ff       	jmp    c0101d7b <__alltraps>

c010223d <vector132>:
.globl vector132
vector132:
  pushl $0
c010223d:	6a 00                	push   $0x0
  pushl $132
c010223f:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102244:	e9 32 fb ff ff       	jmp    c0101d7b <__alltraps>

c0102249 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102249:	6a 00                	push   $0x0
  pushl $133
c010224b:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102250:	e9 26 fb ff ff       	jmp    c0101d7b <__alltraps>

c0102255 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102255:	6a 00                	push   $0x0
  pushl $134
c0102257:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c010225c:	e9 1a fb ff ff       	jmp    c0101d7b <__alltraps>

c0102261 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102261:	6a 00                	push   $0x0
  pushl $135
c0102263:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102268:	e9 0e fb ff ff       	jmp    c0101d7b <__alltraps>

c010226d <vector136>:
.globl vector136
vector136:
  pushl $0
c010226d:	6a 00                	push   $0x0
  pushl $136
c010226f:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102274:	e9 02 fb ff ff       	jmp    c0101d7b <__alltraps>

c0102279 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102279:	6a 00                	push   $0x0
  pushl $137
c010227b:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102280:	e9 f6 fa ff ff       	jmp    c0101d7b <__alltraps>

c0102285 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102285:	6a 00                	push   $0x0
  pushl $138
c0102287:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c010228c:	e9 ea fa ff ff       	jmp    c0101d7b <__alltraps>

c0102291 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102291:	6a 00                	push   $0x0
  pushl $139
c0102293:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102298:	e9 de fa ff ff       	jmp    c0101d7b <__alltraps>

c010229d <vector140>:
.globl vector140
vector140:
  pushl $0
c010229d:	6a 00                	push   $0x0
  pushl $140
c010229f:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c01022a4:	e9 d2 fa ff ff       	jmp    c0101d7b <__alltraps>

c01022a9 <vector141>:
.globl vector141
vector141:
  pushl $0
c01022a9:	6a 00                	push   $0x0
  pushl $141
c01022ab:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c01022b0:	e9 c6 fa ff ff       	jmp    c0101d7b <__alltraps>

c01022b5 <vector142>:
.globl vector142
vector142:
  pushl $0
c01022b5:	6a 00                	push   $0x0
  pushl $142
c01022b7:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c01022bc:	e9 ba fa ff ff       	jmp    c0101d7b <__alltraps>

c01022c1 <vector143>:
.globl vector143
vector143:
  pushl $0
c01022c1:	6a 00                	push   $0x0
  pushl $143
c01022c3:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c01022c8:	e9 ae fa ff ff       	jmp    c0101d7b <__alltraps>

c01022cd <vector144>:
.globl vector144
vector144:
  pushl $0
c01022cd:	6a 00                	push   $0x0
  pushl $144
c01022cf:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c01022d4:	e9 a2 fa ff ff       	jmp    c0101d7b <__alltraps>

c01022d9 <vector145>:
.globl vector145
vector145:
  pushl $0
c01022d9:	6a 00                	push   $0x0
  pushl $145
c01022db:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c01022e0:	e9 96 fa ff ff       	jmp    c0101d7b <__alltraps>

c01022e5 <vector146>:
.globl vector146
vector146:
  pushl $0
c01022e5:	6a 00                	push   $0x0
  pushl $146
c01022e7:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c01022ec:	e9 8a fa ff ff       	jmp    c0101d7b <__alltraps>

c01022f1 <vector147>:
.globl vector147
vector147:
  pushl $0
c01022f1:	6a 00                	push   $0x0
  pushl $147
c01022f3:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c01022f8:	e9 7e fa ff ff       	jmp    c0101d7b <__alltraps>

c01022fd <vector148>:
.globl vector148
vector148:
  pushl $0
c01022fd:	6a 00                	push   $0x0
  pushl $148
c01022ff:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102304:	e9 72 fa ff ff       	jmp    c0101d7b <__alltraps>

c0102309 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102309:	6a 00                	push   $0x0
  pushl $149
c010230b:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102310:	e9 66 fa ff ff       	jmp    c0101d7b <__alltraps>

c0102315 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102315:	6a 00                	push   $0x0
  pushl $150
c0102317:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c010231c:	e9 5a fa ff ff       	jmp    c0101d7b <__alltraps>

c0102321 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102321:	6a 00                	push   $0x0
  pushl $151
c0102323:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102328:	e9 4e fa ff ff       	jmp    c0101d7b <__alltraps>

c010232d <vector152>:
.globl vector152
vector152:
  pushl $0
c010232d:	6a 00                	push   $0x0
  pushl $152
c010232f:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102334:	e9 42 fa ff ff       	jmp    c0101d7b <__alltraps>

c0102339 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102339:	6a 00                	push   $0x0
  pushl $153
c010233b:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102340:	e9 36 fa ff ff       	jmp    c0101d7b <__alltraps>

c0102345 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102345:	6a 00                	push   $0x0
  pushl $154
c0102347:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c010234c:	e9 2a fa ff ff       	jmp    c0101d7b <__alltraps>

c0102351 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102351:	6a 00                	push   $0x0
  pushl $155
c0102353:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102358:	e9 1e fa ff ff       	jmp    c0101d7b <__alltraps>

c010235d <vector156>:
.globl vector156
vector156:
  pushl $0
c010235d:	6a 00                	push   $0x0
  pushl $156
c010235f:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102364:	e9 12 fa ff ff       	jmp    c0101d7b <__alltraps>

c0102369 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102369:	6a 00                	push   $0x0
  pushl $157
c010236b:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102370:	e9 06 fa ff ff       	jmp    c0101d7b <__alltraps>

c0102375 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102375:	6a 00                	push   $0x0
  pushl $158
c0102377:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c010237c:	e9 fa f9 ff ff       	jmp    c0101d7b <__alltraps>

c0102381 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102381:	6a 00                	push   $0x0
  pushl $159
c0102383:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102388:	e9 ee f9 ff ff       	jmp    c0101d7b <__alltraps>

c010238d <vector160>:
.globl vector160
vector160:
  pushl $0
c010238d:	6a 00                	push   $0x0
  pushl $160
c010238f:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102394:	e9 e2 f9 ff ff       	jmp    c0101d7b <__alltraps>

c0102399 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102399:	6a 00                	push   $0x0
  pushl $161
c010239b:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c01023a0:	e9 d6 f9 ff ff       	jmp    c0101d7b <__alltraps>

c01023a5 <vector162>:
.globl vector162
vector162:
  pushl $0
c01023a5:	6a 00                	push   $0x0
  pushl $162
c01023a7:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c01023ac:	e9 ca f9 ff ff       	jmp    c0101d7b <__alltraps>

c01023b1 <vector163>:
.globl vector163
vector163:
  pushl $0
c01023b1:	6a 00                	push   $0x0
  pushl $163
c01023b3:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c01023b8:	e9 be f9 ff ff       	jmp    c0101d7b <__alltraps>

c01023bd <vector164>:
.globl vector164
vector164:
  pushl $0
c01023bd:	6a 00                	push   $0x0
  pushl $164
c01023bf:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c01023c4:	e9 b2 f9 ff ff       	jmp    c0101d7b <__alltraps>

c01023c9 <vector165>:
.globl vector165
vector165:
  pushl $0
c01023c9:	6a 00                	push   $0x0
  pushl $165
c01023cb:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c01023d0:	e9 a6 f9 ff ff       	jmp    c0101d7b <__alltraps>

c01023d5 <vector166>:
.globl vector166
vector166:
  pushl $0
c01023d5:	6a 00                	push   $0x0
  pushl $166
c01023d7:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c01023dc:	e9 9a f9 ff ff       	jmp    c0101d7b <__alltraps>

c01023e1 <vector167>:
.globl vector167
vector167:
  pushl $0
c01023e1:	6a 00                	push   $0x0
  pushl $167
c01023e3:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c01023e8:	e9 8e f9 ff ff       	jmp    c0101d7b <__alltraps>

c01023ed <vector168>:
.globl vector168
vector168:
  pushl $0
c01023ed:	6a 00                	push   $0x0
  pushl $168
c01023ef:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c01023f4:	e9 82 f9 ff ff       	jmp    c0101d7b <__alltraps>

c01023f9 <vector169>:
.globl vector169
vector169:
  pushl $0
c01023f9:	6a 00                	push   $0x0
  pushl $169
c01023fb:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102400:	e9 76 f9 ff ff       	jmp    c0101d7b <__alltraps>

c0102405 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102405:	6a 00                	push   $0x0
  pushl $170
c0102407:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c010240c:	e9 6a f9 ff ff       	jmp    c0101d7b <__alltraps>

c0102411 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102411:	6a 00                	push   $0x0
  pushl $171
c0102413:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102418:	e9 5e f9 ff ff       	jmp    c0101d7b <__alltraps>

c010241d <vector172>:
.globl vector172
vector172:
  pushl $0
c010241d:	6a 00                	push   $0x0
  pushl $172
c010241f:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102424:	e9 52 f9 ff ff       	jmp    c0101d7b <__alltraps>

c0102429 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102429:	6a 00                	push   $0x0
  pushl $173
c010242b:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102430:	e9 46 f9 ff ff       	jmp    c0101d7b <__alltraps>

c0102435 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102435:	6a 00                	push   $0x0
  pushl $174
c0102437:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c010243c:	e9 3a f9 ff ff       	jmp    c0101d7b <__alltraps>

c0102441 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102441:	6a 00                	push   $0x0
  pushl $175
c0102443:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102448:	e9 2e f9 ff ff       	jmp    c0101d7b <__alltraps>

c010244d <vector176>:
.globl vector176
vector176:
  pushl $0
c010244d:	6a 00                	push   $0x0
  pushl $176
c010244f:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102454:	e9 22 f9 ff ff       	jmp    c0101d7b <__alltraps>

c0102459 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102459:	6a 00                	push   $0x0
  pushl $177
c010245b:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102460:	e9 16 f9 ff ff       	jmp    c0101d7b <__alltraps>

c0102465 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102465:	6a 00                	push   $0x0
  pushl $178
c0102467:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c010246c:	e9 0a f9 ff ff       	jmp    c0101d7b <__alltraps>

c0102471 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102471:	6a 00                	push   $0x0
  pushl $179
c0102473:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102478:	e9 fe f8 ff ff       	jmp    c0101d7b <__alltraps>

c010247d <vector180>:
.globl vector180
vector180:
  pushl $0
c010247d:	6a 00                	push   $0x0
  pushl $180
c010247f:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102484:	e9 f2 f8 ff ff       	jmp    c0101d7b <__alltraps>

c0102489 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102489:	6a 00                	push   $0x0
  pushl $181
c010248b:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102490:	e9 e6 f8 ff ff       	jmp    c0101d7b <__alltraps>

c0102495 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102495:	6a 00                	push   $0x0
  pushl $182
c0102497:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c010249c:	e9 da f8 ff ff       	jmp    c0101d7b <__alltraps>

c01024a1 <vector183>:
.globl vector183
vector183:
  pushl $0
c01024a1:	6a 00                	push   $0x0
  pushl $183
c01024a3:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c01024a8:	e9 ce f8 ff ff       	jmp    c0101d7b <__alltraps>

c01024ad <vector184>:
.globl vector184
vector184:
  pushl $0
c01024ad:	6a 00                	push   $0x0
  pushl $184
c01024af:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c01024b4:	e9 c2 f8 ff ff       	jmp    c0101d7b <__alltraps>

c01024b9 <vector185>:
.globl vector185
vector185:
  pushl $0
c01024b9:	6a 00                	push   $0x0
  pushl $185
c01024bb:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c01024c0:	e9 b6 f8 ff ff       	jmp    c0101d7b <__alltraps>

c01024c5 <vector186>:
.globl vector186
vector186:
  pushl $0
c01024c5:	6a 00                	push   $0x0
  pushl $186
c01024c7:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c01024cc:	e9 aa f8 ff ff       	jmp    c0101d7b <__alltraps>

c01024d1 <vector187>:
.globl vector187
vector187:
  pushl $0
c01024d1:	6a 00                	push   $0x0
  pushl $187
c01024d3:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c01024d8:	e9 9e f8 ff ff       	jmp    c0101d7b <__alltraps>

c01024dd <vector188>:
.globl vector188
vector188:
  pushl $0
c01024dd:	6a 00                	push   $0x0
  pushl $188
c01024df:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c01024e4:	e9 92 f8 ff ff       	jmp    c0101d7b <__alltraps>

c01024e9 <vector189>:
.globl vector189
vector189:
  pushl $0
c01024e9:	6a 00                	push   $0x0
  pushl $189
c01024eb:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c01024f0:	e9 86 f8 ff ff       	jmp    c0101d7b <__alltraps>

c01024f5 <vector190>:
.globl vector190
vector190:
  pushl $0
c01024f5:	6a 00                	push   $0x0
  pushl $190
c01024f7:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c01024fc:	e9 7a f8 ff ff       	jmp    c0101d7b <__alltraps>

c0102501 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102501:	6a 00                	push   $0x0
  pushl $191
c0102503:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102508:	e9 6e f8 ff ff       	jmp    c0101d7b <__alltraps>

c010250d <vector192>:
.globl vector192
vector192:
  pushl $0
c010250d:	6a 00                	push   $0x0
  pushl $192
c010250f:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102514:	e9 62 f8 ff ff       	jmp    c0101d7b <__alltraps>

c0102519 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102519:	6a 00                	push   $0x0
  pushl $193
c010251b:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102520:	e9 56 f8 ff ff       	jmp    c0101d7b <__alltraps>

c0102525 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102525:	6a 00                	push   $0x0
  pushl $194
c0102527:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c010252c:	e9 4a f8 ff ff       	jmp    c0101d7b <__alltraps>

c0102531 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102531:	6a 00                	push   $0x0
  pushl $195
c0102533:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102538:	e9 3e f8 ff ff       	jmp    c0101d7b <__alltraps>

c010253d <vector196>:
.globl vector196
vector196:
  pushl $0
c010253d:	6a 00                	push   $0x0
  pushl $196
c010253f:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102544:	e9 32 f8 ff ff       	jmp    c0101d7b <__alltraps>

c0102549 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102549:	6a 00                	push   $0x0
  pushl $197
c010254b:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102550:	e9 26 f8 ff ff       	jmp    c0101d7b <__alltraps>

c0102555 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102555:	6a 00                	push   $0x0
  pushl $198
c0102557:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c010255c:	e9 1a f8 ff ff       	jmp    c0101d7b <__alltraps>

c0102561 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102561:	6a 00                	push   $0x0
  pushl $199
c0102563:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102568:	e9 0e f8 ff ff       	jmp    c0101d7b <__alltraps>

c010256d <vector200>:
.globl vector200
vector200:
  pushl $0
c010256d:	6a 00                	push   $0x0
  pushl $200
c010256f:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102574:	e9 02 f8 ff ff       	jmp    c0101d7b <__alltraps>

c0102579 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102579:	6a 00                	push   $0x0
  pushl $201
c010257b:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102580:	e9 f6 f7 ff ff       	jmp    c0101d7b <__alltraps>

c0102585 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102585:	6a 00                	push   $0x0
  pushl $202
c0102587:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c010258c:	e9 ea f7 ff ff       	jmp    c0101d7b <__alltraps>

c0102591 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102591:	6a 00                	push   $0x0
  pushl $203
c0102593:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102598:	e9 de f7 ff ff       	jmp    c0101d7b <__alltraps>

c010259d <vector204>:
.globl vector204
vector204:
  pushl $0
c010259d:	6a 00                	push   $0x0
  pushl $204
c010259f:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c01025a4:	e9 d2 f7 ff ff       	jmp    c0101d7b <__alltraps>

c01025a9 <vector205>:
.globl vector205
vector205:
  pushl $0
c01025a9:	6a 00                	push   $0x0
  pushl $205
c01025ab:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c01025b0:	e9 c6 f7 ff ff       	jmp    c0101d7b <__alltraps>

c01025b5 <vector206>:
.globl vector206
vector206:
  pushl $0
c01025b5:	6a 00                	push   $0x0
  pushl $206
c01025b7:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c01025bc:	e9 ba f7 ff ff       	jmp    c0101d7b <__alltraps>

c01025c1 <vector207>:
.globl vector207
vector207:
  pushl $0
c01025c1:	6a 00                	push   $0x0
  pushl $207
c01025c3:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c01025c8:	e9 ae f7 ff ff       	jmp    c0101d7b <__alltraps>

c01025cd <vector208>:
.globl vector208
vector208:
  pushl $0
c01025cd:	6a 00                	push   $0x0
  pushl $208
c01025cf:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01025d4:	e9 a2 f7 ff ff       	jmp    c0101d7b <__alltraps>

c01025d9 <vector209>:
.globl vector209
vector209:
  pushl $0
c01025d9:	6a 00                	push   $0x0
  pushl $209
c01025db:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c01025e0:	e9 96 f7 ff ff       	jmp    c0101d7b <__alltraps>

c01025e5 <vector210>:
.globl vector210
vector210:
  pushl $0
c01025e5:	6a 00                	push   $0x0
  pushl $210
c01025e7:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c01025ec:	e9 8a f7 ff ff       	jmp    c0101d7b <__alltraps>

c01025f1 <vector211>:
.globl vector211
vector211:
  pushl $0
c01025f1:	6a 00                	push   $0x0
  pushl $211
c01025f3:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c01025f8:	e9 7e f7 ff ff       	jmp    c0101d7b <__alltraps>

c01025fd <vector212>:
.globl vector212
vector212:
  pushl $0
c01025fd:	6a 00                	push   $0x0
  pushl $212
c01025ff:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102604:	e9 72 f7 ff ff       	jmp    c0101d7b <__alltraps>

c0102609 <vector213>:
.globl vector213
vector213:
  pushl $0
c0102609:	6a 00                	push   $0x0
  pushl $213
c010260b:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102610:	e9 66 f7 ff ff       	jmp    c0101d7b <__alltraps>

c0102615 <vector214>:
.globl vector214
vector214:
  pushl $0
c0102615:	6a 00                	push   $0x0
  pushl $214
c0102617:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c010261c:	e9 5a f7 ff ff       	jmp    c0101d7b <__alltraps>

c0102621 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102621:	6a 00                	push   $0x0
  pushl $215
c0102623:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0102628:	e9 4e f7 ff ff       	jmp    c0101d7b <__alltraps>

c010262d <vector216>:
.globl vector216
vector216:
  pushl $0
c010262d:	6a 00                	push   $0x0
  pushl $216
c010262f:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102634:	e9 42 f7 ff ff       	jmp    c0101d7b <__alltraps>

c0102639 <vector217>:
.globl vector217
vector217:
  pushl $0
c0102639:	6a 00                	push   $0x0
  pushl $217
c010263b:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102640:	e9 36 f7 ff ff       	jmp    c0101d7b <__alltraps>

c0102645 <vector218>:
.globl vector218
vector218:
  pushl $0
c0102645:	6a 00                	push   $0x0
  pushl $218
c0102647:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c010264c:	e9 2a f7 ff ff       	jmp    c0101d7b <__alltraps>

c0102651 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102651:	6a 00                	push   $0x0
  pushl $219
c0102653:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0102658:	e9 1e f7 ff ff       	jmp    c0101d7b <__alltraps>

c010265d <vector220>:
.globl vector220
vector220:
  pushl $0
c010265d:	6a 00                	push   $0x0
  pushl $220
c010265f:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0102664:	e9 12 f7 ff ff       	jmp    c0101d7b <__alltraps>

c0102669 <vector221>:
.globl vector221
vector221:
  pushl $0
c0102669:	6a 00                	push   $0x0
  pushl $221
c010266b:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102670:	e9 06 f7 ff ff       	jmp    c0101d7b <__alltraps>

c0102675 <vector222>:
.globl vector222
vector222:
  pushl $0
c0102675:	6a 00                	push   $0x0
  pushl $222
c0102677:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c010267c:	e9 fa f6 ff ff       	jmp    c0101d7b <__alltraps>

c0102681 <vector223>:
.globl vector223
vector223:
  pushl $0
c0102681:	6a 00                	push   $0x0
  pushl $223
c0102683:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0102688:	e9 ee f6 ff ff       	jmp    c0101d7b <__alltraps>

c010268d <vector224>:
.globl vector224
vector224:
  pushl $0
c010268d:	6a 00                	push   $0x0
  pushl $224
c010268f:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0102694:	e9 e2 f6 ff ff       	jmp    c0101d7b <__alltraps>

c0102699 <vector225>:
.globl vector225
vector225:
  pushl $0
c0102699:	6a 00                	push   $0x0
  pushl $225
c010269b:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01026a0:	e9 d6 f6 ff ff       	jmp    c0101d7b <__alltraps>

c01026a5 <vector226>:
.globl vector226
vector226:
  pushl $0
c01026a5:	6a 00                	push   $0x0
  pushl $226
c01026a7:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01026ac:	e9 ca f6 ff ff       	jmp    c0101d7b <__alltraps>

c01026b1 <vector227>:
.globl vector227
vector227:
  pushl $0
c01026b1:	6a 00                	push   $0x0
  pushl $227
c01026b3:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01026b8:	e9 be f6 ff ff       	jmp    c0101d7b <__alltraps>

c01026bd <vector228>:
.globl vector228
vector228:
  pushl $0
c01026bd:	6a 00                	push   $0x0
  pushl $228
c01026bf:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01026c4:	e9 b2 f6 ff ff       	jmp    c0101d7b <__alltraps>

c01026c9 <vector229>:
.globl vector229
vector229:
  pushl $0
c01026c9:	6a 00                	push   $0x0
  pushl $229
c01026cb:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01026d0:	e9 a6 f6 ff ff       	jmp    c0101d7b <__alltraps>

c01026d5 <vector230>:
.globl vector230
vector230:
  pushl $0
c01026d5:	6a 00                	push   $0x0
  pushl $230
c01026d7:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01026dc:	e9 9a f6 ff ff       	jmp    c0101d7b <__alltraps>

c01026e1 <vector231>:
.globl vector231
vector231:
  pushl $0
c01026e1:	6a 00                	push   $0x0
  pushl $231
c01026e3:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01026e8:	e9 8e f6 ff ff       	jmp    c0101d7b <__alltraps>

c01026ed <vector232>:
.globl vector232
vector232:
  pushl $0
c01026ed:	6a 00                	push   $0x0
  pushl $232
c01026ef:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01026f4:	e9 82 f6 ff ff       	jmp    c0101d7b <__alltraps>

c01026f9 <vector233>:
.globl vector233
vector233:
  pushl $0
c01026f9:	6a 00                	push   $0x0
  pushl $233
c01026fb:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102700:	e9 76 f6 ff ff       	jmp    c0101d7b <__alltraps>

c0102705 <vector234>:
.globl vector234
vector234:
  pushl $0
c0102705:	6a 00                	push   $0x0
  pushl $234
c0102707:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c010270c:	e9 6a f6 ff ff       	jmp    c0101d7b <__alltraps>

c0102711 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102711:	6a 00                	push   $0x0
  pushl $235
c0102713:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0102718:	e9 5e f6 ff ff       	jmp    c0101d7b <__alltraps>

c010271d <vector236>:
.globl vector236
vector236:
  pushl $0
c010271d:	6a 00                	push   $0x0
  pushl $236
c010271f:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0102724:	e9 52 f6 ff ff       	jmp    c0101d7b <__alltraps>

c0102729 <vector237>:
.globl vector237
vector237:
  pushl $0
c0102729:	6a 00                	push   $0x0
  pushl $237
c010272b:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102730:	e9 46 f6 ff ff       	jmp    c0101d7b <__alltraps>

c0102735 <vector238>:
.globl vector238
vector238:
  pushl $0
c0102735:	6a 00                	push   $0x0
  pushl $238
c0102737:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c010273c:	e9 3a f6 ff ff       	jmp    c0101d7b <__alltraps>

c0102741 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102741:	6a 00                	push   $0x0
  pushl $239
c0102743:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0102748:	e9 2e f6 ff ff       	jmp    c0101d7b <__alltraps>

c010274d <vector240>:
.globl vector240
vector240:
  pushl $0
c010274d:	6a 00                	push   $0x0
  pushl $240
c010274f:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102754:	e9 22 f6 ff ff       	jmp    c0101d7b <__alltraps>

c0102759 <vector241>:
.globl vector241
vector241:
  pushl $0
c0102759:	6a 00                	push   $0x0
  pushl $241
c010275b:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102760:	e9 16 f6 ff ff       	jmp    c0101d7b <__alltraps>

c0102765 <vector242>:
.globl vector242
vector242:
  pushl $0
c0102765:	6a 00                	push   $0x0
  pushl $242
c0102767:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c010276c:	e9 0a f6 ff ff       	jmp    c0101d7b <__alltraps>

c0102771 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102771:	6a 00                	push   $0x0
  pushl $243
c0102773:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0102778:	e9 fe f5 ff ff       	jmp    c0101d7b <__alltraps>

c010277d <vector244>:
.globl vector244
vector244:
  pushl $0
c010277d:	6a 00                	push   $0x0
  pushl $244
c010277f:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0102784:	e9 f2 f5 ff ff       	jmp    c0101d7b <__alltraps>

c0102789 <vector245>:
.globl vector245
vector245:
  pushl $0
c0102789:	6a 00                	push   $0x0
  pushl $245
c010278b:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0102790:	e9 e6 f5 ff ff       	jmp    c0101d7b <__alltraps>

c0102795 <vector246>:
.globl vector246
vector246:
  pushl $0
c0102795:	6a 00                	push   $0x0
  pushl $246
c0102797:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c010279c:	e9 da f5 ff ff       	jmp    c0101d7b <__alltraps>

c01027a1 <vector247>:
.globl vector247
vector247:
  pushl $0
c01027a1:	6a 00                	push   $0x0
  pushl $247
c01027a3:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01027a8:	e9 ce f5 ff ff       	jmp    c0101d7b <__alltraps>

c01027ad <vector248>:
.globl vector248
vector248:
  pushl $0
c01027ad:	6a 00                	push   $0x0
  pushl $248
c01027af:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01027b4:	e9 c2 f5 ff ff       	jmp    c0101d7b <__alltraps>

c01027b9 <vector249>:
.globl vector249
vector249:
  pushl $0
c01027b9:	6a 00                	push   $0x0
  pushl $249
c01027bb:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01027c0:	e9 b6 f5 ff ff       	jmp    c0101d7b <__alltraps>

c01027c5 <vector250>:
.globl vector250
vector250:
  pushl $0
c01027c5:	6a 00                	push   $0x0
  pushl $250
c01027c7:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01027cc:	e9 aa f5 ff ff       	jmp    c0101d7b <__alltraps>

c01027d1 <vector251>:
.globl vector251
vector251:
  pushl $0
c01027d1:	6a 00                	push   $0x0
  pushl $251
c01027d3:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01027d8:	e9 9e f5 ff ff       	jmp    c0101d7b <__alltraps>

c01027dd <vector252>:
.globl vector252
vector252:
  pushl $0
c01027dd:	6a 00                	push   $0x0
  pushl $252
c01027df:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01027e4:	e9 92 f5 ff ff       	jmp    c0101d7b <__alltraps>

c01027e9 <vector253>:
.globl vector253
vector253:
  pushl $0
c01027e9:	6a 00                	push   $0x0
  pushl $253
c01027eb:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01027f0:	e9 86 f5 ff ff       	jmp    c0101d7b <__alltraps>

c01027f5 <vector254>:
.globl vector254
vector254:
  pushl $0
c01027f5:	6a 00                	push   $0x0
  pushl $254
c01027f7:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01027fc:	e9 7a f5 ff ff       	jmp    c0101d7b <__alltraps>

c0102801 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102801:	6a 00                	push   $0x0
  pushl $255
c0102803:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0102808:	e9 6e f5 ff ff       	jmp    c0101d7b <__alltraps>

c010280d <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010280d:	55                   	push   %ebp
c010280e:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102810:	8b 55 08             	mov    0x8(%ebp),%edx
c0102813:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0102818:	29 c2                	sub    %eax,%edx
c010281a:	89 d0                	mov    %edx,%eax
c010281c:	c1 f8 02             	sar    $0x2,%eax
c010281f:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0102825:	5d                   	pop    %ebp
c0102826:	c3                   	ret    

c0102827 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0102827:	55                   	push   %ebp
c0102828:	89 e5                	mov    %esp,%ebp
c010282a:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010282d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102830:	89 04 24             	mov    %eax,(%esp)
c0102833:	e8 d5 ff ff ff       	call   c010280d <page2ppn>
c0102838:	c1 e0 0c             	shl    $0xc,%eax
}
c010283b:	c9                   	leave  
c010283c:	c3                   	ret    

c010283d <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c010283d:	55                   	push   %ebp
c010283e:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102840:	8b 45 08             	mov    0x8(%ebp),%eax
c0102843:	8b 00                	mov    (%eax),%eax
}
c0102845:	5d                   	pop    %ebp
c0102846:	c3                   	ret    

c0102847 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102847:	55                   	push   %ebp
c0102848:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c010284a:	8b 45 08             	mov    0x8(%ebp),%eax
c010284d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102850:	89 10                	mov    %edx,(%eax)
}
c0102852:	5d                   	pop    %ebp
c0102853:	c3                   	ret    

c0102854 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0102854:	55                   	push   %ebp
c0102855:	89 e5                	mov    %esp,%ebp
c0102857:	83 ec 10             	sub    $0x10,%esp
c010285a:	c7 45 fc 50 89 11 c0 	movl   $0xc0118950,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0102861:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102864:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102867:	89 50 04             	mov    %edx,0x4(%eax)
c010286a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010286d:	8b 50 04             	mov    0x4(%eax),%edx
c0102870:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102873:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0102875:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c010287c:	00 00 00 
}
c010287f:	c9                   	leave  
c0102880:	c3                   	ret    

c0102881 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0102881:	55                   	push   %ebp
c0102882:	89 e5                	mov    %esp,%ebp
c0102884:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c0102887:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010288b:	75 24                	jne    c01028b1 <default_init_memmap+0x30>
c010288d:	c7 44 24 0c 90 65 10 	movl   $0xc0106590,0xc(%esp)
c0102894:	c0 
c0102895:	c7 44 24 08 96 65 10 	movl   $0xc0106596,0x8(%esp)
c010289c:	c0 
c010289d:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c01028a4:	00 
c01028a5:	c7 04 24 ab 65 10 c0 	movl   $0xc01065ab,(%esp)
c01028ac:	e8 14 e4 ff ff       	call   c0100cc5 <__panic>
    struct Page* p = base;
c01028b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01028b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for(; p != base + n; p ++)
c01028b7:	e9 d2 00 00 00       	jmp    c010298e <default_init_memmap+0x10d>
    {
	assert(PageReserved(p));
c01028bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01028bf:	83 c0 04             	add    $0x4,%eax
c01028c2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01028c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01028cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01028cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01028d2:	0f a3 10             	bt     %edx,(%eax)
c01028d5:	19 c0                	sbb    %eax,%eax
c01028d7:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c01028da:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01028de:	0f 95 c0             	setne  %al
c01028e1:	0f b6 c0             	movzbl %al,%eax
c01028e4:	85 c0                	test   %eax,%eax
c01028e6:	75 24                	jne    c010290c <default_init_memmap+0x8b>
c01028e8:	c7 44 24 0c c1 65 10 	movl   $0xc01065c1,0xc(%esp)
c01028ef:	c0 
c01028f0:	c7 44 24 08 96 65 10 	movl   $0xc0106596,0x8(%esp)
c01028f7:	c0 
c01028f8:	c7 44 24 04 4a 00 00 	movl   $0x4a,0x4(%esp)
c01028ff:	00 
c0102900:	c7 04 24 ab 65 10 c0 	movl   $0xc01065ab,(%esp)
c0102907:	e8 b9 e3 ff ff       	call   c0100cc5 <__panic>
	SetPageProperty(p);
c010290c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010290f:	83 c0 04             	add    $0x4,%eax
c0102912:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0102919:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010291c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010291f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102922:	0f ab 10             	bts    %edx,(%eax)
	p->property = 0;
c0102925:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102928:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	set_page_ref(p, 0);
c010292f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102936:	00 
c0102937:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010293a:	89 04 24             	mov    %eax,(%esp)
c010293d:	e8 05 ff ff ff       	call   c0102847 <set_page_ref>
	list_add_before(&free_list, &(p->page_link));
c0102942:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102945:	83 c0 0c             	add    $0xc,%eax
c0102948:	c7 45 dc 50 89 11 c0 	movl   $0xc0118950,-0x24(%ebp)
c010294f:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102952:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102955:	8b 00                	mov    (%eax),%eax
c0102957:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010295a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010295d:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102960:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102963:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102966:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102969:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010296c:	89 10                	mov    %edx,(%eax)
c010296e:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102971:	8b 10                	mov    (%eax),%edx
c0102973:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102976:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102979:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010297c:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010297f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102982:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102985:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102988:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page* p = base;
    for(; p != base + n; p ++)
c010298a:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c010298e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102991:	89 d0                	mov    %edx,%eax
c0102993:	c1 e0 02             	shl    $0x2,%eax
c0102996:	01 d0                	add    %edx,%eax
c0102998:	c1 e0 02             	shl    $0x2,%eax
c010299b:	89 c2                	mov    %eax,%edx
c010299d:	8b 45 08             	mov    0x8(%ebp),%eax
c01029a0:	01 d0                	add    %edx,%eax
c01029a2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01029a5:	0f 85 11 ff ff ff    	jne    c01028bc <default_init_memmap+0x3b>
	SetPageProperty(p);
	p->property = 0;
	set_page_ref(p, 0);
	list_add_before(&free_list, &(p->page_link));
    }
    base->property = n;
c01029ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01029ae:	8b 55 0c             	mov    0xc(%ebp),%edx
c01029b1:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free+=n;
c01029b4:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c01029ba:	8b 45 0c             	mov    0xc(%ebp),%eax
c01029bd:	01 d0                	add    %edx,%eax
c01029bf:	a3 58 89 11 c0       	mov    %eax,0xc0118958
}
c01029c4:	c9                   	leave  
c01029c5:	c3                   	ret    

c01029c6 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c01029c6:	55                   	push   %ebp
c01029c7:	89 e5                	mov    %esp,%ebp
c01029c9:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c01029cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01029d0:	75 24                	jne    c01029f6 <default_alloc_pages+0x30>
c01029d2:	c7 44 24 0c 90 65 10 	movl   $0xc0106590,0xc(%esp)
c01029d9:	c0 
c01029da:	c7 44 24 08 96 65 10 	movl   $0xc0106596,0x8(%esp)
c01029e1:	c0 
c01029e2:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
c01029e9:	00 
c01029ea:	c7 04 24 ab 65 10 c0 	movl   $0xc01065ab,(%esp)
c01029f1:	e8 cf e2 ff ff       	call   c0100cc5 <__panic>
    if(n > nr_free){
c01029f6:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c01029fb:	3b 45 08             	cmp    0x8(%ebp),%eax
c01029fe:	73 0a                	jae    c0102a0a <default_alloc_pages+0x44>
	return NULL;
c0102a00:	b8 00 00 00 00       	mov    $0x0,%eax
c0102a05:	e9 45 01 00 00       	jmp    c0102b4f <default_alloc_pages+0x189>
    }
    struct Page *page = NULL;
c0102a0a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0102a11:	c7 45 f0 50 89 11 c0 	movl   $0xc0118950,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0102a18:	eb 1c                	jmp    c0102a36 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c0102a1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102a1d:	83 e8 0c             	sub    $0xc,%eax
c0102a20:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if (p->property >= n) {
c0102a23:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102a26:	8b 40 08             	mov    0x8(%eax),%eax
c0102a29:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102a2c:	72 08                	jb     c0102a36 <default_alloc_pages+0x70>
            page = p;
c0102a2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102a31:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0102a34:	eb 18                	jmp    c0102a4e <default_alloc_pages+0x88>
c0102a36:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102a39:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102a3c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102a3f:	8b 40 04             	mov    0x4(%eax),%eax
    if(n > nr_free){
	return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0102a42:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102a45:	81 7d f0 50 89 11 c0 	cmpl   $0xc0118950,-0x10(%ebp)
c0102a4c:	75 cc                	jne    c0102a1a <default_alloc_pages+0x54>
            page = p;
            break;
        }
    }
    list_entry_t *tle;
    if (page != NULL) {
c0102a4e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102a52:	0f 84 f2 00 00 00    	je     c0102b4a <default_alloc_pages+0x184>
	int i = n;
c0102a58:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a5b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	while(i--)
c0102a5e:	eb 78                	jmp    c0102ad8 <default_alloc_pages+0x112>
c0102a60:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102a63:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0102a66:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102a69:	8b 40 04             	mov    0x4(%eax),%eax
	{
	    tle = list_next(le);
c0102a6c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    struct Page *tp = le2page(le, page_link);
c0102a6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102a72:	83 e8 0c             	sub    $0xc,%eax
c0102a75:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    SetPageReserved(tp);
c0102a78:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102a7b:	83 c0 04             	add    $0x4,%eax
c0102a7e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
c0102a85:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102a88:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102a8b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102a8e:	0f ab 10             	bts    %edx,(%eax)
	    ClearPageProperty(tp);
c0102a91:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102a94:	83 c0 04             	add    $0x4,%eax
c0102a97:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c0102a9e:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102aa1:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102aa4:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102aa7:	0f b3 10             	btr    %edx,(%eax)
c0102aaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102aad:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102ab0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102ab3:	8b 40 04             	mov    0x4(%eax),%eax
c0102ab6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102ab9:	8b 12                	mov    (%edx),%edx
c0102abb:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0102abe:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102ac1:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102ac4:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102ac7:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102aca:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102acd:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102ad0:	89 10                	mov    %edx,(%eax)
	    list_del(le);
	    le = tle;
c0102ad2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102ad5:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
    }
    list_entry_t *tle;
    if (page != NULL) {
	int i = n;
	while(i--)
c0102ad8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102adb:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102ade:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0102ae1:	85 c0                	test   %eax,%eax
c0102ae3:	0f 85 77 ff ff ff    	jne    c0102a60 <default_alloc_pages+0x9a>
	    SetPageReserved(tp);
	    ClearPageProperty(tp);
	    list_del(le);
	    le = tle;
	}
	if(page->property > n)
c0102ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102aec:	8b 40 08             	mov    0x8(%eax),%eax
c0102aef:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102af2:	76 12                	jbe    c0102b06 <default_alloc_pages+0x140>
	{
	    (le2page(le,page_link))->property = page->property - n;
c0102af4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102af7:	8d 50 f4             	lea    -0xc(%eax),%edx
c0102afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102afd:	8b 40 08             	mov    0x8(%eax),%eax
c0102b00:	2b 45 08             	sub    0x8(%ebp),%eax
c0102b03:	89 42 08             	mov    %eax,0x8(%edx)
	}
	ClearPageProperty(page);
c0102b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b09:	83 c0 04             	add    $0x4,%eax
c0102b0c:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0102b13:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0102b16:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102b19:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102b1c:	0f b3 10             	btr    %edx,(%eax)
	SetPageReserved(page);
c0102b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b22:	83 c0 04             	add    $0x4,%eax
c0102b25:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
c0102b2c:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102b2f:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102b32:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102b35:	0f ab 10             	bts    %edx,(%eax)
	nr_free -= n;
c0102b38:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102b3d:	2b 45 08             	sub    0x8(%ebp),%eax
c0102b40:	a3 58 89 11 c0       	mov    %eax,0xc0118958
	return page;
c0102b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b48:	eb 05                	jmp    c0102b4f <default_alloc_pages+0x189>
    }
    return NULL;
c0102b4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102b4f:	c9                   	leave  
c0102b50:	c3                   	ret    

c0102b51 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0102b51:	55                   	push   %ebp
c0102b52:	89 e5                	mov    %esp,%ebp
c0102b54:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c0102b57:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102b5b:	75 24                	jne    c0102b81 <default_free_pages+0x30>
c0102b5d:	c7 44 24 0c 90 65 10 	movl   $0xc0106590,0xc(%esp)
c0102b64:	c0 
c0102b65:	c7 44 24 08 96 65 10 	movl   $0xc0106596,0x8(%esp)
c0102b6c:	c0 
c0102b6d:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c0102b74:	00 
c0102b75:	c7 04 24 ab 65 10 c0 	movl   $0xc01065ab,(%esp)
c0102b7c:	e8 44 e1 ff ff       	call   c0100cc5 <__panic>
    struct Page *p = base;
c0102b81:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b84:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0102b87:	c7 45 f0 50 89 11 c0 	movl   $0xc0118950,-0x10(%ebp)
    while((le = list_next(le)) != &free_list)
c0102b8e:	eb 13                	jmp    c0102ba3 <default_free_pages+0x52>
    {
	p = le2page(le, page_link);
c0102b90:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102b93:	83 e8 0c             	sub    $0xc,%eax
c0102b96:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(p > base) 
c0102b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b9c:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102b9f:	76 02                	jbe    c0102ba3 <default_free_pages+0x52>
	    break;
c0102ba1:	eb 18                	jmp    c0102bbb <default_free_pages+0x6a>
c0102ba3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ba6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102ba9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102bac:	8b 40 04             	mov    0x4(%eax),%eax
static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    list_entry_t *le = &free_list;
    while((le = list_next(le)) != &free_list)
c0102baf:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102bb2:	81 7d f0 50 89 11 c0 	cmpl   $0xc0118950,-0x10(%ebp)
c0102bb9:	75 d5                	jne    c0102b90 <default_free_pages+0x3f>
    {
	p = le2page(le, page_link);
	if(p > base) 
	    break;
    }
    for(p=base;p<base+n;p++){
c0102bbb:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102bc1:	eb 4b                	jmp    c0102c0e <default_free_pages+0xbd>
	list_add_before(le, &(p->page_link));
c0102bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bc6:	8d 50 0c             	lea    0xc(%eax),%edx
c0102bc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102bcc:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0102bcf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102bd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102bd5:	8b 00                	mov    (%eax),%eax
c0102bd7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102bda:	89 55 e0             	mov    %edx,-0x20(%ebp)
c0102bdd:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0102be0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102be3:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102be6:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102be9:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102bec:	89 10                	mov    %edx,(%eax)
c0102bee:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102bf1:	8b 10                	mov    (%eax),%edx
c0102bf3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102bf6:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102bf9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102bfc:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102bff:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102c02:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102c05:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102c08:	89 10                	mov    %edx,(%eax)
    {
	p = le2page(le, page_link);
	if(p > base) 
	    break;
    }
    for(p=base;p<base+n;p++){
c0102c0a:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102c0e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102c11:	89 d0                	mov    %edx,%eax
c0102c13:	c1 e0 02             	shl    $0x2,%eax
c0102c16:	01 d0                	add    %edx,%eax
c0102c18:	c1 e0 02             	shl    $0x2,%eax
c0102c1b:	89 c2                	mov    %eax,%edx
c0102c1d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c20:	01 d0                	add    %edx,%eax
c0102c22:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102c25:	77 9c                	ja     c0102bc3 <default_free_pages+0x72>
	list_add_before(le, &(p->page_link));
    }
    base->flags = 0;
c0102c27:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c2a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    set_page_ref(base, 0);
c0102c31:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102c38:	00 
c0102c39:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c3c:	89 04 24             	mov    %eax,(%esp)
c0102c3f:	e8 03 fc ff ff       	call   c0102847 <set_page_ref>
    SetPageProperty(base);
c0102c44:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c47:	83 c0 04             	add    $0x4,%eax
c0102c4a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0102c51:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102c54:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102c57:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102c5a:	0f ab 10             	bts    %edx,(%eax)
    base->property = n;
c0102c5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c60:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102c63:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free += n;
c0102c66:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c0102c6c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102c6f:	01 d0                	add    %edx,%eax
c0102c71:	a3 58 89 11 c0       	mov    %eax,0xc0118958
    p = le2page(le,page_link) ;
c0102c76:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102c79:	83 e8 0c             	sub    $0xc,%eax
c0102c7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if( base + n == p ){
c0102c7f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102c82:	89 d0                	mov    %edx,%eax
c0102c84:	c1 e0 02             	shl    $0x2,%eax
c0102c87:	01 d0                	add    %edx,%eax
c0102c89:	c1 e0 02             	shl    $0x2,%eax
c0102c8c:	89 c2                	mov    %eax,%edx
c0102c8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c91:	01 d0                	add    %edx,%eax
c0102c93:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102c96:	75 1e                	jne    c0102cb6 <default_free_pages+0x165>
	base->property += p->property;
c0102c98:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c9b:	8b 50 08             	mov    0x8(%eax),%edx
c0102c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ca1:	8b 40 08             	mov    0x8(%eax),%eax
c0102ca4:	01 c2                	add    %eax,%edx
c0102ca6:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ca9:	89 50 08             	mov    %edx,0x8(%eax)
	p->property = 0;
c0102cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102caf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    }
    le =  list_prev(&(base->page_link));
c0102cb6:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cb9:	83 c0 0c             	add    $0xc,%eax
c0102cbc:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c0102cbf:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102cc2:	8b 00                	mov    (%eax),%eax
c0102cc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    p = le2page(le,page_link);
c0102cc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102cca:	83 e8 0c             	sub    $0xc,%eax
c0102ccd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(le!=&free_list && p == base - 1)
c0102cd0:	81 7d f0 50 89 11 c0 	cmpl   $0xc0118950,-0x10(%ebp)
c0102cd7:	74 52                	je     c0102d2b <default_free_pages+0x1da>
c0102cd9:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cdc:	83 e8 14             	sub    $0x14,%eax
c0102cdf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102ce2:	75 47                	jne    c0102d2b <default_free_pages+0x1da>
    {
	while(le != &free_list)
c0102ce4:	eb 3c                	jmp    c0102d22 <default_free_pages+0x1d1>
	{
	    if(p -> property > 0)
c0102ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ce9:	8b 40 08             	mov    0x8(%eax),%eax
c0102cec:	85 c0                	test   %eax,%eax
c0102cee:	74 20                	je     c0102d10 <default_free_pages+0x1bf>
	    {
		p->property += base->property;
c0102cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cf3:	8b 50 08             	mov    0x8(%eax),%edx
c0102cf6:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cf9:	8b 40 08             	mov    0x8(%eax),%eax
c0102cfc:	01 c2                	add    %eax,%edx
c0102cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d01:	89 50 08             	mov    %edx,0x8(%eax)
		base->property = 0;
c0102d04:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d07:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		break;
c0102d0e:	eb 1b                	jmp    c0102d2b <default_free_pages+0x1da>
c0102d10:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d13:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102d16:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102d19:	8b 00                	mov    (%eax),%eax
	    }
	    le = list_prev(le);
c0102d1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    p--;
c0102d1e:	83 6d f4 14          	subl   $0x14,-0xc(%ebp)
    }
    le =  list_prev(&(base->page_link));
    p = le2page(le,page_link);
    if(le!=&free_list && p == base - 1)
    {
	while(le != &free_list)
c0102d22:	81 7d f0 50 89 11 c0 	cmpl   $0xc0118950,-0x10(%ebp)
c0102d29:	75 bb                	jne    c0102ce6 <default_free_pages+0x195>
	    }
	    le = list_prev(le);
	    p--;
    	}
    }
}
c0102d2b:	c9                   	leave  
c0102d2c:	c3                   	ret    

c0102d2d <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0102d2d:	55                   	push   %ebp
c0102d2e:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0102d30:	a1 58 89 11 c0       	mov    0xc0118958,%eax
}
c0102d35:	5d                   	pop    %ebp
c0102d36:	c3                   	ret    

c0102d37 <basic_check>:

static void
basic_check(void) {
c0102d37:	55                   	push   %ebp
c0102d38:	89 e5                	mov    %esp,%ebp
c0102d3a:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0102d3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d47:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102d4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0102d50:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102d57:	e8 85 0e 00 00       	call   c0103be1 <alloc_pages>
c0102d5c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102d5f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102d63:	75 24                	jne    c0102d89 <basic_check+0x52>
c0102d65:	c7 44 24 0c d1 65 10 	movl   $0xc01065d1,0xc(%esp)
c0102d6c:	c0 
c0102d6d:	c7 44 24 08 96 65 10 	movl   $0xc0106596,0x8(%esp)
c0102d74:	c0 
c0102d75:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
c0102d7c:	00 
c0102d7d:	c7 04 24 ab 65 10 c0 	movl   $0xc01065ab,(%esp)
c0102d84:	e8 3c df ff ff       	call   c0100cc5 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0102d89:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102d90:	e8 4c 0e 00 00       	call   c0103be1 <alloc_pages>
c0102d95:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102d98:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102d9c:	75 24                	jne    c0102dc2 <basic_check+0x8b>
c0102d9e:	c7 44 24 0c ed 65 10 	movl   $0xc01065ed,0xc(%esp)
c0102da5:	c0 
c0102da6:	c7 44 24 08 96 65 10 	movl   $0xc0106596,0x8(%esp)
c0102dad:	c0 
c0102dae:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
c0102db5:	00 
c0102db6:	c7 04 24 ab 65 10 c0 	movl   $0xc01065ab,(%esp)
c0102dbd:	e8 03 df ff ff       	call   c0100cc5 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0102dc2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102dc9:	e8 13 0e 00 00       	call   c0103be1 <alloc_pages>
c0102dce:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102dd1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102dd5:	75 24                	jne    c0102dfb <basic_check+0xc4>
c0102dd7:	c7 44 24 0c 09 66 10 	movl   $0xc0106609,0xc(%esp)
c0102dde:	c0 
c0102ddf:	c7 44 24 08 96 65 10 	movl   $0xc0106596,0x8(%esp)
c0102de6:	c0 
c0102de7:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
c0102dee:	00 
c0102def:	c7 04 24 ab 65 10 c0 	movl   $0xc01065ab,(%esp)
c0102df6:	e8 ca de ff ff       	call   c0100cc5 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0102dfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102dfe:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102e01:	74 10                	je     c0102e13 <basic_check+0xdc>
c0102e03:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102e06:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102e09:	74 08                	je     c0102e13 <basic_check+0xdc>
c0102e0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e0e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102e11:	75 24                	jne    c0102e37 <basic_check+0x100>
c0102e13:	c7 44 24 0c 28 66 10 	movl   $0xc0106628,0xc(%esp)
c0102e1a:	c0 
c0102e1b:	c7 44 24 08 96 65 10 	movl   $0xc0106596,0x8(%esp)
c0102e22:	c0 
c0102e23:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
c0102e2a:	00 
c0102e2b:	c7 04 24 ab 65 10 c0 	movl   $0xc01065ab,(%esp)
c0102e32:	e8 8e de ff ff       	call   c0100cc5 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0102e37:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102e3a:	89 04 24             	mov    %eax,(%esp)
c0102e3d:	e8 fb f9 ff ff       	call   c010283d <page_ref>
c0102e42:	85 c0                	test   %eax,%eax
c0102e44:	75 1e                	jne    c0102e64 <basic_check+0x12d>
c0102e46:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e49:	89 04 24             	mov    %eax,(%esp)
c0102e4c:	e8 ec f9 ff ff       	call   c010283d <page_ref>
c0102e51:	85 c0                	test   %eax,%eax
c0102e53:	75 0f                	jne    c0102e64 <basic_check+0x12d>
c0102e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e58:	89 04 24             	mov    %eax,(%esp)
c0102e5b:	e8 dd f9 ff ff       	call   c010283d <page_ref>
c0102e60:	85 c0                	test   %eax,%eax
c0102e62:	74 24                	je     c0102e88 <basic_check+0x151>
c0102e64:	c7 44 24 0c 4c 66 10 	movl   $0xc010664c,0xc(%esp)
c0102e6b:	c0 
c0102e6c:	c7 44 24 08 96 65 10 	movl   $0xc0106596,0x8(%esp)
c0102e73:	c0 
c0102e74:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
c0102e7b:	00 
c0102e7c:	c7 04 24 ab 65 10 c0 	movl   $0xc01065ab,(%esp)
c0102e83:	e8 3d de ff ff       	call   c0100cc5 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0102e88:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102e8b:	89 04 24             	mov    %eax,(%esp)
c0102e8e:	e8 94 f9 ff ff       	call   c0102827 <page2pa>
c0102e93:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102e99:	c1 e2 0c             	shl    $0xc,%edx
c0102e9c:	39 d0                	cmp    %edx,%eax
c0102e9e:	72 24                	jb     c0102ec4 <basic_check+0x18d>
c0102ea0:	c7 44 24 0c 88 66 10 	movl   $0xc0106688,0xc(%esp)
c0102ea7:	c0 
c0102ea8:	c7 44 24 08 96 65 10 	movl   $0xc0106596,0x8(%esp)
c0102eaf:	c0 
c0102eb0:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
c0102eb7:	00 
c0102eb8:	c7 04 24 ab 65 10 c0 	movl   $0xc01065ab,(%esp)
c0102ebf:	e8 01 de ff ff       	call   c0100cc5 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0102ec4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ec7:	89 04 24             	mov    %eax,(%esp)
c0102eca:	e8 58 f9 ff ff       	call   c0102827 <page2pa>
c0102ecf:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102ed5:	c1 e2 0c             	shl    $0xc,%edx
c0102ed8:	39 d0                	cmp    %edx,%eax
c0102eda:	72 24                	jb     c0102f00 <basic_check+0x1c9>
c0102edc:	c7 44 24 0c a5 66 10 	movl   $0xc01066a5,0xc(%esp)
c0102ee3:	c0 
c0102ee4:	c7 44 24 08 96 65 10 	movl   $0xc0106596,0x8(%esp)
c0102eeb:	c0 
c0102eec:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
c0102ef3:	00 
c0102ef4:	c7 04 24 ab 65 10 c0 	movl   $0xc01065ab,(%esp)
c0102efb:	e8 c5 dd ff ff       	call   c0100cc5 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0102f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f03:	89 04 24             	mov    %eax,(%esp)
c0102f06:	e8 1c f9 ff ff       	call   c0102827 <page2pa>
c0102f0b:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102f11:	c1 e2 0c             	shl    $0xc,%edx
c0102f14:	39 d0                	cmp    %edx,%eax
c0102f16:	72 24                	jb     c0102f3c <basic_check+0x205>
c0102f18:	c7 44 24 0c c2 66 10 	movl   $0xc01066c2,0xc(%esp)
c0102f1f:	c0 
c0102f20:	c7 44 24 08 96 65 10 	movl   $0xc0106596,0x8(%esp)
c0102f27:	c0 
c0102f28:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
c0102f2f:	00 
c0102f30:	c7 04 24 ab 65 10 c0 	movl   $0xc01065ab,(%esp)
c0102f37:	e8 89 dd ff ff       	call   c0100cc5 <__panic>

    list_entry_t free_list_store = free_list;
c0102f3c:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102f41:	8b 15 54 89 11 c0    	mov    0xc0118954,%edx
c0102f47:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102f4a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102f4d:	c7 45 e0 50 89 11 c0 	movl   $0xc0118950,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0102f54:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102f57:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102f5a:	89 50 04             	mov    %edx,0x4(%eax)
c0102f5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102f60:	8b 50 04             	mov    0x4(%eax),%edx
c0102f63:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102f66:	89 10                	mov    %edx,(%eax)
c0102f68:	c7 45 dc 50 89 11 c0 	movl   $0xc0118950,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0102f6f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102f72:	8b 40 04             	mov    0x4(%eax),%eax
c0102f75:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0102f78:	0f 94 c0             	sete   %al
c0102f7b:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0102f7e:	85 c0                	test   %eax,%eax
c0102f80:	75 24                	jne    c0102fa6 <basic_check+0x26f>
c0102f82:	c7 44 24 0c df 66 10 	movl   $0xc01066df,0xc(%esp)
c0102f89:	c0 
c0102f8a:	c7 44 24 08 96 65 10 	movl   $0xc0106596,0x8(%esp)
c0102f91:	c0 
c0102f92:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
c0102f99:	00 
c0102f9a:	c7 04 24 ab 65 10 c0 	movl   $0xc01065ab,(%esp)
c0102fa1:	e8 1f dd ff ff       	call   c0100cc5 <__panic>

    unsigned int nr_free_store = nr_free;
c0102fa6:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102fab:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0102fae:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c0102fb5:	00 00 00 

    assert(alloc_page() == NULL);
c0102fb8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102fbf:	e8 1d 0c 00 00       	call   c0103be1 <alloc_pages>
c0102fc4:	85 c0                	test   %eax,%eax
c0102fc6:	74 24                	je     c0102fec <basic_check+0x2b5>
c0102fc8:	c7 44 24 0c f6 66 10 	movl   $0xc01066f6,0xc(%esp)
c0102fcf:	c0 
c0102fd0:	c7 44 24 08 96 65 10 	movl   $0xc0106596,0x8(%esp)
c0102fd7:	c0 
c0102fd8:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c0102fdf:	00 
c0102fe0:	c7 04 24 ab 65 10 c0 	movl   $0xc01065ab,(%esp)
c0102fe7:	e8 d9 dc ff ff       	call   c0100cc5 <__panic>

    free_page(p0);
c0102fec:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0102ff3:	00 
c0102ff4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102ff7:	89 04 24             	mov    %eax,(%esp)
c0102ffa:	e8 1a 0c 00 00       	call   c0103c19 <free_pages>
    free_page(p1);
c0102fff:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103006:	00 
c0103007:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010300a:	89 04 24             	mov    %eax,(%esp)
c010300d:	e8 07 0c 00 00       	call   c0103c19 <free_pages>
    free_page(p2);
c0103012:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103019:	00 
c010301a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010301d:	89 04 24             	mov    %eax,(%esp)
c0103020:	e8 f4 0b 00 00       	call   c0103c19 <free_pages>
    assert(nr_free == 3);
c0103025:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c010302a:	83 f8 03             	cmp    $0x3,%eax
c010302d:	74 24                	je     c0103053 <basic_check+0x31c>
c010302f:	c7 44 24 0c 0b 67 10 	movl   $0xc010670b,0xc(%esp)
c0103036:	c0 
c0103037:	c7 44 24 08 96 65 10 	movl   $0xc0106596,0x8(%esp)
c010303e:	c0 
c010303f:	c7 44 24 04 c5 00 00 	movl   $0xc5,0x4(%esp)
c0103046:	00 
c0103047:	c7 04 24 ab 65 10 c0 	movl   $0xc01065ab,(%esp)
c010304e:	e8 72 dc ff ff       	call   c0100cc5 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103053:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010305a:	e8 82 0b 00 00       	call   c0103be1 <alloc_pages>
c010305f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103062:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103066:	75 24                	jne    c010308c <basic_check+0x355>
c0103068:	c7 44 24 0c d1 65 10 	movl   $0xc01065d1,0xc(%esp)
c010306f:	c0 
c0103070:	c7 44 24 08 96 65 10 	movl   $0xc0106596,0x8(%esp)
c0103077:	c0 
c0103078:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c010307f:	00 
c0103080:	c7 04 24 ab 65 10 c0 	movl   $0xc01065ab,(%esp)
c0103087:	e8 39 dc ff ff       	call   c0100cc5 <__panic>
    assert((p1 = alloc_page()) != NULL);
c010308c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103093:	e8 49 0b 00 00       	call   c0103be1 <alloc_pages>
c0103098:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010309b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010309f:	75 24                	jne    c01030c5 <basic_check+0x38e>
c01030a1:	c7 44 24 0c ed 65 10 	movl   $0xc01065ed,0xc(%esp)
c01030a8:	c0 
c01030a9:	c7 44 24 08 96 65 10 	movl   $0xc0106596,0x8(%esp)
c01030b0:	c0 
c01030b1:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
c01030b8:	00 
c01030b9:	c7 04 24 ab 65 10 c0 	movl   $0xc01065ab,(%esp)
c01030c0:	e8 00 dc ff ff       	call   c0100cc5 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01030c5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01030cc:	e8 10 0b 00 00       	call   c0103be1 <alloc_pages>
c01030d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01030d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01030d8:	75 24                	jne    c01030fe <basic_check+0x3c7>
c01030da:	c7 44 24 0c 09 66 10 	movl   $0xc0106609,0xc(%esp)
c01030e1:	c0 
c01030e2:	c7 44 24 08 96 65 10 	movl   $0xc0106596,0x8(%esp)
c01030e9:	c0 
c01030ea:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c01030f1:	00 
c01030f2:	c7 04 24 ab 65 10 c0 	movl   $0xc01065ab,(%esp)
c01030f9:	e8 c7 db ff ff       	call   c0100cc5 <__panic>

    assert(alloc_page() == NULL);
c01030fe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103105:	e8 d7 0a 00 00       	call   c0103be1 <alloc_pages>
c010310a:	85 c0                	test   %eax,%eax
c010310c:	74 24                	je     c0103132 <basic_check+0x3fb>
c010310e:	c7 44 24 0c f6 66 10 	movl   $0xc01066f6,0xc(%esp)
c0103115:	c0 
c0103116:	c7 44 24 08 96 65 10 	movl   $0xc0106596,0x8(%esp)
c010311d:	c0 
c010311e:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c0103125:	00 
c0103126:	c7 04 24 ab 65 10 c0 	movl   $0xc01065ab,(%esp)
c010312d:	e8 93 db ff ff       	call   c0100cc5 <__panic>

    free_page(p0);
c0103132:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103139:	00 
c010313a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010313d:	89 04 24             	mov    %eax,(%esp)
c0103140:	e8 d4 0a 00 00       	call   c0103c19 <free_pages>
c0103145:	c7 45 d8 50 89 11 c0 	movl   $0xc0118950,-0x28(%ebp)
c010314c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010314f:	8b 40 04             	mov    0x4(%eax),%eax
c0103152:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103155:	0f 94 c0             	sete   %al
c0103158:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c010315b:	85 c0                	test   %eax,%eax
c010315d:	74 24                	je     c0103183 <basic_check+0x44c>
c010315f:	c7 44 24 0c 18 67 10 	movl   $0xc0106718,0xc(%esp)
c0103166:	c0 
c0103167:	c7 44 24 08 96 65 10 	movl   $0xc0106596,0x8(%esp)
c010316e:	c0 
c010316f:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0103176:	00 
c0103177:	c7 04 24 ab 65 10 c0 	movl   $0xc01065ab,(%esp)
c010317e:	e8 42 db ff ff       	call   c0100cc5 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103183:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010318a:	e8 52 0a 00 00       	call   c0103be1 <alloc_pages>
c010318f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103192:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103195:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103198:	74 24                	je     c01031be <basic_check+0x487>
c010319a:	c7 44 24 0c 30 67 10 	movl   $0xc0106730,0xc(%esp)
c01031a1:	c0 
c01031a2:	c7 44 24 08 96 65 10 	movl   $0xc0106596,0x8(%esp)
c01031a9:	c0 
c01031aa:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c01031b1:	00 
c01031b2:	c7 04 24 ab 65 10 c0 	movl   $0xc01065ab,(%esp)
c01031b9:	e8 07 db ff ff       	call   c0100cc5 <__panic>
    assert(alloc_page() == NULL);
c01031be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01031c5:	e8 17 0a 00 00       	call   c0103be1 <alloc_pages>
c01031ca:	85 c0                	test   %eax,%eax
c01031cc:	74 24                	je     c01031f2 <basic_check+0x4bb>
c01031ce:	c7 44 24 0c f6 66 10 	movl   $0xc01066f6,0xc(%esp)
c01031d5:	c0 
c01031d6:	c7 44 24 08 96 65 10 	movl   $0xc0106596,0x8(%esp)
c01031dd:	c0 
c01031de:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c01031e5:	00 
c01031e6:	c7 04 24 ab 65 10 c0 	movl   $0xc01065ab,(%esp)
c01031ed:	e8 d3 da ff ff       	call   c0100cc5 <__panic>

    assert(nr_free == 0);
c01031f2:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c01031f7:	85 c0                	test   %eax,%eax
c01031f9:	74 24                	je     c010321f <basic_check+0x4e8>
c01031fb:	c7 44 24 0c 49 67 10 	movl   $0xc0106749,0xc(%esp)
c0103202:	c0 
c0103203:	c7 44 24 08 96 65 10 	movl   $0xc0106596,0x8(%esp)
c010320a:	c0 
c010320b:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c0103212:	00 
c0103213:	c7 04 24 ab 65 10 c0 	movl   $0xc01065ab,(%esp)
c010321a:	e8 a6 da ff ff       	call   c0100cc5 <__panic>
    free_list = free_list_store;
c010321f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103222:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103225:	a3 50 89 11 c0       	mov    %eax,0xc0118950
c010322a:	89 15 54 89 11 c0    	mov    %edx,0xc0118954
    nr_free = nr_free_store;
c0103230:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103233:	a3 58 89 11 c0       	mov    %eax,0xc0118958

    free_page(p);
c0103238:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010323f:	00 
c0103240:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103243:	89 04 24             	mov    %eax,(%esp)
c0103246:	e8 ce 09 00 00       	call   c0103c19 <free_pages>
    free_page(p1);
c010324b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103252:	00 
c0103253:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103256:	89 04 24             	mov    %eax,(%esp)
c0103259:	e8 bb 09 00 00       	call   c0103c19 <free_pages>
    free_page(p2);
c010325e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103265:	00 
c0103266:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103269:	89 04 24             	mov    %eax,(%esp)
c010326c:	e8 a8 09 00 00       	call   c0103c19 <free_pages>
}
c0103271:	c9                   	leave  
c0103272:	c3                   	ret    

c0103273 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0103273:	55                   	push   %ebp
c0103274:	89 e5                	mov    %esp,%ebp
c0103276:	53                   	push   %ebx
c0103277:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c010327d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103284:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c010328b:	c7 45 ec 50 89 11 c0 	movl   $0xc0118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103292:	eb 6b                	jmp    c01032ff <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0103294:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103297:	83 e8 0c             	sub    $0xc,%eax
c010329a:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c010329d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01032a0:	83 c0 04             	add    $0x4,%eax
c01032a3:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01032aa:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01032ad:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01032b0:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01032b3:	0f a3 10             	bt     %edx,(%eax)
c01032b6:	19 c0                	sbb    %eax,%eax
c01032b8:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c01032bb:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c01032bf:	0f 95 c0             	setne  %al
c01032c2:	0f b6 c0             	movzbl %al,%eax
c01032c5:	85 c0                	test   %eax,%eax
c01032c7:	75 24                	jne    c01032ed <default_check+0x7a>
c01032c9:	c7 44 24 0c 56 67 10 	movl   $0xc0106756,0xc(%esp)
c01032d0:	c0 
c01032d1:	c7 44 24 08 96 65 10 	movl   $0xc0106596,0x8(%esp)
c01032d8:	c0 
c01032d9:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
c01032e0:	00 
c01032e1:	c7 04 24 ab 65 10 c0 	movl   $0xc01065ab,(%esp)
c01032e8:	e8 d8 d9 ff ff       	call   c0100cc5 <__panic>
        count ++, total += p->property;
c01032ed:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01032f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01032f4:	8b 50 08             	mov    0x8(%eax),%edx
c01032f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01032fa:	01 d0                	add    %edx,%eax
c01032fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01032ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103302:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103305:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103308:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c010330b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010330e:	81 7d ec 50 89 11 c0 	cmpl   $0xc0118950,-0x14(%ebp)
c0103315:	0f 85 79 ff ff ff    	jne    c0103294 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c010331b:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c010331e:	e8 28 09 00 00       	call   c0103c4b <nr_free_pages>
c0103323:	39 c3                	cmp    %eax,%ebx
c0103325:	74 24                	je     c010334b <default_check+0xd8>
c0103327:	c7 44 24 0c 66 67 10 	movl   $0xc0106766,0xc(%esp)
c010332e:	c0 
c010332f:	c7 44 24 08 96 65 10 	movl   $0xc0106596,0x8(%esp)
c0103336:	c0 
c0103337:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
c010333e:	00 
c010333f:	c7 04 24 ab 65 10 c0 	movl   $0xc01065ab,(%esp)
c0103346:	e8 7a d9 ff ff       	call   c0100cc5 <__panic>

    basic_check();
c010334b:	e8 e7 f9 ff ff       	call   c0102d37 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103350:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103357:	e8 85 08 00 00       	call   c0103be1 <alloc_pages>
c010335c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c010335f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103363:	75 24                	jne    c0103389 <default_check+0x116>
c0103365:	c7 44 24 0c 7f 67 10 	movl   $0xc010677f,0xc(%esp)
c010336c:	c0 
c010336d:	c7 44 24 08 96 65 10 	movl   $0xc0106596,0x8(%esp)
c0103374:	c0 
c0103375:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
c010337c:	00 
c010337d:	c7 04 24 ab 65 10 c0 	movl   $0xc01065ab,(%esp)
c0103384:	e8 3c d9 ff ff       	call   c0100cc5 <__panic>
    assert(!PageProperty(p0));
c0103389:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010338c:	83 c0 04             	add    $0x4,%eax
c010338f:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103396:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103399:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010339c:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010339f:	0f a3 10             	bt     %edx,(%eax)
c01033a2:	19 c0                	sbb    %eax,%eax
c01033a4:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c01033a7:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01033ab:	0f 95 c0             	setne  %al
c01033ae:	0f b6 c0             	movzbl %al,%eax
c01033b1:	85 c0                	test   %eax,%eax
c01033b3:	74 24                	je     c01033d9 <default_check+0x166>
c01033b5:	c7 44 24 0c 8a 67 10 	movl   $0xc010678a,0xc(%esp)
c01033bc:	c0 
c01033bd:	c7 44 24 08 96 65 10 	movl   $0xc0106596,0x8(%esp)
c01033c4:	c0 
c01033c5:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c01033cc:	00 
c01033cd:	c7 04 24 ab 65 10 c0 	movl   $0xc01065ab,(%esp)
c01033d4:	e8 ec d8 ff ff       	call   c0100cc5 <__panic>

    list_entry_t free_list_store = free_list;
c01033d9:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c01033de:	8b 15 54 89 11 c0    	mov    0xc0118954,%edx
c01033e4:	89 45 80             	mov    %eax,-0x80(%ebp)
c01033e7:	89 55 84             	mov    %edx,-0x7c(%ebp)
c01033ea:	c7 45 b4 50 89 11 c0 	movl   $0xc0118950,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01033f1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01033f4:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01033f7:	89 50 04             	mov    %edx,0x4(%eax)
c01033fa:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01033fd:	8b 50 04             	mov    0x4(%eax),%edx
c0103400:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103403:	89 10                	mov    %edx,(%eax)
c0103405:	c7 45 b0 50 89 11 c0 	movl   $0xc0118950,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c010340c:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010340f:	8b 40 04             	mov    0x4(%eax),%eax
c0103412:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0103415:	0f 94 c0             	sete   %al
c0103418:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010341b:	85 c0                	test   %eax,%eax
c010341d:	75 24                	jne    c0103443 <default_check+0x1d0>
c010341f:	c7 44 24 0c df 66 10 	movl   $0xc01066df,0xc(%esp)
c0103426:	c0 
c0103427:	c7 44 24 08 96 65 10 	movl   $0xc0106596,0x8(%esp)
c010342e:	c0 
c010342f:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
c0103436:	00 
c0103437:	c7 04 24 ab 65 10 c0 	movl   $0xc01065ab,(%esp)
c010343e:	e8 82 d8 ff ff       	call   c0100cc5 <__panic>
    assert(alloc_page() == NULL);
c0103443:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010344a:	e8 92 07 00 00       	call   c0103be1 <alloc_pages>
c010344f:	85 c0                	test   %eax,%eax
c0103451:	74 24                	je     c0103477 <default_check+0x204>
c0103453:	c7 44 24 0c f6 66 10 	movl   $0xc01066f6,0xc(%esp)
c010345a:	c0 
c010345b:	c7 44 24 08 96 65 10 	movl   $0xc0106596,0x8(%esp)
c0103462:	c0 
c0103463:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
c010346a:	00 
c010346b:	c7 04 24 ab 65 10 c0 	movl   $0xc01065ab,(%esp)
c0103472:	e8 4e d8 ff ff       	call   c0100cc5 <__panic>

    unsigned int nr_free_store = nr_free;
c0103477:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c010347c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c010347f:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c0103486:	00 00 00 

    free_pages(p0 + 2, 3);
c0103489:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010348c:	83 c0 28             	add    $0x28,%eax
c010348f:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103496:	00 
c0103497:	89 04 24             	mov    %eax,(%esp)
c010349a:	e8 7a 07 00 00       	call   c0103c19 <free_pages>
    assert(alloc_pages(4) == NULL);
c010349f:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01034a6:	e8 36 07 00 00       	call   c0103be1 <alloc_pages>
c01034ab:	85 c0                	test   %eax,%eax
c01034ad:	74 24                	je     c01034d3 <default_check+0x260>
c01034af:	c7 44 24 0c 9c 67 10 	movl   $0xc010679c,0xc(%esp)
c01034b6:	c0 
c01034b7:	c7 44 24 08 96 65 10 	movl   $0xc0106596,0x8(%esp)
c01034be:	c0 
c01034bf:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c01034c6:	00 
c01034c7:	c7 04 24 ab 65 10 c0 	movl   $0xc01065ab,(%esp)
c01034ce:	e8 f2 d7 ff ff       	call   c0100cc5 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c01034d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01034d6:	83 c0 28             	add    $0x28,%eax
c01034d9:	83 c0 04             	add    $0x4,%eax
c01034dc:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c01034e3:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01034e6:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01034e9:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01034ec:	0f a3 10             	bt     %edx,(%eax)
c01034ef:	19 c0                	sbb    %eax,%eax
c01034f1:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c01034f4:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c01034f8:	0f 95 c0             	setne  %al
c01034fb:	0f b6 c0             	movzbl %al,%eax
c01034fe:	85 c0                	test   %eax,%eax
c0103500:	74 0e                	je     c0103510 <default_check+0x29d>
c0103502:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103505:	83 c0 28             	add    $0x28,%eax
c0103508:	8b 40 08             	mov    0x8(%eax),%eax
c010350b:	83 f8 03             	cmp    $0x3,%eax
c010350e:	74 24                	je     c0103534 <default_check+0x2c1>
c0103510:	c7 44 24 0c b4 67 10 	movl   $0xc01067b4,0xc(%esp)
c0103517:	c0 
c0103518:	c7 44 24 08 96 65 10 	movl   $0xc0106596,0x8(%esp)
c010351f:	c0 
c0103520:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0103527:	00 
c0103528:	c7 04 24 ab 65 10 c0 	movl   $0xc01065ab,(%esp)
c010352f:	e8 91 d7 ff ff       	call   c0100cc5 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0103534:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c010353b:	e8 a1 06 00 00       	call   c0103be1 <alloc_pages>
c0103540:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103543:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103547:	75 24                	jne    c010356d <default_check+0x2fa>
c0103549:	c7 44 24 0c e0 67 10 	movl   $0xc01067e0,0xc(%esp)
c0103550:	c0 
c0103551:	c7 44 24 08 96 65 10 	movl   $0xc0106596,0x8(%esp)
c0103558:	c0 
c0103559:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0103560:	00 
c0103561:	c7 04 24 ab 65 10 c0 	movl   $0xc01065ab,(%esp)
c0103568:	e8 58 d7 ff ff       	call   c0100cc5 <__panic>
    assert(alloc_page() == NULL);
c010356d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103574:	e8 68 06 00 00       	call   c0103be1 <alloc_pages>
c0103579:	85 c0                	test   %eax,%eax
c010357b:	74 24                	je     c01035a1 <default_check+0x32e>
c010357d:	c7 44 24 0c f6 66 10 	movl   $0xc01066f6,0xc(%esp)
c0103584:	c0 
c0103585:	c7 44 24 08 96 65 10 	movl   $0xc0106596,0x8(%esp)
c010358c:	c0 
c010358d:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c0103594:	00 
c0103595:	c7 04 24 ab 65 10 c0 	movl   $0xc01065ab,(%esp)
c010359c:	e8 24 d7 ff ff       	call   c0100cc5 <__panic>
    assert(p0 + 2 == p1);
c01035a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035a4:	83 c0 28             	add    $0x28,%eax
c01035a7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01035aa:	74 24                	je     c01035d0 <default_check+0x35d>
c01035ac:	c7 44 24 0c fe 67 10 	movl   $0xc01067fe,0xc(%esp)
c01035b3:	c0 
c01035b4:	c7 44 24 08 96 65 10 	movl   $0xc0106596,0x8(%esp)
c01035bb:	c0 
c01035bc:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c01035c3:	00 
c01035c4:	c7 04 24 ab 65 10 c0 	movl   $0xc01065ab,(%esp)
c01035cb:	e8 f5 d6 ff ff       	call   c0100cc5 <__panic>

    p2 = p0 + 1;
c01035d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035d3:	83 c0 14             	add    $0x14,%eax
c01035d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c01035d9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01035e0:	00 
c01035e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035e4:	89 04 24             	mov    %eax,(%esp)
c01035e7:	e8 2d 06 00 00       	call   c0103c19 <free_pages>
    free_pages(p1, 3);
c01035ec:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01035f3:	00 
c01035f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01035f7:	89 04 24             	mov    %eax,(%esp)
c01035fa:	e8 1a 06 00 00       	call   c0103c19 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c01035ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103602:	83 c0 04             	add    $0x4,%eax
c0103605:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c010360c:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010360f:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103612:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0103615:	0f a3 10             	bt     %edx,(%eax)
c0103618:	19 c0                	sbb    %eax,%eax
c010361a:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c010361d:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0103621:	0f 95 c0             	setne  %al
c0103624:	0f b6 c0             	movzbl %al,%eax
c0103627:	85 c0                	test   %eax,%eax
c0103629:	74 0b                	je     c0103636 <default_check+0x3c3>
c010362b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010362e:	8b 40 08             	mov    0x8(%eax),%eax
c0103631:	83 f8 01             	cmp    $0x1,%eax
c0103634:	74 24                	je     c010365a <default_check+0x3e7>
c0103636:	c7 44 24 0c 0c 68 10 	movl   $0xc010680c,0xc(%esp)
c010363d:	c0 
c010363e:	c7 44 24 08 96 65 10 	movl   $0xc0106596,0x8(%esp)
c0103645:	c0 
c0103646:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c010364d:	00 
c010364e:	c7 04 24 ab 65 10 c0 	movl   $0xc01065ab,(%esp)
c0103655:	e8 6b d6 ff ff       	call   c0100cc5 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c010365a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010365d:	83 c0 04             	add    $0x4,%eax
c0103660:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0103667:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010366a:	8b 45 90             	mov    -0x70(%ebp),%eax
c010366d:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0103670:	0f a3 10             	bt     %edx,(%eax)
c0103673:	19 c0                	sbb    %eax,%eax
c0103675:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0103678:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c010367c:	0f 95 c0             	setne  %al
c010367f:	0f b6 c0             	movzbl %al,%eax
c0103682:	85 c0                	test   %eax,%eax
c0103684:	74 0b                	je     c0103691 <default_check+0x41e>
c0103686:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103689:	8b 40 08             	mov    0x8(%eax),%eax
c010368c:	83 f8 03             	cmp    $0x3,%eax
c010368f:	74 24                	je     c01036b5 <default_check+0x442>
c0103691:	c7 44 24 0c 34 68 10 	movl   $0xc0106834,0xc(%esp)
c0103698:	c0 
c0103699:	c7 44 24 08 96 65 10 	movl   $0xc0106596,0x8(%esp)
c01036a0:	c0 
c01036a1:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
c01036a8:	00 
c01036a9:	c7 04 24 ab 65 10 c0 	movl   $0xc01065ab,(%esp)
c01036b0:	e8 10 d6 ff ff       	call   c0100cc5 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01036b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01036bc:	e8 20 05 00 00       	call   c0103be1 <alloc_pages>
c01036c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01036c4:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01036c7:	83 e8 14             	sub    $0x14,%eax
c01036ca:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01036cd:	74 24                	je     c01036f3 <default_check+0x480>
c01036cf:	c7 44 24 0c 5a 68 10 	movl   $0xc010685a,0xc(%esp)
c01036d6:	c0 
c01036d7:	c7 44 24 08 96 65 10 	movl   $0xc0106596,0x8(%esp)
c01036de:	c0 
c01036df:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
c01036e6:	00 
c01036e7:	c7 04 24 ab 65 10 c0 	movl   $0xc01065ab,(%esp)
c01036ee:	e8 d2 d5 ff ff       	call   c0100cc5 <__panic>
    free_page(p0);
c01036f3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01036fa:	00 
c01036fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036fe:	89 04 24             	mov    %eax,(%esp)
c0103701:	e8 13 05 00 00       	call   c0103c19 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0103706:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c010370d:	e8 cf 04 00 00       	call   c0103be1 <alloc_pages>
c0103712:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103715:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103718:	83 c0 14             	add    $0x14,%eax
c010371b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c010371e:	74 24                	je     c0103744 <default_check+0x4d1>
c0103720:	c7 44 24 0c 78 68 10 	movl   $0xc0106878,0xc(%esp)
c0103727:	c0 
c0103728:	c7 44 24 08 96 65 10 	movl   $0xc0106596,0x8(%esp)
c010372f:	c0 
c0103730:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
c0103737:	00 
c0103738:	c7 04 24 ab 65 10 c0 	movl   $0xc01065ab,(%esp)
c010373f:	e8 81 d5 ff ff       	call   c0100cc5 <__panic>

    free_pages(p0, 2);
c0103744:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c010374b:	00 
c010374c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010374f:	89 04 24             	mov    %eax,(%esp)
c0103752:	e8 c2 04 00 00       	call   c0103c19 <free_pages>
    free_page(p2);
c0103757:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010375e:	00 
c010375f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103762:	89 04 24             	mov    %eax,(%esp)
c0103765:	e8 af 04 00 00       	call   c0103c19 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c010376a:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103771:	e8 6b 04 00 00       	call   c0103be1 <alloc_pages>
c0103776:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103779:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010377d:	75 24                	jne    c01037a3 <default_check+0x530>
c010377f:	c7 44 24 0c 98 68 10 	movl   $0xc0106898,0xc(%esp)
c0103786:	c0 
c0103787:	c7 44 24 08 96 65 10 	movl   $0xc0106596,0x8(%esp)
c010378e:	c0 
c010378f:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c0103796:	00 
c0103797:	c7 04 24 ab 65 10 c0 	movl   $0xc01065ab,(%esp)
c010379e:	e8 22 d5 ff ff       	call   c0100cc5 <__panic>
    assert(alloc_page() == NULL);
c01037a3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01037aa:	e8 32 04 00 00       	call   c0103be1 <alloc_pages>
c01037af:	85 c0                	test   %eax,%eax
c01037b1:	74 24                	je     c01037d7 <default_check+0x564>
c01037b3:	c7 44 24 0c f6 66 10 	movl   $0xc01066f6,0xc(%esp)
c01037ba:	c0 
c01037bb:	c7 44 24 08 96 65 10 	movl   $0xc0106596,0x8(%esp)
c01037c2:	c0 
c01037c3:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
c01037ca:	00 
c01037cb:	c7 04 24 ab 65 10 c0 	movl   $0xc01065ab,(%esp)
c01037d2:	e8 ee d4 ff ff       	call   c0100cc5 <__panic>

    assert(nr_free == 0);
c01037d7:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c01037dc:	85 c0                	test   %eax,%eax
c01037de:	74 24                	je     c0103804 <default_check+0x591>
c01037e0:	c7 44 24 0c 49 67 10 	movl   $0xc0106749,0xc(%esp)
c01037e7:	c0 
c01037e8:	c7 44 24 08 96 65 10 	movl   $0xc0106596,0x8(%esp)
c01037ef:	c0 
c01037f0:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
c01037f7:	00 
c01037f8:	c7 04 24 ab 65 10 c0 	movl   $0xc01065ab,(%esp)
c01037ff:	e8 c1 d4 ff ff       	call   c0100cc5 <__panic>
    nr_free = nr_free_store;
c0103804:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103807:	a3 58 89 11 c0       	mov    %eax,0xc0118958

    free_list = free_list_store;
c010380c:	8b 45 80             	mov    -0x80(%ebp),%eax
c010380f:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103812:	a3 50 89 11 c0       	mov    %eax,0xc0118950
c0103817:	89 15 54 89 11 c0    	mov    %edx,0xc0118954
    free_pages(p0, 5);
c010381d:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0103824:	00 
c0103825:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103828:	89 04 24             	mov    %eax,(%esp)
c010382b:	e8 e9 03 00 00       	call   c0103c19 <free_pages>

    le = &free_list;
c0103830:	c7 45 ec 50 89 11 c0 	movl   $0xc0118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103837:	eb 1d                	jmp    c0103856 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c0103839:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010383c:	83 e8 0c             	sub    $0xc,%eax
c010383f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c0103842:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0103846:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103849:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010384c:	8b 40 08             	mov    0x8(%eax),%eax
c010384f:	29 c2                	sub    %eax,%edx
c0103851:	89 d0                	mov    %edx,%eax
c0103853:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103856:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103859:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010385c:	8b 45 88             	mov    -0x78(%ebp),%eax
c010385f:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103862:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103865:	81 7d ec 50 89 11 c0 	cmpl   $0xc0118950,-0x14(%ebp)
c010386c:	75 cb                	jne    c0103839 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c010386e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103872:	74 24                	je     c0103898 <default_check+0x625>
c0103874:	c7 44 24 0c b6 68 10 	movl   $0xc01068b6,0xc(%esp)
c010387b:	c0 
c010387c:	c7 44 24 08 96 65 10 	movl   $0xc0106596,0x8(%esp)
c0103883:	c0 
c0103884:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
c010388b:	00 
c010388c:	c7 04 24 ab 65 10 c0 	movl   $0xc01065ab,(%esp)
c0103893:	e8 2d d4 ff ff       	call   c0100cc5 <__panic>
    assert(total == 0);
c0103898:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010389c:	74 24                	je     c01038c2 <default_check+0x64f>
c010389e:	c7 44 24 0c c1 68 10 	movl   $0xc01068c1,0xc(%esp)
c01038a5:	c0 
c01038a6:	c7 44 24 08 96 65 10 	movl   $0xc0106596,0x8(%esp)
c01038ad:	c0 
c01038ae:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
c01038b5:	00 
c01038b6:	c7 04 24 ab 65 10 c0 	movl   $0xc01065ab,(%esp)
c01038bd:	e8 03 d4 ff ff       	call   c0100cc5 <__panic>
}
c01038c2:	81 c4 94 00 00 00    	add    $0x94,%esp
c01038c8:	5b                   	pop    %ebx
c01038c9:	5d                   	pop    %ebp
c01038ca:	c3                   	ret    

c01038cb <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01038cb:	55                   	push   %ebp
c01038cc:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01038ce:	8b 55 08             	mov    0x8(%ebp),%edx
c01038d1:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c01038d6:	29 c2                	sub    %eax,%edx
c01038d8:	89 d0                	mov    %edx,%eax
c01038da:	c1 f8 02             	sar    $0x2,%eax
c01038dd:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01038e3:	5d                   	pop    %ebp
c01038e4:	c3                   	ret    

c01038e5 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01038e5:	55                   	push   %ebp
c01038e6:	89 e5                	mov    %esp,%ebp
c01038e8:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01038eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01038ee:	89 04 24             	mov    %eax,(%esp)
c01038f1:	e8 d5 ff ff ff       	call   c01038cb <page2ppn>
c01038f6:	c1 e0 0c             	shl    $0xc,%eax
}
c01038f9:	c9                   	leave  
c01038fa:	c3                   	ret    

c01038fb <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c01038fb:	55                   	push   %ebp
c01038fc:	89 e5                	mov    %esp,%ebp
c01038fe:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0103901:	8b 45 08             	mov    0x8(%ebp),%eax
c0103904:	c1 e8 0c             	shr    $0xc,%eax
c0103907:	89 c2                	mov    %eax,%edx
c0103909:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c010390e:	39 c2                	cmp    %eax,%edx
c0103910:	72 1c                	jb     c010392e <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0103912:	c7 44 24 08 fc 68 10 	movl   $0xc01068fc,0x8(%esp)
c0103919:	c0 
c010391a:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0103921:	00 
c0103922:	c7 04 24 1b 69 10 c0 	movl   $0xc010691b,(%esp)
c0103929:	e8 97 d3 ff ff       	call   c0100cc5 <__panic>
    }
    return &pages[PPN(pa)];
c010392e:	8b 0d 64 89 11 c0    	mov    0xc0118964,%ecx
c0103934:	8b 45 08             	mov    0x8(%ebp),%eax
c0103937:	c1 e8 0c             	shr    $0xc,%eax
c010393a:	89 c2                	mov    %eax,%edx
c010393c:	89 d0                	mov    %edx,%eax
c010393e:	c1 e0 02             	shl    $0x2,%eax
c0103941:	01 d0                	add    %edx,%eax
c0103943:	c1 e0 02             	shl    $0x2,%eax
c0103946:	01 c8                	add    %ecx,%eax
}
c0103948:	c9                   	leave  
c0103949:	c3                   	ret    

c010394a <page2kva>:

static inline void *
page2kva(struct Page *page) {
c010394a:	55                   	push   %ebp
c010394b:	89 e5                	mov    %esp,%ebp
c010394d:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0103950:	8b 45 08             	mov    0x8(%ebp),%eax
c0103953:	89 04 24             	mov    %eax,(%esp)
c0103956:	e8 8a ff ff ff       	call   c01038e5 <page2pa>
c010395b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010395e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103961:	c1 e8 0c             	shr    $0xc,%eax
c0103964:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103967:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c010396c:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010396f:	72 23                	jb     c0103994 <page2kva+0x4a>
c0103971:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103974:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103978:	c7 44 24 08 2c 69 10 	movl   $0xc010692c,0x8(%esp)
c010397f:	c0 
c0103980:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103987:	00 
c0103988:	c7 04 24 1b 69 10 c0 	movl   $0xc010691b,(%esp)
c010398f:	e8 31 d3 ff ff       	call   c0100cc5 <__panic>
c0103994:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103997:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c010399c:	c9                   	leave  
c010399d:	c3                   	ret    

c010399e <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c010399e:	55                   	push   %ebp
c010399f:	89 e5                	mov    %esp,%ebp
c01039a1:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c01039a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01039a7:	83 e0 01             	and    $0x1,%eax
c01039aa:	85 c0                	test   %eax,%eax
c01039ac:	75 1c                	jne    c01039ca <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c01039ae:	c7 44 24 08 50 69 10 	movl   $0xc0106950,0x8(%esp)
c01039b5:	c0 
c01039b6:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c01039bd:	00 
c01039be:	c7 04 24 1b 69 10 c0 	movl   $0xc010691b,(%esp)
c01039c5:	e8 fb d2 ff ff       	call   c0100cc5 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c01039ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01039cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01039d2:	89 04 24             	mov    %eax,(%esp)
c01039d5:	e8 21 ff ff ff       	call   c01038fb <pa2page>
}
c01039da:	c9                   	leave  
c01039db:	c3                   	ret    

c01039dc <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c01039dc:	55                   	push   %ebp
c01039dd:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01039df:	8b 45 08             	mov    0x8(%ebp),%eax
c01039e2:	8b 00                	mov    (%eax),%eax
}
c01039e4:	5d                   	pop    %ebp
c01039e5:	c3                   	ret    

c01039e6 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c01039e6:	55                   	push   %ebp
c01039e7:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01039e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01039ec:	8b 55 0c             	mov    0xc(%ebp),%edx
c01039ef:	89 10                	mov    %edx,(%eax)
}
c01039f1:	5d                   	pop    %ebp
c01039f2:	c3                   	ret    

c01039f3 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c01039f3:	55                   	push   %ebp
c01039f4:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c01039f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01039f9:	8b 00                	mov    (%eax),%eax
c01039fb:	8d 50 01             	lea    0x1(%eax),%edx
c01039fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a01:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103a03:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a06:	8b 00                	mov    (%eax),%eax
}
c0103a08:	5d                   	pop    %ebp
c0103a09:	c3                   	ret    

c0103a0a <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103a0a:	55                   	push   %ebp
c0103a0b:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103a0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a10:	8b 00                	mov    (%eax),%eax
c0103a12:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103a15:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a18:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103a1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a1d:	8b 00                	mov    (%eax),%eax
}
c0103a1f:	5d                   	pop    %ebp
c0103a20:	c3                   	ret    

c0103a21 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0103a21:	55                   	push   %ebp
c0103a22:	89 e5                	mov    %esp,%ebp
c0103a24:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103a27:	9c                   	pushf  
c0103a28:	58                   	pop    %eax
c0103a29:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103a2f:	25 00 02 00 00       	and    $0x200,%eax
c0103a34:	85 c0                	test   %eax,%eax
c0103a36:	74 0c                	je     c0103a44 <__intr_save+0x23>
        intr_disable();
c0103a38:	e8 6b dc ff ff       	call   c01016a8 <intr_disable>
        return 1;
c0103a3d:	b8 01 00 00 00       	mov    $0x1,%eax
c0103a42:	eb 05                	jmp    c0103a49 <__intr_save+0x28>
    }
    return 0;
c0103a44:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103a49:	c9                   	leave  
c0103a4a:	c3                   	ret    

c0103a4b <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0103a4b:	55                   	push   %ebp
c0103a4c:	89 e5                	mov    %esp,%ebp
c0103a4e:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103a51:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103a55:	74 05                	je     c0103a5c <__intr_restore+0x11>
        intr_enable();
c0103a57:	e8 46 dc ff ff       	call   c01016a2 <intr_enable>
    }
}
c0103a5c:	c9                   	leave  
c0103a5d:	c3                   	ret    

c0103a5e <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103a5e:	55                   	push   %ebp
c0103a5f:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103a61:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a64:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103a67:	b8 23 00 00 00       	mov    $0x23,%eax
c0103a6c:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103a6e:	b8 23 00 00 00       	mov    $0x23,%eax
c0103a73:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103a75:	b8 10 00 00 00       	mov    $0x10,%eax
c0103a7a:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103a7c:	b8 10 00 00 00       	mov    $0x10,%eax
c0103a81:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103a83:	b8 10 00 00 00       	mov    $0x10,%eax
c0103a88:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103a8a:	ea 91 3a 10 c0 08 00 	ljmp   $0x8,$0xc0103a91
}
c0103a91:	5d                   	pop    %ebp
c0103a92:	c3                   	ret    

c0103a93 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103a93:	55                   	push   %ebp
c0103a94:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103a96:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a99:	a3 e4 88 11 c0       	mov    %eax,0xc01188e4
}
c0103a9e:	5d                   	pop    %ebp
c0103a9f:	c3                   	ret    

c0103aa0 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103aa0:	55                   	push   %ebp
c0103aa1:	89 e5                	mov    %esp,%ebp
c0103aa3:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103aa6:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0103aab:	89 04 24             	mov    %eax,(%esp)
c0103aae:	e8 e0 ff ff ff       	call   c0103a93 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103ab3:	66 c7 05 e8 88 11 c0 	movw   $0x10,0xc01188e8
c0103aba:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103abc:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0103ac3:	68 00 
c0103ac5:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103aca:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0103ad0:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103ad5:	c1 e8 10             	shr    $0x10,%eax
c0103ad8:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0103add:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103ae4:	83 e0 f0             	and    $0xfffffff0,%eax
c0103ae7:	83 c8 09             	or     $0x9,%eax
c0103aea:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103aef:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103af6:	83 e0 ef             	and    $0xffffffef,%eax
c0103af9:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103afe:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103b05:	83 e0 9f             	and    $0xffffff9f,%eax
c0103b08:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103b0d:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103b14:	83 c8 80             	or     $0xffffff80,%eax
c0103b17:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103b1c:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103b23:	83 e0 f0             	and    $0xfffffff0,%eax
c0103b26:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103b2b:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103b32:	83 e0 ef             	and    $0xffffffef,%eax
c0103b35:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103b3a:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103b41:	83 e0 df             	and    $0xffffffdf,%eax
c0103b44:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103b49:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103b50:	83 c8 40             	or     $0x40,%eax
c0103b53:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103b58:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103b5f:	83 e0 7f             	and    $0x7f,%eax
c0103b62:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103b67:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103b6c:	c1 e8 18             	shr    $0x18,%eax
c0103b6f:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103b74:	c7 04 24 30 7a 11 c0 	movl   $0xc0117a30,(%esp)
c0103b7b:	e8 de fe ff ff       	call   c0103a5e <lgdt>
c0103b80:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103b86:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103b8a:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0103b8d:	c9                   	leave  
c0103b8e:	c3                   	ret    

c0103b8f <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103b8f:	55                   	push   %ebp
c0103b90:	89 e5                	mov    %esp,%ebp
c0103b92:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103b95:	c7 05 5c 89 11 c0 e0 	movl   $0xc01068e0,0xc011895c
c0103b9c:	68 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103b9f:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103ba4:	8b 00                	mov    (%eax),%eax
c0103ba6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103baa:	c7 04 24 7c 69 10 c0 	movl   $0xc010697c,(%esp)
c0103bb1:	e8 86 c7 ff ff       	call   c010033c <cprintf>
    pmm_manager->init();
c0103bb6:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103bbb:	8b 40 04             	mov    0x4(%eax),%eax
c0103bbe:	ff d0                	call   *%eax
}
c0103bc0:	c9                   	leave  
c0103bc1:	c3                   	ret    

c0103bc2 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103bc2:	55                   	push   %ebp
c0103bc3:	89 e5                	mov    %esp,%ebp
c0103bc5:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103bc8:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103bcd:	8b 40 08             	mov    0x8(%eax),%eax
c0103bd0:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103bd3:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103bd7:	8b 55 08             	mov    0x8(%ebp),%edx
c0103bda:	89 14 24             	mov    %edx,(%esp)
c0103bdd:	ff d0                	call   *%eax
}
c0103bdf:	c9                   	leave  
c0103be0:	c3                   	ret    

c0103be1 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103be1:	55                   	push   %ebp
c0103be2:	89 e5                	mov    %esp,%ebp
c0103be4:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103be7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103bee:	e8 2e fe ff ff       	call   c0103a21 <__intr_save>
c0103bf3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103bf6:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103bfb:	8b 40 0c             	mov    0xc(%eax),%eax
c0103bfe:	8b 55 08             	mov    0x8(%ebp),%edx
c0103c01:	89 14 24             	mov    %edx,(%esp)
c0103c04:	ff d0                	call   *%eax
c0103c06:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103c09:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c0c:	89 04 24             	mov    %eax,(%esp)
c0103c0f:	e8 37 fe ff ff       	call   c0103a4b <__intr_restore>
    return page;
c0103c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103c17:	c9                   	leave  
c0103c18:	c3                   	ret    

c0103c19 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103c19:	55                   	push   %ebp
c0103c1a:	89 e5                	mov    %esp,%ebp
c0103c1c:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103c1f:	e8 fd fd ff ff       	call   c0103a21 <__intr_save>
c0103c24:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103c27:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103c2c:	8b 40 10             	mov    0x10(%eax),%eax
c0103c2f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103c32:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103c36:	8b 55 08             	mov    0x8(%ebp),%edx
c0103c39:	89 14 24             	mov    %edx,(%esp)
c0103c3c:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0103c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c41:	89 04 24             	mov    %eax,(%esp)
c0103c44:	e8 02 fe ff ff       	call   c0103a4b <__intr_restore>
}
c0103c49:	c9                   	leave  
c0103c4a:	c3                   	ret    

c0103c4b <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103c4b:	55                   	push   %ebp
c0103c4c:	89 e5                	mov    %esp,%ebp
c0103c4e:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103c51:	e8 cb fd ff ff       	call   c0103a21 <__intr_save>
c0103c56:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103c59:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103c5e:	8b 40 14             	mov    0x14(%eax),%eax
c0103c61:	ff d0                	call   *%eax
c0103c63:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c69:	89 04 24             	mov    %eax,(%esp)
c0103c6c:	e8 da fd ff ff       	call   c0103a4b <__intr_restore>
    return ret;
c0103c71:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103c74:	c9                   	leave  
c0103c75:	c3                   	ret    

c0103c76 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103c76:	55                   	push   %ebp
c0103c77:	89 e5                	mov    %esp,%ebp
c0103c79:	57                   	push   %edi
c0103c7a:	56                   	push   %esi
c0103c7b:	53                   	push   %ebx
c0103c7c:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103c82:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0103c89:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103c90:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103c97:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c0103c9e:	e8 99 c6 ff ff       	call   c010033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103ca3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103caa:	e9 15 01 00 00       	jmp    c0103dc4 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103caf:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103cb2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103cb5:	89 d0                	mov    %edx,%eax
c0103cb7:	c1 e0 02             	shl    $0x2,%eax
c0103cba:	01 d0                	add    %edx,%eax
c0103cbc:	c1 e0 02             	shl    $0x2,%eax
c0103cbf:	01 c8                	add    %ecx,%eax
c0103cc1:	8b 50 08             	mov    0x8(%eax),%edx
c0103cc4:	8b 40 04             	mov    0x4(%eax),%eax
c0103cc7:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103cca:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0103ccd:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103cd0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103cd3:	89 d0                	mov    %edx,%eax
c0103cd5:	c1 e0 02             	shl    $0x2,%eax
c0103cd8:	01 d0                	add    %edx,%eax
c0103cda:	c1 e0 02             	shl    $0x2,%eax
c0103cdd:	01 c8                	add    %ecx,%eax
c0103cdf:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103ce2:	8b 58 10             	mov    0x10(%eax),%ebx
c0103ce5:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103ce8:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103ceb:	01 c8                	add    %ecx,%eax
c0103ced:	11 da                	adc    %ebx,%edx
c0103cef:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0103cf2:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0103cf5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103cf8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103cfb:	89 d0                	mov    %edx,%eax
c0103cfd:	c1 e0 02             	shl    $0x2,%eax
c0103d00:	01 d0                	add    %edx,%eax
c0103d02:	c1 e0 02             	shl    $0x2,%eax
c0103d05:	01 c8                	add    %ecx,%eax
c0103d07:	83 c0 14             	add    $0x14,%eax
c0103d0a:	8b 00                	mov    (%eax),%eax
c0103d0c:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0103d12:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103d15:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103d18:	83 c0 ff             	add    $0xffffffff,%eax
c0103d1b:	83 d2 ff             	adc    $0xffffffff,%edx
c0103d1e:	89 c6                	mov    %eax,%esi
c0103d20:	89 d7                	mov    %edx,%edi
c0103d22:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103d25:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103d28:	89 d0                	mov    %edx,%eax
c0103d2a:	c1 e0 02             	shl    $0x2,%eax
c0103d2d:	01 d0                	add    %edx,%eax
c0103d2f:	c1 e0 02             	shl    $0x2,%eax
c0103d32:	01 c8                	add    %ecx,%eax
c0103d34:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103d37:	8b 58 10             	mov    0x10(%eax),%ebx
c0103d3a:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0103d40:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0103d44:	89 74 24 14          	mov    %esi,0x14(%esp)
c0103d48:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0103d4c:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103d4f:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103d52:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103d56:	89 54 24 10          	mov    %edx,0x10(%esp)
c0103d5a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103d5e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0103d62:	c7 04 24 a0 69 10 c0 	movl   $0xc01069a0,(%esp)
c0103d69:	e8 ce c5 ff ff       	call   c010033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0103d6e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103d71:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103d74:	89 d0                	mov    %edx,%eax
c0103d76:	c1 e0 02             	shl    $0x2,%eax
c0103d79:	01 d0                	add    %edx,%eax
c0103d7b:	c1 e0 02             	shl    $0x2,%eax
c0103d7e:	01 c8                	add    %ecx,%eax
c0103d80:	83 c0 14             	add    $0x14,%eax
c0103d83:	8b 00                	mov    (%eax),%eax
c0103d85:	83 f8 01             	cmp    $0x1,%eax
c0103d88:	75 36                	jne    c0103dc0 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0103d8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103d8d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103d90:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103d93:	77 2b                	ja     c0103dc0 <page_init+0x14a>
c0103d95:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103d98:	72 05                	jb     c0103d9f <page_init+0x129>
c0103d9a:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0103d9d:	73 21                	jae    c0103dc0 <page_init+0x14a>
c0103d9f:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103da3:	77 1b                	ja     c0103dc0 <page_init+0x14a>
c0103da5:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103da9:	72 09                	jb     c0103db4 <page_init+0x13e>
c0103dab:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0103db2:	77 0c                	ja     c0103dc0 <page_init+0x14a>
                maxpa = end;
c0103db4:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103db7:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103dba:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103dbd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103dc0:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103dc4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103dc7:	8b 00                	mov    (%eax),%eax
c0103dc9:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103dcc:	0f 8f dd fe ff ff    	jg     c0103caf <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0103dd2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103dd6:	72 1d                	jb     c0103df5 <page_init+0x17f>
c0103dd8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103ddc:	77 09                	ja     c0103de7 <page_init+0x171>
c0103dde:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0103de5:	76 0e                	jbe    c0103df5 <page_init+0x17f>
        maxpa = KMEMSIZE;
c0103de7:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0103dee:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0103df5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103df8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103dfb:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103dff:	c1 ea 0c             	shr    $0xc,%edx
c0103e02:	a3 c0 88 11 c0       	mov    %eax,0xc01188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0103e07:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0103e0e:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c0103e13:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103e16:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103e19:	01 d0                	add    %edx,%eax
c0103e1b:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0103e1e:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103e21:	ba 00 00 00 00       	mov    $0x0,%edx
c0103e26:	f7 75 ac             	divl   -0x54(%ebp)
c0103e29:	89 d0                	mov    %edx,%eax
c0103e2b:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0103e2e:	29 c2                	sub    %eax,%edx
c0103e30:	89 d0                	mov    %edx,%eax
c0103e32:	a3 64 89 11 c0       	mov    %eax,0xc0118964

    for (i = 0; i < npage; i ++) {
c0103e37:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103e3e:	eb 2f                	jmp    c0103e6f <page_init+0x1f9>
        SetPageReserved(pages + i);
c0103e40:	8b 0d 64 89 11 c0    	mov    0xc0118964,%ecx
c0103e46:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e49:	89 d0                	mov    %edx,%eax
c0103e4b:	c1 e0 02             	shl    $0x2,%eax
c0103e4e:	01 d0                	add    %edx,%eax
c0103e50:	c1 e0 02             	shl    $0x2,%eax
c0103e53:	01 c8                	add    %ecx,%eax
c0103e55:	83 c0 04             	add    $0x4,%eax
c0103e58:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0103e5f:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103e62:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0103e65:	8b 55 90             	mov    -0x70(%ebp),%edx
c0103e68:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0103e6b:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103e6f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e72:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103e77:	39 c2                	cmp    %eax,%edx
c0103e79:	72 c5                	jb     c0103e40 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0103e7b:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0103e81:	89 d0                	mov    %edx,%eax
c0103e83:	c1 e0 02             	shl    $0x2,%eax
c0103e86:	01 d0                	add    %edx,%eax
c0103e88:	c1 e0 02             	shl    $0x2,%eax
c0103e8b:	89 c2                	mov    %eax,%edx
c0103e8d:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0103e92:	01 d0                	add    %edx,%eax
c0103e94:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0103e97:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0103e9e:	77 23                	ja     c0103ec3 <page_init+0x24d>
c0103ea0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103ea3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103ea7:	c7 44 24 08 d0 69 10 	movl   $0xc01069d0,0x8(%esp)
c0103eae:	c0 
c0103eaf:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0103eb6:	00 
c0103eb7:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c0103ebe:	e8 02 ce ff ff       	call   c0100cc5 <__panic>
c0103ec3:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103ec6:	05 00 00 00 40       	add    $0x40000000,%eax
c0103ecb:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0103ece:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103ed5:	e9 74 01 00 00       	jmp    c010404e <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103eda:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103edd:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103ee0:	89 d0                	mov    %edx,%eax
c0103ee2:	c1 e0 02             	shl    $0x2,%eax
c0103ee5:	01 d0                	add    %edx,%eax
c0103ee7:	c1 e0 02             	shl    $0x2,%eax
c0103eea:	01 c8                	add    %ecx,%eax
c0103eec:	8b 50 08             	mov    0x8(%eax),%edx
c0103eef:	8b 40 04             	mov    0x4(%eax),%eax
c0103ef2:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103ef5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103ef8:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103efb:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103efe:	89 d0                	mov    %edx,%eax
c0103f00:	c1 e0 02             	shl    $0x2,%eax
c0103f03:	01 d0                	add    %edx,%eax
c0103f05:	c1 e0 02             	shl    $0x2,%eax
c0103f08:	01 c8                	add    %ecx,%eax
c0103f0a:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103f0d:	8b 58 10             	mov    0x10(%eax),%ebx
c0103f10:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103f13:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103f16:	01 c8                	add    %ecx,%eax
c0103f18:	11 da                	adc    %ebx,%edx
c0103f1a:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0103f1d:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0103f20:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103f23:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f26:	89 d0                	mov    %edx,%eax
c0103f28:	c1 e0 02             	shl    $0x2,%eax
c0103f2b:	01 d0                	add    %edx,%eax
c0103f2d:	c1 e0 02             	shl    $0x2,%eax
c0103f30:	01 c8                	add    %ecx,%eax
c0103f32:	83 c0 14             	add    $0x14,%eax
c0103f35:	8b 00                	mov    (%eax),%eax
c0103f37:	83 f8 01             	cmp    $0x1,%eax
c0103f3a:	0f 85 0a 01 00 00    	jne    c010404a <page_init+0x3d4>
            if (begin < freemem) {
c0103f40:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103f43:	ba 00 00 00 00       	mov    $0x0,%edx
c0103f48:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0103f4b:	72 17                	jb     c0103f64 <page_init+0x2ee>
c0103f4d:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0103f50:	77 05                	ja     c0103f57 <page_init+0x2e1>
c0103f52:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0103f55:	76 0d                	jbe    c0103f64 <page_init+0x2ee>
                begin = freemem;
c0103f57:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103f5a:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103f5d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0103f64:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0103f68:	72 1d                	jb     c0103f87 <page_init+0x311>
c0103f6a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0103f6e:	77 09                	ja     c0103f79 <page_init+0x303>
c0103f70:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0103f77:	76 0e                	jbe    c0103f87 <page_init+0x311>
                end = KMEMSIZE;
c0103f79:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0103f80:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0103f87:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103f8a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103f8d:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0103f90:	0f 87 b4 00 00 00    	ja     c010404a <page_init+0x3d4>
c0103f96:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0103f99:	72 09                	jb     c0103fa4 <page_init+0x32e>
c0103f9b:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0103f9e:	0f 83 a6 00 00 00    	jae    c010404a <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
c0103fa4:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0103fab:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103fae:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103fb1:	01 d0                	add    %edx,%eax
c0103fb3:	83 e8 01             	sub    $0x1,%eax
c0103fb6:	89 45 98             	mov    %eax,-0x68(%ebp)
c0103fb9:	8b 45 98             	mov    -0x68(%ebp),%eax
c0103fbc:	ba 00 00 00 00       	mov    $0x0,%edx
c0103fc1:	f7 75 9c             	divl   -0x64(%ebp)
c0103fc4:	89 d0                	mov    %edx,%eax
c0103fc6:	8b 55 98             	mov    -0x68(%ebp),%edx
c0103fc9:	29 c2                	sub    %eax,%edx
c0103fcb:	89 d0                	mov    %edx,%eax
c0103fcd:	ba 00 00 00 00       	mov    $0x0,%edx
c0103fd2:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103fd5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0103fd8:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103fdb:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0103fde:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0103fe1:	ba 00 00 00 00       	mov    $0x0,%edx
c0103fe6:	89 c7                	mov    %eax,%edi
c0103fe8:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c0103fee:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0103ff1:	89 d0                	mov    %edx,%eax
c0103ff3:	83 e0 00             	and    $0x0,%eax
c0103ff6:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0103ff9:	8b 45 80             	mov    -0x80(%ebp),%eax
c0103ffc:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103fff:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104002:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0104005:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104008:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010400b:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010400e:	77 3a                	ja     c010404a <page_init+0x3d4>
c0104010:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104013:	72 05                	jb     c010401a <page_init+0x3a4>
c0104015:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104018:	73 30                	jae    c010404a <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c010401a:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c010401d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c0104020:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104023:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104026:	29 c8                	sub    %ecx,%eax
c0104028:	19 da                	sbb    %ebx,%edx
c010402a:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010402e:	c1 ea 0c             	shr    $0xc,%edx
c0104031:	89 c3                	mov    %eax,%ebx
c0104033:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104036:	89 04 24             	mov    %eax,(%esp)
c0104039:	e8 bd f8 ff ff       	call   c01038fb <pa2page>
c010403e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104042:	89 04 24             	mov    %eax,(%esp)
c0104045:	e8 78 fb ff ff       	call   c0103bc2 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c010404a:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c010404e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104051:	8b 00                	mov    (%eax),%eax
c0104053:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104056:	0f 8f 7e fe ff ff    	jg     c0103eda <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c010405c:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0104062:	5b                   	pop    %ebx
c0104063:	5e                   	pop    %esi
c0104064:	5f                   	pop    %edi
c0104065:	5d                   	pop    %ebp
c0104066:	c3                   	ret    

c0104067 <enable_paging>:

static void
enable_paging(void) {
c0104067:	55                   	push   %ebp
c0104068:	89 e5                	mov    %esp,%ebp
c010406a:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c010406d:	a1 60 89 11 c0       	mov    0xc0118960,%eax
c0104072:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0104075:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0104078:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c010407b:	0f 20 c0             	mov    %cr0,%eax
c010407e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c0104081:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0104084:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c0104087:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c010408e:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c0104092:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104095:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c0104098:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010409b:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c010409e:	c9                   	leave  
c010409f:	c3                   	ret    

c01040a0 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c01040a0:	55                   	push   %ebp
c01040a1:	89 e5                	mov    %esp,%ebp
c01040a3:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c01040a6:	8b 45 14             	mov    0x14(%ebp),%eax
c01040a9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01040ac:	31 d0                	xor    %edx,%eax
c01040ae:	25 ff 0f 00 00       	and    $0xfff,%eax
c01040b3:	85 c0                	test   %eax,%eax
c01040b5:	74 24                	je     c01040db <boot_map_segment+0x3b>
c01040b7:	c7 44 24 0c 02 6a 10 	movl   $0xc0106a02,0xc(%esp)
c01040be:	c0 
c01040bf:	c7 44 24 08 19 6a 10 	movl   $0xc0106a19,0x8(%esp)
c01040c6:	c0 
c01040c7:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c01040ce:	00 
c01040cf:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c01040d6:	e8 ea cb ff ff       	call   c0100cc5 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c01040db:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c01040e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01040e5:	25 ff 0f 00 00       	and    $0xfff,%eax
c01040ea:	89 c2                	mov    %eax,%edx
c01040ec:	8b 45 10             	mov    0x10(%ebp),%eax
c01040ef:	01 c2                	add    %eax,%edx
c01040f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01040f4:	01 d0                	add    %edx,%eax
c01040f6:	83 e8 01             	sub    $0x1,%eax
c01040f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01040fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01040ff:	ba 00 00 00 00       	mov    $0x0,%edx
c0104104:	f7 75 f0             	divl   -0x10(%ebp)
c0104107:	89 d0                	mov    %edx,%eax
c0104109:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010410c:	29 c2                	sub    %eax,%edx
c010410e:	89 d0                	mov    %edx,%eax
c0104110:	c1 e8 0c             	shr    $0xc,%eax
c0104113:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0104116:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104119:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010411c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010411f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104124:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104127:	8b 45 14             	mov    0x14(%ebp),%eax
c010412a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010412d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104130:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104135:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104138:	eb 6b                	jmp    c01041a5 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c010413a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104141:	00 
c0104142:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104145:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104149:	8b 45 08             	mov    0x8(%ebp),%eax
c010414c:	89 04 24             	mov    %eax,(%esp)
c010414f:	e8 cc 01 00 00       	call   c0104320 <get_pte>
c0104154:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0104157:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010415b:	75 24                	jne    c0104181 <boot_map_segment+0xe1>
c010415d:	c7 44 24 0c 2e 6a 10 	movl   $0xc0106a2e,0xc(%esp)
c0104164:	c0 
c0104165:	c7 44 24 08 19 6a 10 	movl   $0xc0106a19,0x8(%esp)
c010416c:	c0 
c010416d:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0104174:	00 
c0104175:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c010417c:	e8 44 cb ff ff       	call   c0100cc5 <__panic>
        *ptep = pa | PTE_P | perm;
c0104181:	8b 45 18             	mov    0x18(%ebp),%eax
c0104184:	8b 55 14             	mov    0x14(%ebp),%edx
c0104187:	09 d0                	or     %edx,%eax
c0104189:	83 c8 01             	or     $0x1,%eax
c010418c:	89 c2                	mov    %eax,%edx
c010418e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104191:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104193:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104197:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c010419e:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01041a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01041a9:	75 8f                	jne    c010413a <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c01041ab:	c9                   	leave  
c01041ac:	c3                   	ret    

c01041ad <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01041ad:	55                   	push   %ebp
c01041ae:	89 e5                	mov    %esp,%ebp
c01041b0:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c01041b3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01041ba:	e8 22 fa ff ff       	call   c0103be1 <alloc_pages>
c01041bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c01041c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01041c6:	75 1c                	jne    c01041e4 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c01041c8:	c7 44 24 08 3b 6a 10 	movl   $0xc0106a3b,0x8(%esp)
c01041cf:	c0 
c01041d0:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c01041d7:	00 
c01041d8:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c01041df:	e8 e1 ca ff ff       	call   c0100cc5 <__panic>
    }
    return page2kva(p);
c01041e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041e7:	89 04 24             	mov    %eax,(%esp)
c01041ea:	e8 5b f7 ff ff       	call   c010394a <page2kva>
}
c01041ef:	c9                   	leave  
c01041f0:	c3                   	ret    

c01041f1 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c01041f1:	55                   	push   %ebp
c01041f2:	89 e5                	mov    %esp,%ebp
c01041f4:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c01041f7:	e8 93 f9 ff ff       	call   c0103b8f <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c01041fc:	e8 75 fa ff ff       	call   c0103c76 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0104201:	e8 79 04 00 00       	call   c010467f <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c0104206:	e8 a2 ff ff ff       	call   c01041ad <boot_alloc_page>
c010420b:	a3 c4 88 11 c0       	mov    %eax,0xc01188c4
    memset(boot_pgdir, 0, PGSIZE);
c0104210:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104215:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010421c:	00 
c010421d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104224:	00 
c0104225:	89 04 24             	mov    %eax,(%esp)
c0104228:	e8 bb 1a 00 00       	call   c0105ce8 <memset>
    boot_cr3 = PADDR(boot_pgdir);
c010422d:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104232:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104235:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010423c:	77 23                	ja     c0104261 <pmm_init+0x70>
c010423e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104241:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104245:	c7 44 24 08 d0 69 10 	movl   $0xc01069d0,0x8(%esp)
c010424c:	c0 
c010424d:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c0104254:	00 
c0104255:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c010425c:	e8 64 ca ff ff       	call   c0100cc5 <__panic>
c0104261:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104264:	05 00 00 00 40       	add    $0x40000000,%eax
c0104269:	a3 60 89 11 c0       	mov    %eax,0xc0118960

    check_pgdir();
c010426e:	e8 2a 04 00 00       	call   c010469d <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0104273:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104278:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c010427e:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104283:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104286:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c010428d:	77 23                	ja     c01042b2 <pmm_init+0xc1>
c010428f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104292:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104296:	c7 44 24 08 d0 69 10 	movl   $0xc01069d0,0x8(%esp)
c010429d:	c0 
c010429e:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c01042a5:	00 
c01042a6:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c01042ad:	e8 13 ca ff ff       	call   c0100cc5 <__panic>
c01042b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01042b5:	05 00 00 00 40       	add    $0x40000000,%eax
c01042ba:	83 c8 03             	or     $0x3,%eax
c01042bd:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01042bf:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01042c4:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c01042cb:	00 
c01042cc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01042d3:	00 
c01042d4:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c01042db:	38 
c01042dc:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c01042e3:	c0 
c01042e4:	89 04 24             	mov    %eax,(%esp)
c01042e7:	e8 b4 fd ff ff       	call   c01040a0 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c01042ec:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01042f1:	8b 15 c4 88 11 c0    	mov    0xc01188c4,%edx
c01042f7:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c01042fd:	89 10                	mov    %edx,(%eax)

    enable_paging();
c01042ff:	e8 63 fd ff ff       	call   c0104067 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0104304:	e8 97 f7 ff ff       	call   c0103aa0 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c0104309:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010430e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0104314:	e8 1f 0a 00 00       	call   c0104d38 <check_boot_pgdir>

    print_pgdir();
c0104319:	e8 ac 0e 00 00       	call   c01051ca <print_pgdir>

}
c010431e:	c9                   	leave  
c010431f:	c3                   	ret    

c0104320 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0104320:	55                   	push   %ebp
c0104321:	89 e5                	mov    %esp,%ebp
c0104323:	83 ec 38             	sub    $0x38,%esp
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif

pde_t *pdep = &pgdir[PDX(la)];
c0104326:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104329:	c1 e8 16             	shr    $0x16,%eax
c010432c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104333:	8b 45 08             	mov    0x8(%ebp),%eax
c0104336:	01 d0                	add    %edx,%eax
c0104338:	89 45 f4             	mov    %eax,-0xc(%ebp)
if(!(*pdep & PTE_P))
c010433b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010433e:	8b 00                	mov    (%eax),%eax
c0104340:	83 e0 01             	and    $0x1,%eax
c0104343:	85 c0                	test   %eax,%eax
c0104345:	0f 85 bd 00 00 00    	jne    c0104408 <get_pte+0xe8>
{
    struct Page* p;
    if(create){
c010434b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010434f:	0f 84 ac 00 00 00    	je     c0104401 <get_pte+0xe1>
    	p = alloc_page();
c0104355:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010435c:	e8 80 f8 ff ff       	call   c0103be1 <alloc_pages>
c0104361:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(p != NULL)
c0104364:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104368:	0f 84 8c 00 00 00    	je     c01043fa <get_pte+0xda>
	{
	    set_page_ref(p,1);
c010436e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104375:	00 
c0104376:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104379:	89 04 24             	mov    %eax,(%esp)
c010437c:	e8 65 f6 ff ff       	call   c01039e6 <set_page_ref>
	    uintptr_t pa = page2pa(p);
c0104381:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104384:	89 04 24             	mov    %eax,(%esp)
c0104387:	e8 59 f5 ff ff       	call   c01038e5 <page2pa>
c010438c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    memset(KADDR(pa),0,PGSIZE);
c010438f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104392:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104395:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104398:	c1 e8 0c             	shr    $0xc,%eax
c010439b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010439e:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01043a3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01043a6:	72 23                	jb     c01043cb <get_pte+0xab>
c01043a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01043ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01043af:	c7 44 24 08 2c 69 10 	movl   $0xc010692c,0x8(%esp)
c01043b6:	c0 
c01043b7:	c7 44 24 04 8a 01 00 	movl   $0x18a,0x4(%esp)
c01043be:	00 
c01043bf:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c01043c6:	e8 fa c8 ff ff       	call   c0100cc5 <__panic>
c01043cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01043ce:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01043d3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01043da:	00 
c01043db:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01043e2:	00 
c01043e3:	89 04 24             	mov    %eax,(%esp)
c01043e6:	e8 fd 18 00 00       	call   c0105ce8 <memset>
	    *pdep = pa | PTE_P | PTE_W | PTE_U; //why?
c01043eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01043ee:	83 c8 07             	or     $0x7,%eax
c01043f1:	89 c2                	mov    %eax,%edx
c01043f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043f6:	89 10                	mov    %edx,(%eax)
c01043f8:	eb 0e                	jmp    c0104408 <get_pte+0xe8>
	}
	else return NULL;
c01043fa:	b8 00 00 00 00       	mov    $0x0,%eax
c01043ff:	eb 63                	jmp    c0104464 <get_pte+0x144>
    }
    else return NULL;
c0104401:	b8 00 00 00 00       	mov    $0x0,%eax
c0104406:	eb 5c                	jmp    c0104464 <get_pte+0x144>
  }
  return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c0104408:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010440b:	8b 00                	mov    (%eax),%eax
c010440d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104412:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104415:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104418:	c1 e8 0c             	shr    $0xc,%eax
c010441b:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010441e:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104423:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104426:	72 23                	jb     c010444b <get_pte+0x12b>
c0104428:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010442b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010442f:	c7 44 24 08 2c 69 10 	movl   $0xc010692c,0x8(%esp)
c0104436:	c0 
c0104437:	c7 44 24 04 91 01 00 	movl   $0x191,0x4(%esp)
c010443e:	00 
c010443f:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c0104446:	e8 7a c8 ff ff       	call   c0100cc5 <__panic>
c010444b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010444e:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104453:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104456:	c1 ea 0c             	shr    $0xc,%edx
c0104459:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c010445f:	c1 e2 02             	shl    $0x2,%edx
c0104462:	01 d0                	add    %edx,%eax
}
c0104464:	c9                   	leave  
c0104465:	c3                   	ret    

c0104466 <get_page>:


//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0104466:	55                   	push   %ebp
c0104467:	89 e5                	mov    %esp,%ebp
c0104469:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010446c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104473:	00 
c0104474:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104477:	89 44 24 04          	mov    %eax,0x4(%esp)
c010447b:	8b 45 08             	mov    0x8(%ebp),%eax
c010447e:	89 04 24             	mov    %eax,(%esp)
c0104481:	e8 9a fe ff ff       	call   c0104320 <get_pte>
c0104486:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0104489:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010448d:	74 08                	je     c0104497 <get_page+0x31>
        *ptep_store = ptep;
c010448f:	8b 45 10             	mov    0x10(%ebp),%eax
c0104492:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104495:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0104497:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010449b:	74 1b                	je     c01044b8 <get_page+0x52>
c010449d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044a0:	8b 00                	mov    (%eax),%eax
c01044a2:	83 e0 01             	and    $0x1,%eax
c01044a5:	85 c0                	test   %eax,%eax
c01044a7:	74 0f                	je     c01044b8 <get_page+0x52>
        return pa2page(*ptep);
c01044a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044ac:	8b 00                	mov    (%eax),%eax
c01044ae:	89 04 24             	mov    %eax,(%esp)
c01044b1:	e8 45 f4 ff ff       	call   c01038fb <pa2page>
c01044b6:	eb 05                	jmp    c01044bd <get_page+0x57>
    }
    return NULL;
c01044b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01044bd:	c9                   	leave  
c01044be:	c3                   	ret    

c01044bf <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01044bf:	55                   	push   %ebp
c01044c0:	89 e5                	mov    %esp,%ebp
c01044c2:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if(*ptep & PTE_P){
c01044c5:	8b 45 10             	mov    0x10(%ebp),%eax
c01044c8:	8b 00                	mov    (%eax),%eax
c01044ca:	83 e0 01             	and    $0x1,%eax
c01044cd:	85 c0                	test   %eax,%eax
c01044cf:	74 52                	je     c0104523 <page_remove_pte+0x64>
    struct Page *page = pte2page(*ptep);
c01044d1:	8b 45 10             	mov    0x10(%ebp),%eax
c01044d4:	8b 00                	mov    (%eax),%eax
c01044d6:	89 04 24             	mov    %eax,(%esp)
c01044d9:	e8 c0 f4 ff ff       	call   c010399e <pte2page>
c01044de:	89 45 f4             	mov    %eax,-0xc(%ebp)
    page_ref_dec(page);
c01044e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044e4:	89 04 24             	mov    %eax,(%esp)
c01044e7:	e8 1e f5 ff ff       	call   c0103a0a <page_ref_dec>
    if(page->ref == 0)
c01044ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044ef:	8b 00                	mov    (%eax),%eax
c01044f1:	85 c0                	test   %eax,%eax
c01044f3:	75 13                	jne    c0104508 <page_remove_pte+0x49>
    {
	free_page(page);
c01044f5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01044fc:	00 
c01044fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104500:	89 04 24             	mov    %eax,(%esp)
c0104503:	e8 11 f7 ff ff       	call   c0103c19 <free_pages>
    }
    *ptep = 0;
c0104508:	8b 45 10             	mov    0x10(%ebp),%eax
c010450b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    tlb_invalidate(pgdir,la);
c0104511:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104514:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104518:	8b 45 08             	mov    0x8(%ebp),%eax
c010451b:	89 04 24             	mov    %eax,(%esp)
c010451e:	e8 ff 00 00 00       	call   c0104622 <tlb_invalidate>
  }
}
c0104523:	c9                   	leave  
c0104524:	c3                   	ret    

c0104525 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0104525:	55                   	push   %ebp
c0104526:	89 e5                	mov    %esp,%ebp
c0104528:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010452b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104532:	00 
c0104533:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104536:	89 44 24 04          	mov    %eax,0x4(%esp)
c010453a:	8b 45 08             	mov    0x8(%ebp),%eax
c010453d:	89 04 24             	mov    %eax,(%esp)
c0104540:	e8 db fd ff ff       	call   c0104320 <get_pte>
c0104545:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0104548:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010454c:	74 19                	je     c0104567 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c010454e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104551:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104555:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104558:	89 44 24 04          	mov    %eax,0x4(%esp)
c010455c:	8b 45 08             	mov    0x8(%ebp),%eax
c010455f:	89 04 24             	mov    %eax,(%esp)
c0104562:	e8 58 ff ff ff       	call   c01044bf <page_remove_pte>
    }
}
c0104567:	c9                   	leave  
c0104568:	c3                   	ret    

c0104569 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0104569:	55                   	push   %ebp
c010456a:	89 e5                	mov    %esp,%ebp
c010456c:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c010456f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104576:	00 
c0104577:	8b 45 10             	mov    0x10(%ebp),%eax
c010457a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010457e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104581:	89 04 24             	mov    %eax,(%esp)
c0104584:	e8 97 fd ff ff       	call   c0104320 <get_pte>
c0104589:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c010458c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104590:	75 0a                	jne    c010459c <page_insert+0x33>
        return -E_NO_MEM;
c0104592:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0104597:	e9 84 00 00 00       	jmp    c0104620 <page_insert+0xb7>
    }
    page_ref_inc(page);
c010459c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010459f:	89 04 24             	mov    %eax,(%esp)
c01045a2:	e8 4c f4 ff ff       	call   c01039f3 <page_ref_inc>
    if (*ptep & PTE_P) {
c01045a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045aa:	8b 00                	mov    (%eax),%eax
c01045ac:	83 e0 01             	and    $0x1,%eax
c01045af:	85 c0                	test   %eax,%eax
c01045b1:	74 3e                	je     c01045f1 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c01045b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045b6:	8b 00                	mov    (%eax),%eax
c01045b8:	89 04 24             	mov    %eax,(%esp)
c01045bb:	e8 de f3 ff ff       	call   c010399e <pte2page>
c01045c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01045c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045c6:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01045c9:	75 0d                	jne    c01045d8 <page_insert+0x6f>
            page_ref_dec(page);
c01045cb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01045ce:	89 04 24             	mov    %eax,(%esp)
c01045d1:	e8 34 f4 ff ff       	call   c0103a0a <page_ref_dec>
c01045d6:	eb 19                	jmp    c01045f1 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c01045d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045db:	89 44 24 08          	mov    %eax,0x8(%esp)
c01045df:	8b 45 10             	mov    0x10(%ebp),%eax
c01045e2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01045e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01045e9:	89 04 24             	mov    %eax,(%esp)
c01045ec:	e8 ce fe ff ff       	call   c01044bf <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c01045f1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01045f4:	89 04 24             	mov    %eax,(%esp)
c01045f7:	e8 e9 f2 ff ff       	call   c01038e5 <page2pa>
c01045fc:	0b 45 14             	or     0x14(%ebp),%eax
c01045ff:	83 c8 01             	or     $0x1,%eax
c0104602:	89 c2                	mov    %eax,%edx
c0104604:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104607:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0104609:	8b 45 10             	mov    0x10(%ebp),%eax
c010460c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104610:	8b 45 08             	mov    0x8(%ebp),%eax
c0104613:	89 04 24             	mov    %eax,(%esp)
c0104616:	e8 07 00 00 00       	call   c0104622 <tlb_invalidate>
    return 0;
c010461b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104620:	c9                   	leave  
c0104621:	c3                   	ret    

c0104622 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0104622:	55                   	push   %ebp
c0104623:	89 e5                	mov    %esp,%ebp
c0104625:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0104628:	0f 20 d8             	mov    %cr3,%eax
c010462b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c010462e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c0104631:	89 c2                	mov    %eax,%edx
c0104633:	8b 45 08             	mov    0x8(%ebp),%eax
c0104636:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104639:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104640:	77 23                	ja     c0104665 <tlb_invalidate+0x43>
c0104642:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104645:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104649:	c7 44 24 08 d0 69 10 	movl   $0xc01069d0,0x8(%esp)
c0104650:	c0 
c0104651:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
c0104658:	00 
c0104659:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c0104660:	e8 60 c6 ff ff       	call   c0100cc5 <__panic>
c0104665:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104668:	05 00 00 00 40       	add    $0x40000000,%eax
c010466d:	39 c2                	cmp    %eax,%edx
c010466f:	75 0c                	jne    c010467d <tlb_invalidate+0x5b>
        invlpg((void *)la);
c0104671:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104674:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0104677:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010467a:	0f 01 38             	invlpg (%eax)
    }
}
c010467d:	c9                   	leave  
c010467e:	c3                   	ret    

c010467f <check_alloc_page>:

static void
check_alloc_page(void) {
c010467f:	55                   	push   %ebp
c0104680:	89 e5                	mov    %esp,%ebp
c0104682:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0104685:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c010468a:	8b 40 18             	mov    0x18(%eax),%eax
c010468d:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c010468f:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104696:	e8 a1 bc ff ff       	call   c010033c <cprintf>
}
c010469b:	c9                   	leave  
c010469c:	c3                   	ret    

c010469d <check_pgdir>:

static void
check_pgdir(void) {
c010469d:	55                   	push   %ebp
c010469e:	89 e5                	mov    %esp,%ebp
c01046a0:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01046a3:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01046a8:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01046ad:	76 24                	jbe    c01046d3 <check_pgdir+0x36>
c01046af:	c7 44 24 0c 73 6a 10 	movl   $0xc0106a73,0xc(%esp)
c01046b6:	c0 
c01046b7:	c7 44 24 08 19 6a 10 	movl   $0xc0106a19,0x8(%esp)
c01046be:	c0 
c01046bf:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c01046c6:	00 
c01046c7:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c01046ce:	e8 f2 c5 ff ff       	call   c0100cc5 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01046d3:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01046d8:	85 c0                	test   %eax,%eax
c01046da:	74 0e                	je     c01046ea <check_pgdir+0x4d>
c01046dc:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01046e1:	25 ff 0f 00 00       	and    $0xfff,%eax
c01046e6:	85 c0                	test   %eax,%eax
c01046e8:	74 24                	je     c010470e <check_pgdir+0x71>
c01046ea:	c7 44 24 0c 90 6a 10 	movl   $0xc0106a90,0xc(%esp)
c01046f1:	c0 
c01046f2:	c7 44 24 08 19 6a 10 	movl   $0xc0106a19,0x8(%esp)
c01046f9:	c0 
c01046fa:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c0104701:	00 
c0104702:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c0104709:	e8 b7 c5 ff ff       	call   c0100cc5 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c010470e:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104713:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010471a:	00 
c010471b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104722:	00 
c0104723:	89 04 24             	mov    %eax,(%esp)
c0104726:	e8 3b fd ff ff       	call   c0104466 <get_page>
c010472b:	85 c0                	test   %eax,%eax
c010472d:	74 24                	je     c0104753 <check_pgdir+0xb6>
c010472f:	c7 44 24 0c c8 6a 10 	movl   $0xc0106ac8,0xc(%esp)
c0104736:	c0 
c0104737:	c7 44 24 08 19 6a 10 	movl   $0xc0106a19,0x8(%esp)
c010473e:	c0 
c010473f:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
c0104746:	00 
c0104747:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c010474e:	e8 72 c5 ff ff       	call   c0100cc5 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0104753:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010475a:	e8 82 f4 ff ff       	call   c0103be1 <alloc_pages>
c010475f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0104762:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104767:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010476e:	00 
c010476f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104776:	00 
c0104777:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010477a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010477e:	89 04 24             	mov    %eax,(%esp)
c0104781:	e8 e3 fd ff ff       	call   c0104569 <page_insert>
c0104786:	85 c0                	test   %eax,%eax
c0104788:	74 24                	je     c01047ae <check_pgdir+0x111>
c010478a:	c7 44 24 0c f0 6a 10 	movl   $0xc0106af0,0xc(%esp)
c0104791:	c0 
c0104792:	c7 44 24 08 19 6a 10 	movl   $0xc0106a19,0x8(%esp)
c0104799:	c0 
c010479a:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c01047a1:	00 
c01047a2:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c01047a9:	e8 17 c5 ff ff       	call   c0100cc5 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c01047ae:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01047b3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01047ba:	00 
c01047bb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01047c2:	00 
c01047c3:	89 04 24             	mov    %eax,(%esp)
c01047c6:	e8 55 fb ff ff       	call   c0104320 <get_pte>
c01047cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01047ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01047d2:	75 24                	jne    c01047f8 <check_pgdir+0x15b>
c01047d4:	c7 44 24 0c 1c 6b 10 	movl   $0xc0106b1c,0xc(%esp)
c01047db:	c0 
c01047dc:	c7 44 24 08 19 6a 10 	movl   $0xc0106a19,0x8(%esp)
c01047e3:	c0 
c01047e4:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
c01047eb:	00 
c01047ec:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c01047f3:	e8 cd c4 ff ff       	call   c0100cc5 <__panic>
    assert(pa2page(*ptep) == p1);
c01047f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047fb:	8b 00                	mov    (%eax),%eax
c01047fd:	89 04 24             	mov    %eax,(%esp)
c0104800:	e8 f6 f0 ff ff       	call   c01038fb <pa2page>
c0104805:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104808:	74 24                	je     c010482e <check_pgdir+0x191>
c010480a:	c7 44 24 0c 49 6b 10 	movl   $0xc0106b49,0xc(%esp)
c0104811:	c0 
c0104812:	c7 44 24 08 19 6a 10 	movl   $0xc0106a19,0x8(%esp)
c0104819:	c0 
c010481a:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c0104821:	00 
c0104822:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c0104829:	e8 97 c4 ff ff       	call   c0100cc5 <__panic>
    assert(page_ref(p1) == 1);
c010482e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104831:	89 04 24             	mov    %eax,(%esp)
c0104834:	e8 a3 f1 ff ff       	call   c01039dc <page_ref>
c0104839:	83 f8 01             	cmp    $0x1,%eax
c010483c:	74 24                	je     c0104862 <check_pgdir+0x1c5>
c010483e:	c7 44 24 0c 5e 6b 10 	movl   $0xc0106b5e,0xc(%esp)
c0104845:	c0 
c0104846:	c7 44 24 08 19 6a 10 	movl   $0xc0106a19,0x8(%esp)
c010484d:	c0 
c010484e:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c0104855:	00 
c0104856:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c010485d:	e8 63 c4 ff ff       	call   c0100cc5 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0104862:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104867:	8b 00                	mov    (%eax),%eax
c0104869:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010486e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104871:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104874:	c1 e8 0c             	shr    $0xc,%eax
c0104877:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010487a:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c010487f:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104882:	72 23                	jb     c01048a7 <check_pgdir+0x20a>
c0104884:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104887:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010488b:	c7 44 24 08 2c 69 10 	movl   $0xc010692c,0x8(%esp)
c0104892:	c0 
c0104893:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c010489a:	00 
c010489b:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c01048a2:	e8 1e c4 ff ff       	call   c0100cc5 <__panic>
c01048a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01048aa:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01048af:	83 c0 04             	add    $0x4,%eax
c01048b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c01048b5:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01048ba:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01048c1:	00 
c01048c2:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01048c9:	00 
c01048ca:	89 04 24             	mov    %eax,(%esp)
c01048cd:	e8 4e fa ff ff       	call   c0104320 <get_pte>
c01048d2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01048d5:	74 24                	je     c01048fb <check_pgdir+0x25e>
c01048d7:	c7 44 24 0c 70 6b 10 	movl   $0xc0106b70,0xc(%esp)
c01048de:	c0 
c01048df:	c7 44 24 08 19 6a 10 	movl   $0xc0106a19,0x8(%esp)
c01048e6:	c0 
c01048e7:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
c01048ee:	00 
c01048ef:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c01048f6:	e8 ca c3 ff ff       	call   c0100cc5 <__panic>

    p2 = alloc_page();
c01048fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104902:	e8 da f2 ff ff       	call   c0103be1 <alloc_pages>
c0104907:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c010490a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010490f:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0104916:	00 
c0104917:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010491e:	00 
c010491f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104922:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104926:	89 04 24             	mov    %eax,(%esp)
c0104929:	e8 3b fc ff ff       	call   c0104569 <page_insert>
c010492e:	85 c0                	test   %eax,%eax
c0104930:	74 24                	je     c0104956 <check_pgdir+0x2b9>
c0104932:	c7 44 24 0c 98 6b 10 	movl   $0xc0106b98,0xc(%esp)
c0104939:	c0 
c010493a:	c7 44 24 08 19 6a 10 	movl   $0xc0106a19,0x8(%esp)
c0104941:	c0 
c0104942:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c0104949:	00 
c010494a:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c0104951:	e8 6f c3 ff ff       	call   c0100cc5 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104956:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010495b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104962:	00 
c0104963:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c010496a:	00 
c010496b:	89 04 24             	mov    %eax,(%esp)
c010496e:	e8 ad f9 ff ff       	call   c0104320 <get_pte>
c0104973:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104976:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010497a:	75 24                	jne    c01049a0 <check_pgdir+0x303>
c010497c:	c7 44 24 0c d0 6b 10 	movl   $0xc0106bd0,0xc(%esp)
c0104983:	c0 
c0104984:	c7 44 24 08 19 6a 10 	movl   $0xc0106a19,0x8(%esp)
c010498b:	c0 
c010498c:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
c0104993:	00 
c0104994:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c010499b:	e8 25 c3 ff ff       	call   c0100cc5 <__panic>
    assert(*ptep & PTE_U);
c01049a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049a3:	8b 00                	mov    (%eax),%eax
c01049a5:	83 e0 04             	and    $0x4,%eax
c01049a8:	85 c0                	test   %eax,%eax
c01049aa:	75 24                	jne    c01049d0 <check_pgdir+0x333>
c01049ac:	c7 44 24 0c 00 6c 10 	movl   $0xc0106c00,0xc(%esp)
c01049b3:	c0 
c01049b4:	c7 44 24 08 19 6a 10 	movl   $0xc0106a19,0x8(%esp)
c01049bb:	c0 
c01049bc:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
c01049c3:	00 
c01049c4:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c01049cb:	e8 f5 c2 ff ff       	call   c0100cc5 <__panic>
    assert(*ptep & PTE_W);
c01049d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049d3:	8b 00                	mov    (%eax),%eax
c01049d5:	83 e0 02             	and    $0x2,%eax
c01049d8:	85 c0                	test   %eax,%eax
c01049da:	75 24                	jne    c0104a00 <check_pgdir+0x363>
c01049dc:	c7 44 24 0c 0e 6c 10 	movl   $0xc0106c0e,0xc(%esp)
c01049e3:	c0 
c01049e4:	c7 44 24 08 19 6a 10 	movl   $0xc0106a19,0x8(%esp)
c01049eb:	c0 
c01049ec:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c01049f3:	00 
c01049f4:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c01049fb:	e8 c5 c2 ff ff       	call   c0100cc5 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0104a00:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104a05:	8b 00                	mov    (%eax),%eax
c0104a07:	83 e0 04             	and    $0x4,%eax
c0104a0a:	85 c0                	test   %eax,%eax
c0104a0c:	75 24                	jne    c0104a32 <check_pgdir+0x395>
c0104a0e:	c7 44 24 0c 1c 6c 10 	movl   $0xc0106c1c,0xc(%esp)
c0104a15:	c0 
c0104a16:	c7 44 24 08 19 6a 10 	movl   $0xc0106a19,0x8(%esp)
c0104a1d:	c0 
c0104a1e:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c0104a25:	00 
c0104a26:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c0104a2d:	e8 93 c2 ff ff       	call   c0100cc5 <__panic>
    assert(page_ref(p2) == 1);
c0104a32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104a35:	89 04 24             	mov    %eax,(%esp)
c0104a38:	e8 9f ef ff ff       	call   c01039dc <page_ref>
c0104a3d:	83 f8 01             	cmp    $0x1,%eax
c0104a40:	74 24                	je     c0104a66 <check_pgdir+0x3c9>
c0104a42:	c7 44 24 0c 32 6c 10 	movl   $0xc0106c32,0xc(%esp)
c0104a49:	c0 
c0104a4a:	c7 44 24 08 19 6a 10 	movl   $0xc0106a19,0x8(%esp)
c0104a51:	c0 
c0104a52:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
c0104a59:	00 
c0104a5a:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c0104a61:	e8 5f c2 ff ff       	call   c0100cc5 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104a66:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104a6b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104a72:	00 
c0104a73:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104a7a:	00 
c0104a7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104a7e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104a82:	89 04 24             	mov    %eax,(%esp)
c0104a85:	e8 df fa ff ff       	call   c0104569 <page_insert>
c0104a8a:	85 c0                	test   %eax,%eax
c0104a8c:	74 24                	je     c0104ab2 <check_pgdir+0x415>
c0104a8e:	c7 44 24 0c 44 6c 10 	movl   $0xc0106c44,0xc(%esp)
c0104a95:	c0 
c0104a96:	c7 44 24 08 19 6a 10 	movl   $0xc0106a19,0x8(%esp)
c0104a9d:	c0 
c0104a9e:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
c0104aa5:	00 
c0104aa6:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c0104aad:	e8 13 c2 ff ff       	call   c0100cc5 <__panic>
    assert(page_ref(p1) == 2);
c0104ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ab5:	89 04 24             	mov    %eax,(%esp)
c0104ab8:	e8 1f ef ff ff       	call   c01039dc <page_ref>
c0104abd:	83 f8 02             	cmp    $0x2,%eax
c0104ac0:	74 24                	je     c0104ae6 <check_pgdir+0x449>
c0104ac2:	c7 44 24 0c 70 6c 10 	movl   $0xc0106c70,0xc(%esp)
c0104ac9:	c0 
c0104aca:	c7 44 24 08 19 6a 10 	movl   $0xc0106a19,0x8(%esp)
c0104ad1:	c0 
c0104ad2:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
c0104ad9:	00 
c0104ada:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c0104ae1:	e8 df c1 ff ff       	call   c0100cc5 <__panic>
    assert(page_ref(p2) == 0);
c0104ae6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ae9:	89 04 24             	mov    %eax,(%esp)
c0104aec:	e8 eb ee ff ff       	call   c01039dc <page_ref>
c0104af1:	85 c0                	test   %eax,%eax
c0104af3:	74 24                	je     c0104b19 <check_pgdir+0x47c>
c0104af5:	c7 44 24 0c 82 6c 10 	movl   $0xc0106c82,0xc(%esp)
c0104afc:	c0 
c0104afd:	c7 44 24 08 19 6a 10 	movl   $0xc0106a19,0x8(%esp)
c0104b04:	c0 
c0104b05:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c0104b0c:	00 
c0104b0d:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c0104b14:	e8 ac c1 ff ff       	call   c0100cc5 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104b19:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104b1e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104b25:	00 
c0104b26:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104b2d:	00 
c0104b2e:	89 04 24             	mov    %eax,(%esp)
c0104b31:	e8 ea f7 ff ff       	call   c0104320 <get_pte>
c0104b36:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104b39:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104b3d:	75 24                	jne    c0104b63 <check_pgdir+0x4c6>
c0104b3f:	c7 44 24 0c d0 6b 10 	movl   $0xc0106bd0,0xc(%esp)
c0104b46:	c0 
c0104b47:	c7 44 24 08 19 6a 10 	movl   $0xc0106a19,0x8(%esp)
c0104b4e:	c0 
c0104b4f:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
c0104b56:	00 
c0104b57:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c0104b5e:	e8 62 c1 ff ff       	call   c0100cc5 <__panic>
    assert(pa2page(*ptep) == p1);
c0104b63:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b66:	8b 00                	mov    (%eax),%eax
c0104b68:	89 04 24             	mov    %eax,(%esp)
c0104b6b:	e8 8b ed ff ff       	call   c01038fb <pa2page>
c0104b70:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104b73:	74 24                	je     c0104b99 <check_pgdir+0x4fc>
c0104b75:	c7 44 24 0c 49 6b 10 	movl   $0xc0106b49,0xc(%esp)
c0104b7c:	c0 
c0104b7d:	c7 44 24 08 19 6a 10 	movl   $0xc0106a19,0x8(%esp)
c0104b84:	c0 
c0104b85:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
c0104b8c:	00 
c0104b8d:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c0104b94:	e8 2c c1 ff ff       	call   c0100cc5 <__panic>
    assert((*ptep & PTE_U) == 0);
c0104b99:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b9c:	8b 00                	mov    (%eax),%eax
c0104b9e:	83 e0 04             	and    $0x4,%eax
c0104ba1:	85 c0                	test   %eax,%eax
c0104ba3:	74 24                	je     c0104bc9 <check_pgdir+0x52c>
c0104ba5:	c7 44 24 0c 94 6c 10 	movl   $0xc0106c94,0xc(%esp)
c0104bac:	c0 
c0104bad:	c7 44 24 08 19 6a 10 	movl   $0xc0106a19,0x8(%esp)
c0104bb4:	c0 
c0104bb5:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
c0104bbc:	00 
c0104bbd:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c0104bc4:	e8 fc c0 ff ff       	call   c0100cc5 <__panic>

    page_remove(boot_pgdir, 0x0);
c0104bc9:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104bce:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104bd5:	00 
c0104bd6:	89 04 24             	mov    %eax,(%esp)
c0104bd9:	e8 47 f9 ff ff       	call   c0104525 <page_remove>
    assert(page_ref(p1) == 1);
c0104bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104be1:	89 04 24             	mov    %eax,(%esp)
c0104be4:	e8 f3 ed ff ff       	call   c01039dc <page_ref>
c0104be9:	83 f8 01             	cmp    $0x1,%eax
c0104bec:	74 24                	je     c0104c12 <check_pgdir+0x575>
c0104bee:	c7 44 24 0c 5e 6b 10 	movl   $0xc0106b5e,0xc(%esp)
c0104bf5:	c0 
c0104bf6:	c7 44 24 08 19 6a 10 	movl   $0xc0106a19,0x8(%esp)
c0104bfd:	c0 
c0104bfe:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c0104c05:	00 
c0104c06:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c0104c0d:	e8 b3 c0 ff ff       	call   c0100cc5 <__panic>
    assert(page_ref(p2) == 0);
c0104c12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c15:	89 04 24             	mov    %eax,(%esp)
c0104c18:	e8 bf ed ff ff       	call   c01039dc <page_ref>
c0104c1d:	85 c0                	test   %eax,%eax
c0104c1f:	74 24                	je     c0104c45 <check_pgdir+0x5a8>
c0104c21:	c7 44 24 0c 82 6c 10 	movl   $0xc0106c82,0xc(%esp)
c0104c28:	c0 
c0104c29:	c7 44 24 08 19 6a 10 	movl   $0xc0106a19,0x8(%esp)
c0104c30:	c0 
c0104c31:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
c0104c38:	00 
c0104c39:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c0104c40:	e8 80 c0 ff ff       	call   c0100cc5 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104c45:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104c4a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104c51:	00 
c0104c52:	89 04 24             	mov    %eax,(%esp)
c0104c55:	e8 cb f8 ff ff       	call   c0104525 <page_remove>
    assert(page_ref(p1) == 0);
c0104c5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c5d:	89 04 24             	mov    %eax,(%esp)
c0104c60:	e8 77 ed ff ff       	call   c01039dc <page_ref>
c0104c65:	85 c0                	test   %eax,%eax
c0104c67:	74 24                	je     c0104c8d <check_pgdir+0x5f0>
c0104c69:	c7 44 24 0c a9 6c 10 	movl   $0xc0106ca9,0xc(%esp)
c0104c70:	c0 
c0104c71:	c7 44 24 08 19 6a 10 	movl   $0xc0106a19,0x8(%esp)
c0104c78:	c0 
c0104c79:	c7 44 24 04 27 02 00 	movl   $0x227,0x4(%esp)
c0104c80:	00 
c0104c81:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c0104c88:	e8 38 c0 ff ff       	call   c0100cc5 <__panic>
    assert(page_ref(p2) == 0);
c0104c8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c90:	89 04 24             	mov    %eax,(%esp)
c0104c93:	e8 44 ed ff ff       	call   c01039dc <page_ref>
c0104c98:	85 c0                	test   %eax,%eax
c0104c9a:	74 24                	je     c0104cc0 <check_pgdir+0x623>
c0104c9c:	c7 44 24 0c 82 6c 10 	movl   $0xc0106c82,0xc(%esp)
c0104ca3:	c0 
c0104ca4:	c7 44 24 08 19 6a 10 	movl   $0xc0106a19,0x8(%esp)
c0104cab:	c0 
c0104cac:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
c0104cb3:	00 
c0104cb4:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c0104cbb:	e8 05 c0 ff ff       	call   c0100cc5 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c0104cc0:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104cc5:	8b 00                	mov    (%eax),%eax
c0104cc7:	89 04 24             	mov    %eax,(%esp)
c0104cca:	e8 2c ec ff ff       	call   c01038fb <pa2page>
c0104ccf:	89 04 24             	mov    %eax,(%esp)
c0104cd2:	e8 05 ed ff ff       	call   c01039dc <page_ref>
c0104cd7:	83 f8 01             	cmp    $0x1,%eax
c0104cda:	74 24                	je     c0104d00 <check_pgdir+0x663>
c0104cdc:	c7 44 24 0c bc 6c 10 	movl   $0xc0106cbc,0xc(%esp)
c0104ce3:	c0 
c0104ce4:	c7 44 24 08 19 6a 10 	movl   $0xc0106a19,0x8(%esp)
c0104ceb:	c0 
c0104cec:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
c0104cf3:	00 
c0104cf4:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c0104cfb:	e8 c5 bf ff ff       	call   c0100cc5 <__panic>
    free_page(pa2page(boot_pgdir[0]));
c0104d00:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104d05:	8b 00                	mov    (%eax),%eax
c0104d07:	89 04 24             	mov    %eax,(%esp)
c0104d0a:	e8 ec eb ff ff       	call   c01038fb <pa2page>
c0104d0f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104d16:	00 
c0104d17:	89 04 24             	mov    %eax,(%esp)
c0104d1a:	e8 fa ee ff ff       	call   c0103c19 <free_pages>
    boot_pgdir[0] = 0;
c0104d1f:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104d24:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104d2a:	c7 04 24 e2 6c 10 c0 	movl   $0xc0106ce2,(%esp)
c0104d31:	e8 06 b6 ff ff       	call   c010033c <cprintf>
}
c0104d36:	c9                   	leave  
c0104d37:	c3                   	ret    

c0104d38 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0104d38:	55                   	push   %ebp
c0104d39:	89 e5                	mov    %esp,%ebp
c0104d3b:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104d3e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104d45:	e9 ca 00 00 00       	jmp    c0104e14 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0104d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104d50:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d53:	c1 e8 0c             	shr    $0xc,%eax
c0104d56:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104d59:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104d5e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0104d61:	72 23                	jb     c0104d86 <check_boot_pgdir+0x4e>
c0104d63:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d66:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104d6a:	c7 44 24 08 2c 69 10 	movl   $0xc010692c,0x8(%esp)
c0104d71:	c0 
c0104d72:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
c0104d79:	00 
c0104d7a:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c0104d81:	e8 3f bf ff ff       	call   c0100cc5 <__panic>
c0104d86:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d89:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104d8e:	89 c2                	mov    %eax,%edx
c0104d90:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104d95:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104d9c:	00 
c0104d9d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104da1:	89 04 24             	mov    %eax,(%esp)
c0104da4:	e8 77 f5 ff ff       	call   c0104320 <get_pte>
c0104da9:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104dac:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104db0:	75 24                	jne    c0104dd6 <check_boot_pgdir+0x9e>
c0104db2:	c7 44 24 0c fc 6c 10 	movl   $0xc0106cfc,0xc(%esp)
c0104db9:	c0 
c0104dba:	c7 44 24 08 19 6a 10 	movl   $0xc0106a19,0x8(%esp)
c0104dc1:	c0 
c0104dc2:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
c0104dc9:	00 
c0104dca:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c0104dd1:	e8 ef be ff ff       	call   c0100cc5 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0104dd6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104dd9:	8b 00                	mov    (%eax),%eax
c0104ddb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104de0:	89 c2                	mov    %eax,%edx
c0104de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104de5:	39 c2                	cmp    %eax,%edx
c0104de7:	74 24                	je     c0104e0d <check_boot_pgdir+0xd5>
c0104de9:	c7 44 24 0c 39 6d 10 	movl   $0xc0106d39,0xc(%esp)
c0104df0:	c0 
c0104df1:	c7 44 24 08 19 6a 10 	movl   $0xc0106a19,0x8(%esp)
c0104df8:	c0 
c0104df9:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
c0104e00:	00 
c0104e01:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c0104e08:	e8 b8 be ff ff       	call   c0100cc5 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104e0d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0104e14:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104e17:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104e1c:	39 c2                	cmp    %eax,%edx
c0104e1e:	0f 82 26 ff ff ff    	jb     c0104d4a <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0104e24:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104e29:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104e2e:	8b 00                	mov    (%eax),%eax
c0104e30:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104e35:	89 c2                	mov    %eax,%edx
c0104e37:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104e3c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104e3f:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0104e46:	77 23                	ja     c0104e6b <check_boot_pgdir+0x133>
c0104e48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e4b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104e4f:	c7 44 24 08 d0 69 10 	movl   $0xc01069d0,0x8(%esp)
c0104e56:	c0 
c0104e57:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
c0104e5e:	00 
c0104e5f:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c0104e66:	e8 5a be ff ff       	call   c0100cc5 <__panic>
c0104e6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e6e:	05 00 00 00 40       	add    $0x40000000,%eax
c0104e73:	39 c2                	cmp    %eax,%edx
c0104e75:	74 24                	je     c0104e9b <check_boot_pgdir+0x163>
c0104e77:	c7 44 24 0c 50 6d 10 	movl   $0xc0106d50,0xc(%esp)
c0104e7e:	c0 
c0104e7f:	c7 44 24 08 19 6a 10 	movl   $0xc0106a19,0x8(%esp)
c0104e86:	c0 
c0104e87:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
c0104e8e:	00 
c0104e8f:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c0104e96:	e8 2a be ff ff       	call   c0100cc5 <__panic>

    assert(boot_pgdir[0] == 0);
c0104e9b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104ea0:	8b 00                	mov    (%eax),%eax
c0104ea2:	85 c0                	test   %eax,%eax
c0104ea4:	74 24                	je     c0104eca <check_boot_pgdir+0x192>
c0104ea6:	c7 44 24 0c 84 6d 10 	movl   $0xc0106d84,0xc(%esp)
c0104ead:	c0 
c0104eae:	c7 44 24 08 19 6a 10 	movl   $0xc0106a19,0x8(%esp)
c0104eb5:	c0 
c0104eb6:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
c0104ebd:	00 
c0104ebe:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c0104ec5:	e8 fb bd ff ff       	call   c0100cc5 <__panic>

    struct Page *p;
    p = alloc_page();
c0104eca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104ed1:	e8 0b ed ff ff       	call   c0103be1 <alloc_pages>
c0104ed6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0104ed9:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104ede:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104ee5:	00 
c0104ee6:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0104eed:	00 
c0104eee:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104ef1:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104ef5:	89 04 24             	mov    %eax,(%esp)
c0104ef8:	e8 6c f6 ff ff       	call   c0104569 <page_insert>
c0104efd:	85 c0                	test   %eax,%eax
c0104eff:	74 24                	je     c0104f25 <check_boot_pgdir+0x1ed>
c0104f01:	c7 44 24 0c 98 6d 10 	movl   $0xc0106d98,0xc(%esp)
c0104f08:	c0 
c0104f09:	c7 44 24 08 19 6a 10 	movl   $0xc0106a19,0x8(%esp)
c0104f10:	c0 
c0104f11:	c7 44 24 04 40 02 00 	movl   $0x240,0x4(%esp)
c0104f18:	00 
c0104f19:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c0104f20:	e8 a0 bd ff ff       	call   c0100cc5 <__panic>
    assert(page_ref(p) == 1);
c0104f25:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104f28:	89 04 24             	mov    %eax,(%esp)
c0104f2b:	e8 ac ea ff ff       	call   c01039dc <page_ref>
c0104f30:	83 f8 01             	cmp    $0x1,%eax
c0104f33:	74 24                	je     c0104f59 <check_boot_pgdir+0x221>
c0104f35:	c7 44 24 0c c6 6d 10 	movl   $0xc0106dc6,0xc(%esp)
c0104f3c:	c0 
c0104f3d:	c7 44 24 08 19 6a 10 	movl   $0xc0106a19,0x8(%esp)
c0104f44:	c0 
c0104f45:	c7 44 24 04 41 02 00 	movl   $0x241,0x4(%esp)
c0104f4c:	00 
c0104f4d:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c0104f54:	e8 6c bd ff ff       	call   c0100cc5 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0104f59:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104f5e:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104f65:	00 
c0104f66:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0104f6d:	00 
c0104f6e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104f71:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104f75:	89 04 24             	mov    %eax,(%esp)
c0104f78:	e8 ec f5 ff ff       	call   c0104569 <page_insert>
c0104f7d:	85 c0                	test   %eax,%eax
c0104f7f:	74 24                	je     c0104fa5 <check_boot_pgdir+0x26d>
c0104f81:	c7 44 24 0c d8 6d 10 	movl   $0xc0106dd8,0xc(%esp)
c0104f88:	c0 
c0104f89:	c7 44 24 08 19 6a 10 	movl   $0xc0106a19,0x8(%esp)
c0104f90:	c0 
c0104f91:	c7 44 24 04 42 02 00 	movl   $0x242,0x4(%esp)
c0104f98:	00 
c0104f99:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c0104fa0:	e8 20 bd ff ff       	call   c0100cc5 <__panic>
    assert(page_ref(p) == 2);
c0104fa5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104fa8:	89 04 24             	mov    %eax,(%esp)
c0104fab:	e8 2c ea ff ff       	call   c01039dc <page_ref>
c0104fb0:	83 f8 02             	cmp    $0x2,%eax
c0104fb3:	74 24                	je     c0104fd9 <check_boot_pgdir+0x2a1>
c0104fb5:	c7 44 24 0c 0f 6e 10 	movl   $0xc0106e0f,0xc(%esp)
c0104fbc:	c0 
c0104fbd:	c7 44 24 08 19 6a 10 	movl   $0xc0106a19,0x8(%esp)
c0104fc4:	c0 
c0104fc5:	c7 44 24 04 43 02 00 	movl   $0x243,0x4(%esp)
c0104fcc:	00 
c0104fcd:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c0104fd4:	e8 ec bc ff ff       	call   c0100cc5 <__panic>

    const char *str = "ucore: Hello world!!";
c0104fd9:	c7 45 dc 20 6e 10 c0 	movl   $0xc0106e20,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0104fe0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104fe3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104fe7:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104fee:	e8 1e 0a 00 00       	call   c0105a11 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0104ff3:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0104ffa:	00 
c0104ffb:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105002:	e8 83 0a 00 00       	call   c0105a8a <strcmp>
c0105007:	85 c0                	test   %eax,%eax
c0105009:	74 24                	je     c010502f <check_boot_pgdir+0x2f7>
c010500b:	c7 44 24 0c 38 6e 10 	movl   $0xc0106e38,0xc(%esp)
c0105012:	c0 
c0105013:	c7 44 24 08 19 6a 10 	movl   $0xc0106a19,0x8(%esp)
c010501a:	c0 
c010501b:	c7 44 24 04 47 02 00 	movl   $0x247,0x4(%esp)
c0105022:	00 
c0105023:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c010502a:	e8 96 bc ff ff       	call   c0100cc5 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c010502f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105032:	89 04 24             	mov    %eax,(%esp)
c0105035:	e8 10 e9 ff ff       	call   c010394a <page2kva>
c010503a:	05 00 01 00 00       	add    $0x100,%eax
c010503f:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0105042:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105049:	e8 6b 09 00 00       	call   c01059b9 <strlen>
c010504e:	85 c0                	test   %eax,%eax
c0105050:	74 24                	je     c0105076 <check_boot_pgdir+0x33e>
c0105052:	c7 44 24 0c 70 6e 10 	movl   $0xc0106e70,0xc(%esp)
c0105059:	c0 
c010505a:	c7 44 24 08 19 6a 10 	movl   $0xc0106a19,0x8(%esp)
c0105061:	c0 
c0105062:	c7 44 24 04 4a 02 00 	movl   $0x24a,0x4(%esp)
c0105069:	00 
c010506a:	c7 04 24 f4 69 10 c0 	movl   $0xc01069f4,(%esp)
c0105071:	e8 4f bc ff ff       	call   c0100cc5 <__panic>

    free_page(p);
c0105076:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010507d:	00 
c010507e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105081:	89 04 24             	mov    %eax,(%esp)
c0105084:	e8 90 eb ff ff       	call   c0103c19 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c0105089:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010508e:	8b 00                	mov    (%eax),%eax
c0105090:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105095:	89 04 24             	mov    %eax,(%esp)
c0105098:	e8 5e e8 ff ff       	call   c01038fb <pa2page>
c010509d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01050a4:	00 
c01050a5:	89 04 24             	mov    %eax,(%esp)
c01050a8:	e8 6c eb ff ff       	call   c0103c19 <free_pages>
    boot_pgdir[0] = 0;
c01050ad:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01050b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c01050b8:	c7 04 24 94 6e 10 c0 	movl   $0xc0106e94,(%esp)
c01050bf:	e8 78 b2 ff ff       	call   c010033c <cprintf>
}
c01050c4:	c9                   	leave  
c01050c5:	c3                   	ret    

c01050c6 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c01050c6:	55                   	push   %ebp
c01050c7:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c01050c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01050cc:	83 e0 04             	and    $0x4,%eax
c01050cf:	85 c0                	test   %eax,%eax
c01050d1:	74 07                	je     c01050da <perm2str+0x14>
c01050d3:	b8 75 00 00 00       	mov    $0x75,%eax
c01050d8:	eb 05                	jmp    c01050df <perm2str+0x19>
c01050da:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01050df:	a2 48 89 11 c0       	mov    %al,0xc0118948
    str[1] = 'r';
c01050e4:	c6 05 49 89 11 c0 72 	movb   $0x72,0xc0118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
c01050eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01050ee:	83 e0 02             	and    $0x2,%eax
c01050f1:	85 c0                	test   %eax,%eax
c01050f3:	74 07                	je     c01050fc <perm2str+0x36>
c01050f5:	b8 77 00 00 00       	mov    $0x77,%eax
c01050fa:	eb 05                	jmp    c0105101 <perm2str+0x3b>
c01050fc:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105101:	a2 4a 89 11 c0       	mov    %al,0xc011894a
    str[3] = '\0';
c0105106:	c6 05 4b 89 11 c0 00 	movb   $0x0,0xc011894b
    return str;
c010510d:	b8 48 89 11 c0       	mov    $0xc0118948,%eax
}
c0105112:	5d                   	pop    %ebp
c0105113:	c3                   	ret    

c0105114 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0105114:	55                   	push   %ebp
c0105115:	89 e5                	mov    %esp,%ebp
c0105117:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c010511a:	8b 45 10             	mov    0x10(%ebp),%eax
c010511d:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105120:	72 0a                	jb     c010512c <get_pgtable_items+0x18>
        return 0;
c0105122:	b8 00 00 00 00       	mov    $0x0,%eax
c0105127:	e9 9c 00 00 00       	jmp    c01051c8 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c010512c:	eb 04                	jmp    c0105132 <get_pgtable_items+0x1e>
        start ++;
c010512e:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105132:	8b 45 10             	mov    0x10(%ebp),%eax
c0105135:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105138:	73 18                	jae    c0105152 <get_pgtable_items+0x3e>
c010513a:	8b 45 10             	mov    0x10(%ebp),%eax
c010513d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105144:	8b 45 14             	mov    0x14(%ebp),%eax
c0105147:	01 d0                	add    %edx,%eax
c0105149:	8b 00                	mov    (%eax),%eax
c010514b:	83 e0 01             	and    $0x1,%eax
c010514e:	85 c0                	test   %eax,%eax
c0105150:	74 dc                	je     c010512e <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c0105152:	8b 45 10             	mov    0x10(%ebp),%eax
c0105155:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105158:	73 69                	jae    c01051c3 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c010515a:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c010515e:	74 08                	je     c0105168 <get_pgtable_items+0x54>
            *left_store = start;
c0105160:	8b 45 18             	mov    0x18(%ebp),%eax
c0105163:	8b 55 10             	mov    0x10(%ebp),%edx
c0105166:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0105168:	8b 45 10             	mov    0x10(%ebp),%eax
c010516b:	8d 50 01             	lea    0x1(%eax),%edx
c010516e:	89 55 10             	mov    %edx,0x10(%ebp)
c0105171:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105178:	8b 45 14             	mov    0x14(%ebp),%eax
c010517b:	01 d0                	add    %edx,%eax
c010517d:	8b 00                	mov    (%eax),%eax
c010517f:	83 e0 07             	and    $0x7,%eax
c0105182:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105185:	eb 04                	jmp    c010518b <get_pgtable_items+0x77>
            start ++;
c0105187:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c010518b:	8b 45 10             	mov    0x10(%ebp),%eax
c010518e:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105191:	73 1d                	jae    c01051b0 <get_pgtable_items+0x9c>
c0105193:	8b 45 10             	mov    0x10(%ebp),%eax
c0105196:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010519d:	8b 45 14             	mov    0x14(%ebp),%eax
c01051a0:	01 d0                	add    %edx,%eax
c01051a2:	8b 00                	mov    (%eax),%eax
c01051a4:	83 e0 07             	and    $0x7,%eax
c01051a7:	89 c2                	mov    %eax,%edx
c01051a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01051ac:	39 c2                	cmp    %eax,%edx
c01051ae:	74 d7                	je     c0105187 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c01051b0:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01051b4:	74 08                	je     c01051be <get_pgtable_items+0xaa>
            *right_store = start;
c01051b6:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01051b9:	8b 55 10             	mov    0x10(%ebp),%edx
c01051bc:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c01051be:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01051c1:	eb 05                	jmp    c01051c8 <get_pgtable_items+0xb4>
    }
    return 0;
c01051c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01051c8:	c9                   	leave  
c01051c9:	c3                   	ret    

c01051ca <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c01051ca:	55                   	push   %ebp
c01051cb:	89 e5                	mov    %esp,%ebp
c01051cd:	57                   	push   %edi
c01051ce:	56                   	push   %esi
c01051cf:	53                   	push   %ebx
c01051d0:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c01051d3:	c7 04 24 b4 6e 10 c0 	movl   $0xc0106eb4,(%esp)
c01051da:	e8 5d b1 ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
c01051df:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01051e6:	e9 fa 00 00 00       	jmp    c01052e5 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01051eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01051ee:	89 04 24             	mov    %eax,(%esp)
c01051f1:	e8 d0 fe ff ff       	call   c01050c6 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c01051f6:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01051f9:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01051fc:	29 d1                	sub    %edx,%ecx
c01051fe:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105200:	89 d6                	mov    %edx,%esi
c0105202:	c1 e6 16             	shl    $0x16,%esi
c0105205:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105208:	89 d3                	mov    %edx,%ebx
c010520a:	c1 e3 16             	shl    $0x16,%ebx
c010520d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105210:	89 d1                	mov    %edx,%ecx
c0105212:	c1 e1 16             	shl    $0x16,%ecx
c0105215:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0105218:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010521b:	29 d7                	sub    %edx,%edi
c010521d:	89 fa                	mov    %edi,%edx
c010521f:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105223:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105227:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010522b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010522f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105233:	c7 04 24 e5 6e 10 c0 	movl   $0xc0106ee5,(%esp)
c010523a:	e8 fd b0 ff ff       	call   c010033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c010523f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105242:	c1 e0 0a             	shl    $0xa,%eax
c0105245:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105248:	eb 54                	jmp    c010529e <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010524a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010524d:	89 04 24             	mov    %eax,(%esp)
c0105250:	e8 71 fe ff ff       	call   c01050c6 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0105255:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0105258:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010525b:	29 d1                	sub    %edx,%ecx
c010525d:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010525f:	89 d6                	mov    %edx,%esi
c0105261:	c1 e6 0c             	shl    $0xc,%esi
c0105264:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105267:	89 d3                	mov    %edx,%ebx
c0105269:	c1 e3 0c             	shl    $0xc,%ebx
c010526c:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010526f:	c1 e2 0c             	shl    $0xc,%edx
c0105272:	89 d1                	mov    %edx,%ecx
c0105274:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0105277:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010527a:	29 d7                	sub    %edx,%edi
c010527c:	89 fa                	mov    %edi,%edx
c010527e:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105282:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105286:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010528a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010528e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105292:	c7 04 24 04 6f 10 c0 	movl   $0xc0106f04,(%esp)
c0105299:	e8 9e b0 ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c010529e:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c01052a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01052a6:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01052a9:	89 ce                	mov    %ecx,%esi
c01052ab:	c1 e6 0a             	shl    $0xa,%esi
c01052ae:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c01052b1:	89 cb                	mov    %ecx,%ebx
c01052b3:	c1 e3 0a             	shl    $0xa,%ebx
c01052b6:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c01052b9:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c01052bd:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c01052c0:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01052c4:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01052c8:	89 44 24 08          	mov    %eax,0x8(%esp)
c01052cc:	89 74 24 04          	mov    %esi,0x4(%esp)
c01052d0:	89 1c 24             	mov    %ebx,(%esp)
c01052d3:	e8 3c fe ff ff       	call   c0105114 <get_pgtable_items>
c01052d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01052db:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01052df:	0f 85 65 ff ff ff    	jne    c010524a <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01052e5:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c01052ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01052ed:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c01052f0:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c01052f4:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c01052f7:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01052fb:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01052ff:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105303:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c010530a:	00 
c010530b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0105312:	e8 fd fd ff ff       	call   c0105114 <get_pgtable_items>
c0105317:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010531a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010531e:	0f 85 c7 fe ff ff    	jne    c01051eb <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0105324:	c7 04 24 28 6f 10 c0 	movl   $0xc0106f28,(%esp)
c010532b:	e8 0c b0 ff ff       	call   c010033c <cprintf>
}
c0105330:	83 c4 4c             	add    $0x4c,%esp
c0105333:	5b                   	pop    %ebx
c0105334:	5e                   	pop    %esi
c0105335:	5f                   	pop    %edi
c0105336:	5d                   	pop    %ebp
c0105337:	c3                   	ret    

c0105338 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0105338:	55                   	push   %ebp
c0105339:	89 e5                	mov    %esp,%ebp
c010533b:	83 ec 58             	sub    $0x58,%esp
c010533e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105341:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105344:	8b 45 14             	mov    0x14(%ebp),%eax
c0105347:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c010534a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010534d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105350:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105353:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0105356:	8b 45 18             	mov    0x18(%ebp),%eax
c0105359:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010535c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010535f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105362:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105365:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0105368:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010536b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010536e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105372:	74 1c                	je     c0105390 <printnum+0x58>
c0105374:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105377:	ba 00 00 00 00       	mov    $0x0,%edx
c010537c:	f7 75 e4             	divl   -0x1c(%ebp)
c010537f:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0105382:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105385:	ba 00 00 00 00       	mov    $0x0,%edx
c010538a:	f7 75 e4             	divl   -0x1c(%ebp)
c010538d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105390:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105393:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105396:	f7 75 e4             	divl   -0x1c(%ebp)
c0105399:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010539c:	89 55 dc             	mov    %edx,-0x24(%ebp)
c010539f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01053a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01053a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01053a8:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01053ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01053ae:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c01053b1:	8b 45 18             	mov    0x18(%ebp),%eax
c01053b4:	ba 00 00 00 00       	mov    $0x0,%edx
c01053b9:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01053bc:	77 56                	ja     c0105414 <printnum+0xdc>
c01053be:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01053c1:	72 05                	jb     c01053c8 <printnum+0x90>
c01053c3:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01053c6:	77 4c                	ja     c0105414 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c01053c8:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01053cb:	8d 50 ff             	lea    -0x1(%eax),%edx
c01053ce:	8b 45 20             	mov    0x20(%ebp),%eax
c01053d1:	89 44 24 18          	mov    %eax,0x18(%esp)
c01053d5:	89 54 24 14          	mov    %edx,0x14(%esp)
c01053d9:	8b 45 18             	mov    0x18(%ebp),%eax
c01053dc:	89 44 24 10          	mov    %eax,0x10(%esp)
c01053e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01053e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01053e6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01053ea:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01053ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01053f1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01053f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01053f8:	89 04 24             	mov    %eax,(%esp)
c01053fb:	e8 38 ff ff ff       	call   c0105338 <printnum>
c0105400:	eb 1c                	jmp    c010541e <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0105402:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105405:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105409:	8b 45 20             	mov    0x20(%ebp),%eax
c010540c:	89 04 24             	mov    %eax,(%esp)
c010540f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105412:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c0105414:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c0105418:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010541c:	7f e4                	jg     c0105402 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c010541e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105421:	05 dc 6f 10 c0       	add    $0xc0106fdc,%eax
c0105426:	0f b6 00             	movzbl (%eax),%eax
c0105429:	0f be c0             	movsbl %al,%eax
c010542c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010542f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105433:	89 04 24             	mov    %eax,(%esp)
c0105436:	8b 45 08             	mov    0x8(%ebp),%eax
c0105439:	ff d0                	call   *%eax
}
c010543b:	c9                   	leave  
c010543c:	c3                   	ret    

c010543d <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c010543d:	55                   	push   %ebp
c010543e:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105440:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105444:	7e 14                	jle    c010545a <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0105446:	8b 45 08             	mov    0x8(%ebp),%eax
c0105449:	8b 00                	mov    (%eax),%eax
c010544b:	8d 48 08             	lea    0x8(%eax),%ecx
c010544e:	8b 55 08             	mov    0x8(%ebp),%edx
c0105451:	89 0a                	mov    %ecx,(%edx)
c0105453:	8b 50 04             	mov    0x4(%eax),%edx
c0105456:	8b 00                	mov    (%eax),%eax
c0105458:	eb 30                	jmp    c010548a <getuint+0x4d>
    }
    else if (lflag) {
c010545a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010545e:	74 16                	je     c0105476 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0105460:	8b 45 08             	mov    0x8(%ebp),%eax
c0105463:	8b 00                	mov    (%eax),%eax
c0105465:	8d 48 04             	lea    0x4(%eax),%ecx
c0105468:	8b 55 08             	mov    0x8(%ebp),%edx
c010546b:	89 0a                	mov    %ecx,(%edx)
c010546d:	8b 00                	mov    (%eax),%eax
c010546f:	ba 00 00 00 00       	mov    $0x0,%edx
c0105474:	eb 14                	jmp    c010548a <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0105476:	8b 45 08             	mov    0x8(%ebp),%eax
c0105479:	8b 00                	mov    (%eax),%eax
c010547b:	8d 48 04             	lea    0x4(%eax),%ecx
c010547e:	8b 55 08             	mov    0x8(%ebp),%edx
c0105481:	89 0a                	mov    %ecx,(%edx)
c0105483:	8b 00                	mov    (%eax),%eax
c0105485:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c010548a:	5d                   	pop    %ebp
c010548b:	c3                   	ret    

c010548c <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c010548c:	55                   	push   %ebp
c010548d:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010548f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105493:	7e 14                	jle    c01054a9 <getint+0x1d>
        return va_arg(*ap, long long);
c0105495:	8b 45 08             	mov    0x8(%ebp),%eax
c0105498:	8b 00                	mov    (%eax),%eax
c010549a:	8d 48 08             	lea    0x8(%eax),%ecx
c010549d:	8b 55 08             	mov    0x8(%ebp),%edx
c01054a0:	89 0a                	mov    %ecx,(%edx)
c01054a2:	8b 50 04             	mov    0x4(%eax),%edx
c01054a5:	8b 00                	mov    (%eax),%eax
c01054a7:	eb 28                	jmp    c01054d1 <getint+0x45>
    }
    else if (lflag) {
c01054a9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01054ad:	74 12                	je     c01054c1 <getint+0x35>
        return va_arg(*ap, long);
c01054af:	8b 45 08             	mov    0x8(%ebp),%eax
c01054b2:	8b 00                	mov    (%eax),%eax
c01054b4:	8d 48 04             	lea    0x4(%eax),%ecx
c01054b7:	8b 55 08             	mov    0x8(%ebp),%edx
c01054ba:	89 0a                	mov    %ecx,(%edx)
c01054bc:	8b 00                	mov    (%eax),%eax
c01054be:	99                   	cltd   
c01054bf:	eb 10                	jmp    c01054d1 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c01054c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01054c4:	8b 00                	mov    (%eax),%eax
c01054c6:	8d 48 04             	lea    0x4(%eax),%ecx
c01054c9:	8b 55 08             	mov    0x8(%ebp),%edx
c01054cc:	89 0a                	mov    %ecx,(%edx)
c01054ce:	8b 00                	mov    (%eax),%eax
c01054d0:	99                   	cltd   
    }
}
c01054d1:	5d                   	pop    %ebp
c01054d2:	c3                   	ret    

c01054d3 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c01054d3:	55                   	push   %ebp
c01054d4:	89 e5                	mov    %esp,%ebp
c01054d6:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c01054d9:	8d 45 14             	lea    0x14(%ebp),%eax
c01054dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c01054df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01054e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01054e6:	8b 45 10             	mov    0x10(%ebp),%eax
c01054e9:	89 44 24 08          	mov    %eax,0x8(%esp)
c01054ed:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054f0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01054f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01054f7:	89 04 24             	mov    %eax,(%esp)
c01054fa:	e8 02 00 00 00       	call   c0105501 <vprintfmt>
    va_end(ap);
}
c01054ff:	c9                   	leave  
c0105500:	c3                   	ret    

c0105501 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0105501:	55                   	push   %ebp
c0105502:	89 e5                	mov    %esp,%ebp
c0105504:	56                   	push   %esi
c0105505:	53                   	push   %ebx
c0105506:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105509:	eb 18                	jmp    c0105523 <vprintfmt+0x22>
            if (ch == '\0') {
c010550b:	85 db                	test   %ebx,%ebx
c010550d:	75 05                	jne    c0105514 <vprintfmt+0x13>
                return;
c010550f:	e9 d1 03 00 00       	jmp    c01058e5 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c0105514:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105517:	89 44 24 04          	mov    %eax,0x4(%esp)
c010551b:	89 1c 24             	mov    %ebx,(%esp)
c010551e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105521:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105523:	8b 45 10             	mov    0x10(%ebp),%eax
c0105526:	8d 50 01             	lea    0x1(%eax),%edx
c0105529:	89 55 10             	mov    %edx,0x10(%ebp)
c010552c:	0f b6 00             	movzbl (%eax),%eax
c010552f:	0f b6 d8             	movzbl %al,%ebx
c0105532:	83 fb 25             	cmp    $0x25,%ebx
c0105535:	75 d4                	jne    c010550b <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105537:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c010553b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0105542:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105545:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0105548:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010554f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105552:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0105555:	8b 45 10             	mov    0x10(%ebp),%eax
c0105558:	8d 50 01             	lea    0x1(%eax),%edx
c010555b:	89 55 10             	mov    %edx,0x10(%ebp)
c010555e:	0f b6 00             	movzbl (%eax),%eax
c0105561:	0f b6 d8             	movzbl %al,%ebx
c0105564:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0105567:	83 f8 55             	cmp    $0x55,%eax
c010556a:	0f 87 44 03 00 00    	ja     c01058b4 <vprintfmt+0x3b3>
c0105570:	8b 04 85 00 70 10 c0 	mov    -0x3fef9000(,%eax,4),%eax
c0105577:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0105579:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c010557d:	eb d6                	jmp    c0105555 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c010557f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0105583:	eb d0                	jmp    c0105555 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105585:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c010558c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010558f:	89 d0                	mov    %edx,%eax
c0105591:	c1 e0 02             	shl    $0x2,%eax
c0105594:	01 d0                	add    %edx,%eax
c0105596:	01 c0                	add    %eax,%eax
c0105598:	01 d8                	add    %ebx,%eax
c010559a:	83 e8 30             	sub    $0x30,%eax
c010559d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c01055a0:	8b 45 10             	mov    0x10(%ebp),%eax
c01055a3:	0f b6 00             	movzbl (%eax),%eax
c01055a6:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c01055a9:	83 fb 2f             	cmp    $0x2f,%ebx
c01055ac:	7e 0b                	jle    c01055b9 <vprintfmt+0xb8>
c01055ae:	83 fb 39             	cmp    $0x39,%ebx
c01055b1:	7f 06                	jg     c01055b9 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01055b3:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c01055b7:	eb d3                	jmp    c010558c <vprintfmt+0x8b>
            goto process_precision;
c01055b9:	eb 33                	jmp    c01055ee <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c01055bb:	8b 45 14             	mov    0x14(%ebp),%eax
c01055be:	8d 50 04             	lea    0x4(%eax),%edx
c01055c1:	89 55 14             	mov    %edx,0x14(%ebp)
c01055c4:	8b 00                	mov    (%eax),%eax
c01055c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c01055c9:	eb 23                	jmp    c01055ee <vprintfmt+0xed>

        case '.':
            if (width < 0)
c01055cb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01055cf:	79 0c                	jns    c01055dd <vprintfmt+0xdc>
                width = 0;
c01055d1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01055d8:	e9 78 ff ff ff       	jmp    c0105555 <vprintfmt+0x54>
c01055dd:	e9 73 ff ff ff       	jmp    c0105555 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c01055e2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c01055e9:	e9 67 ff ff ff       	jmp    c0105555 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c01055ee:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01055f2:	79 12                	jns    c0105606 <vprintfmt+0x105>
                width = precision, precision = -1;
c01055f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01055f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01055fa:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0105601:	e9 4f ff ff ff       	jmp    c0105555 <vprintfmt+0x54>
c0105606:	e9 4a ff ff ff       	jmp    c0105555 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c010560b:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c010560f:	e9 41 ff ff ff       	jmp    c0105555 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0105614:	8b 45 14             	mov    0x14(%ebp),%eax
c0105617:	8d 50 04             	lea    0x4(%eax),%edx
c010561a:	89 55 14             	mov    %edx,0x14(%ebp)
c010561d:	8b 00                	mov    (%eax),%eax
c010561f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105622:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105626:	89 04 24             	mov    %eax,(%esp)
c0105629:	8b 45 08             	mov    0x8(%ebp),%eax
c010562c:	ff d0                	call   *%eax
            break;
c010562e:	e9 ac 02 00 00       	jmp    c01058df <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0105633:	8b 45 14             	mov    0x14(%ebp),%eax
c0105636:	8d 50 04             	lea    0x4(%eax),%edx
c0105639:	89 55 14             	mov    %edx,0x14(%ebp)
c010563c:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c010563e:	85 db                	test   %ebx,%ebx
c0105640:	79 02                	jns    c0105644 <vprintfmt+0x143>
                err = -err;
c0105642:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0105644:	83 fb 06             	cmp    $0x6,%ebx
c0105647:	7f 0b                	jg     c0105654 <vprintfmt+0x153>
c0105649:	8b 34 9d c0 6f 10 c0 	mov    -0x3fef9040(,%ebx,4),%esi
c0105650:	85 f6                	test   %esi,%esi
c0105652:	75 23                	jne    c0105677 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c0105654:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105658:	c7 44 24 08 ed 6f 10 	movl   $0xc0106fed,0x8(%esp)
c010565f:	c0 
c0105660:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105663:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105667:	8b 45 08             	mov    0x8(%ebp),%eax
c010566a:	89 04 24             	mov    %eax,(%esp)
c010566d:	e8 61 fe ff ff       	call   c01054d3 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0105672:	e9 68 02 00 00       	jmp    c01058df <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c0105677:	89 74 24 0c          	mov    %esi,0xc(%esp)
c010567b:	c7 44 24 08 f6 6f 10 	movl   $0xc0106ff6,0x8(%esp)
c0105682:	c0 
c0105683:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105686:	89 44 24 04          	mov    %eax,0x4(%esp)
c010568a:	8b 45 08             	mov    0x8(%ebp),%eax
c010568d:	89 04 24             	mov    %eax,(%esp)
c0105690:	e8 3e fe ff ff       	call   c01054d3 <printfmt>
            }
            break;
c0105695:	e9 45 02 00 00       	jmp    c01058df <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c010569a:	8b 45 14             	mov    0x14(%ebp),%eax
c010569d:	8d 50 04             	lea    0x4(%eax),%edx
c01056a0:	89 55 14             	mov    %edx,0x14(%ebp)
c01056a3:	8b 30                	mov    (%eax),%esi
c01056a5:	85 f6                	test   %esi,%esi
c01056a7:	75 05                	jne    c01056ae <vprintfmt+0x1ad>
                p = "(null)";
c01056a9:	be f9 6f 10 c0       	mov    $0xc0106ff9,%esi
            }
            if (width > 0 && padc != '-') {
c01056ae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01056b2:	7e 3e                	jle    c01056f2 <vprintfmt+0x1f1>
c01056b4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c01056b8:	74 38                	je     c01056f2 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c01056ba:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c01056bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01056c0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056c4:	89 34 24             	mov    %esi,(%esp)
c01056c7:	e8 15 03 00 00       	call   c01059e1 <strnlen>
c01056cc:	29 c3                	sub    %eax,%ebx
c01056ce:	89 d8                	mov    %ebx,%eax
c01056d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01056d3:	eb 17                	jmp    c01056ec <vprintfmt+0x1eb>
                    putch(padc, putdat);
c01056d5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c01056d9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01056dc:	89 54 24 04          	mov    %edx,0x4(%esp)
c01056e0:	89 04 24             	mov    %eax,(%esp)
c01056e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01056e6:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c01056e8:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01056ec:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01056f0:	7f e3                	jg     c01056d5 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01056f2:	eb 38                	jmp    c010572c <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c01056f4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01056f8:	74 1f                	je     c0105719 <vprintfmt+0x218>
c01056fa:	83 fb 1f             	cmp    $0x1f,%ebx
c01056fd:	7e 05                	jle    c0105704 <vprintfmt+0x203>
c01056ff:	83 fb 7e             	cmp    $0x7e,%ebx
c0105702:	7e 15                	jle    c0105719 <vprintfmt+0x218>
                    putch('?', putdat);
c0105704:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105707:	89 44 24 04          	mov    %eax,0x4(%esp)
c010570b:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0105712:	8b 45 08             	mov    0x8(%ebp),%eax
c0105715:	ff d0                	call   *%eax
c0105717:	eb 0f                	jmp    c0105728 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c0105719:	8b 45 0c             	mov    0xc(%ebp),%eax
c010571c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105720:	89 1c 24             	mov    %ebx,(%esp)
c0105723:	8b 45 08             	mov    0x8(%ebp),%eax
c0105726:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105728:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010572c:	89 f0                	mov    %esi,%eax
c010572e:	8d 70 01             	lea    0x1(%eax),%esi
c0105731:	0f b6 00             	movzbl (%eax),%eax
c0105734:	0f be d8             	movsbl %al,%ebx
c0105737:	85 db                	test   %ebx,%ebx
c0105739:	74 10                	je     c010574b <vprintfmt+0x24a>
c010573b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010573f:	78 b3                	js     c01056f4 <vprintfmt+0x1f3>
c0105741:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0105745:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105749:	79 a9                	jns    c01056f4 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010574b:	eb 17                	jmp    c0105764 <vprintfmt+0x263>
                putch(' ', putdat);
c010574d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105750:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105754:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010575b:	8b 45 08             	mov    0x8(%ebp),%eax
c010575e:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0105760:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105764:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105768:	7f e3                	jg     c010574d <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c010576a:	e9 70 01 00 00       	jmp    c01058df <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c010576f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105772:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105776:	8d 45 14             	lea    0x14(%ebp),%eax
c0105779:	89 04 24             	mov    %eax,(%esp)
c010577c:	e8 0b fd ff ff       	call   c010548c <getint>
c0105781:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105784:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0105787:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010578a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010578d:	85 d2                	test   %edx,%edx
c010578f:	79 26                	jns    c01057b7 <vprintfmt+0x2b6>
                putch('-', putdat);
c0105791:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105794:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105798:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c010579f:	8b 45 08             	mov    0x8(%ebp),%eax
c01057a2:	ff d0                	call   *%eax
                num = -(long long)num;
c01057a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01057aa:	f7 d8                	neg    %eax
c01057ac:	83 d2 00             	adc    $0x0,%edx
c01057af:	f7 da                	neg    %edx
c01057b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01057b4:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c01057b7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01057be:	e9 a8 00 00 00       	jmp    c010586b <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c01057c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01057c6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057ca:	8d 45 14             	lea    0x14(%ebp),%eax
c01057cd:	89 04 24             	mov    %eax,(%esp)
c01057d0:	e8 68 fc ff ff       	call   c010543d <getuint>
c01057d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01057d8:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c01057db:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01057e2:	e9 84 00 00 00       	jmp    c010586b <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c01057e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01057ea:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057ee:	8d 45 14             	lea    0x14(%ebp),%eax
c01057f1:	89 04 24             	mov    %eax,(%esp)
c01057f4:	e8 44 fc ff ff       	call   c010543d <getuint>
c01057f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01057fc:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c01057ff:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105806:	eb 63                	jmp    c010586b <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c0105808:	8b 45 0c             	mov    0xc(%ebp),%eax
c010580b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010580f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0105816:	8b 45 08             	mov    0x8(%ebp),%eax
c0105819:	ff d0                	call   *%eax
            putch('x', putdat);
c010581b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010581e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105822:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0105829:	8b 45 08             	mov    0x8(%ebp),%eax
c010582c:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c010582e:	8b 45 14             	mov    0x14(%ebp),%eax
c0105831:	8d 50 04             	lea    0x4(%eax),%edx
c0105834:	89 55 14             	mov    %edx,0x14(%ebp)
c0105837:	8b 00                	mov    (%eax),%eax
c0105839:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010583c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105843:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c010584a:	eb 1f                	jmp    c010586b <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c010584c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010584f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105853:	8d 45 14             	lea    0x14(%ebp),%eax
c0105856:	89 04 24             	mov    %eax,(%esp)
c0105859:	e8 df fb ff ff       	call   c010543d <getuint>
c010585e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105861:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105864:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c010586b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c010586f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105872:	89 54 24 18          	mov    %edx,0x18(%esp)
c0105876:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105879:	89 54 24 14          	mov    %edx,0x14(%esp)
c010587d:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105881:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105884:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105887:	89 44 24 08          	mov    %eax,0x8(%esp)
c010588b:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010588f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105892:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105896:	8b 45 08             	mov    0x8(%ebp),%eax
c0105899:	89 04 24             	mov    %eax,(%esp)
c010589c:	e8 97 fa ff ff       	call   c0105338 <printnum>
            break;
c01058a1:	eb 3c                	jmp    c01058df <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c01058a3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058a6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058aa:	89 1c 24             	mov    %ebx,(%esp)
c01058ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01058b0:	ff d0                	call   *%eax
            break;
c01058b2:	eb 2b                	jmp    c01058df <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c01058b4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058b7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058bb:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c01058c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01058c5:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c01058c7:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01058cb:	eb 04                	jmp    c01058d1 <vprintfmt+0x3d0>
c01058cd:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01058d1:	8b 45 10             	mov    0x10(%ebp),%eax
c01058d4:	83 e8 01             	sub    $0x1,%eax
c01058d7:	0f b6 00             	movzbl (%eax),%eax
c01058da:	3c 25                	cmp    $0x25,%al
c01058dc:	75 ef                	jne    c01058cd <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c01058de:	90                   	nop
        }
    }
c01058df:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01058e0:	e9 3e fc ff ff       	jmp    c0105523 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c01058e5:	83 c4 40             	add    $0x40,%esp
c01058e8:	5b                   	pop    %ebx
c01058e9:	5e                   	pop    %esi
c01058ea:	5d                   	pop    %ebp
c01058eb:	c3                   	ret    

c01058ec <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c01058ec:	55                   	push   %ebp
c01058ed:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c01058ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058f2:	8b 40 08             	mov    0x8(%eax),%eax
c01058f5:	8d 50 01             	lea    0x1(%eax),%edx
c01058f8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058fb:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c01058fe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105901:	8b 10                	mov    (%eax),%edx
c0105903:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105906:	8b 40 04             	mov    0x4(%eax),%eax
c0105909:	39 c2                	cmp    %eax,%edx
c010590b:	73 12                	jae    c010591f <sprintputch+0x33>
        *b->buf ++ = ch;
c010590d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105910:	8b 00                	mov    (%eax),%eax
c0105912:	8d 48 01             	lea    0x1(%eax),%ecx
c0105915:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105918:	89 0a                	mov    %ecx,(%edx)
c010591a:	8b 55 08             	mov    0x8(%ebp),%edx
c010591d:	88 10                	mov    %dl,(%eax)
    }
}
c010591f:	5d                   	pop    %ebp
c0105920:	c3                   	ret    

c0105921 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105921:	55                   	push   %ebp
c0105922:	89 e5                	mov    %esp,%ebp
c0105924:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105927:	8d 45 14             	lea    0x14(%ebp),%eax
c010592a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c010592d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105930:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105934:	8b 45 10             	mov    0x10(%ebp),%eax
c0105937:	89 44 24 08          	mov    %eax,0x8(%esp)
c010593b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010593e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105942:	8b 45 08             	mov    0x8(%ebp),%eax
c0105945:	89 04 24             	mov    %eax,(%esp)
c0105948:	e8 08 00 00 00       	call   c0105955 <vsnprintf>
c010594d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105950:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105953:	c9                   	leave  
c0105954:	c3                   	ret    

c0105955 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105955:	55                   	push   %ebp
c0105956:	89 e5                	mov    %esp,%ebp
c0105958:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c010595b:	8b 45 08             	mov    0x8(%ebp),%eax
c010595e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105961:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105964:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105967:	8b 45 08             	mov    0x8(%ebp),%eax
c010596a:	01 d0                	add    %edx,%eax
c010596c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010596f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105976:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010597a:	74 0a                	je     c0105986 <vsnprintf+0x31>
c010597c:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010597f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105982:	39 c2                	cmp    %eax,%edx
c0105984:	76 07                	jbe    c010598d <vsnprintf+0x38>
        return -E_INVAL;
c0105986:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c010598b:	eb 2a                	jmp    c01059b7 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c010598d:	8b 45 14             	mov    0x14(%ebp),%eax
c0105990:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105994:	8b 45 10             	mov    0x10(%ebp),%eax
c0105997:	89 44 24 08          	mov    %eax,0x8(%esp)
c010599b:	8d 45 ec             	lea    -0x14(%ebp),%eax
c010599e:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059a2:	c7 04 24 ec 58 10 c0 	movl   $0xc01058ec,(%esp)
c01059a9:	e8 53 fb ff ff       	call   c0105501 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c01059ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01059b1:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c01059b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01059b7:	c9                   	leave  
c01059b8:	c3                   	ret    

c01059b9 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c01059b9:	55                   	push   %ebp
c01059ba:	89 e5                	mov    %esp,%ebp
c01059bc:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01059bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c01059c6:	eb 04                	jmp    c01059cc <strlen+0x13>
        cnt ++;
c01059c8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c01059cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01059cf:	8d 50 01             	lea    0x1(%eax),%edx
c01059d2:	89 55 08             	mov    %edx,0x8(%ebp)
c01059d5:	0f b6 00             	movzbl (%eax),%eax
c01059d8:	84 c0                	test   %al,%al
c01059da:	75 ec                	jne    c01059c8 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c01059dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01059df:	c9                   	leave  
c01059e0:	c3                   	ret    

c01059e1 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c01059e1:	55                   	push   %ebp
c01059e2:	89 e5                	mov    %esp,%ebp
c01059e4:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01059e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c01059ee:	eb 04                	jmp    c01059f4 <strnlen+0x13>
        cnt ++;
c01059f0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c01059f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01059f7:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01059fa:	73 10                	jae    c0105a0c <strnlen+0x2b>
c01059fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01059ff:	8d 50 01             	lea    0x1(%eax),%edx
c0105a02:	89 55 08             	mov    %edx,0x8(%ebp)
c0105a05:	0f b6 00             	movzbl (%eax),%eax
c0105a08:	84 c0                	test   %al,%al
c0105a0a:	75 e4                	jne    c01059f0 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0105a0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105a0f:	c9                   	leave  
c0105a10:	c3                   	ret    

c0105a11 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105a11:	55                   	push   %ebp
c0105a12:	89 e5                	mov    %esp,%ebp
c0105a14:	57                   	push   %edi
c0105a15:	56                   	push   %esi
c0105a16:	83 ec 20             	sub    $0x20,%esp
c0105a19:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105a1f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a22:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105a25:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a2b:	89 d1                	mov    %edx,%ecx
c0105a2d:	89 c2                	mov    %eax,%edx
c0105a2f:	89 ce                	mov    %ecx,%esi
c0105a31:	89 d7                	mov    %edx,%edi
c0105a33:	ac                   	lods   %ds:(%esi),%al
c0105a34:	aa                   	stos   %al,%es:(%edi)
c0105a35:	84 c0                	test   %al,%al
c0105a37:	75 fa                	jne    c0105a33 <strcpy+0x22>
c0105a39:	89 fa                	mov    %edi,%edx
c0105a3b:	89 f1                	mov    %esi,%ecx
c0105a3d:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105a40:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105a43:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105a49:	83 c4 20             	add    $0x20,%esp
c0105a4c:	5e                   	pop    %esi
c0105a4d:	5f                   	pop    %edi
c0105a4e:	5d                   	pop    %ebp
c0105a4f:	c3                   	ret    

c0105a50 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105a50:	55                   	push   %ebp
c0105a51:	89 e5                	mov    %esp,%ebp
c0105a53:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105a56:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a59:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105a5c:	eb 21                	jmp    c0105a7f <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0105a5e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a61:	0f b6 10             	movzbl (%eax),%edx
c0105a64:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105a67:	88 10                	mov    %dl,(%eax)
c0105a69:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105a6c:	0f b6 00             	movzbl (%eax),%eax
c0105a6f:	84 c0                	test   %al,%al
c0105a71:	74 04                	je     c0105a77 <strncpy+0x27>
            src ++;
c0105a73:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105a77:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105a7b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0105a7f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105a83:	75 d9                	jne    c0105a5e <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0105a85:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105a88:	c9                   	leave  
c0105a89:	c3                   	ret    

c0105a8a <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105a8a:	55                   	push   %ebp
c0105a8b:	89 e5                	mov    %esp,%ebp
c0105a8d:	57                   	push   %edi
c0105a8e:	56                   	push   %esi
c0105a8f:	83 ec 20             	sub    $0x20,%esp
c0105a92:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a95:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105a98:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0105a9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105aa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105aa4:	89 d1                	mov    %edx,%ecx
c0105aa6:	89 c2                	mov    %eax,%edx
c0105aa8:	89 ce                	mov    %ecx,%esi
c0105aaa:	89 d7                	mov    %edx,%edi
c0105aac:	ac                   	lods   %ds:(%esi),%al
c0105aad:	ae                   	scas   %es:(%edi),%al
c0105aae:	75 08                	jne    c0105ab8 <strcmp+0x2e>
c0105ab0:	84 c0                	test   %al,%al
c0105ab2:	75 f8                	jne    c0105aac <strcmp+0x22>
c0105ab4:	31 c0                	xor    %eax,%eax
c0105ab6:	eb 04                	jmp    c0105abc <strcmp+0x32>
c0105ab8:	19 c0                	sbb    %eax,%eax
c0105aba:	0c 01                	or     $0x1,%al
c0105abc:	89 fa                	mov    %edi,%edx
c0105abe:	89 f1                	mov    %esi,%ecx
c0105ac0:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105ac3:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105ac6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0105ac9:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105acc:	83 c4 20             	add    $0x20,%esp
c0105acf:	5e                   	pop    %esi
c0105ad0:	5f                   	pop    %edi
c0105ad1:	5d                   	pop    %ebp
c0105ad2:	c3                   	ret    

c0105ad3 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105ad3:	55                   	push   %ebp
c0105ad4:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105ad6:	eb 0c                	jmp    c0105ae4 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0105ad8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105adc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105ae0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105ae4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105ae8:	74 1a                	je     c0105b04 <strncmp+0x31>
c0105aea:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aed:	0f b6 00             	movzbl (%eax),%eax
c0105af0:	84 c0                	test   %al,%al
c0105af2:	74 10                	je     c0105b04 <strncmp+0x31>
c0105af4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105af7:	0f b6 10             	movzbl (%eax),%edx
c0105afa:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105afd:	0f b6 00             	movzbl (%eax),%eax
c0105b00:	38 c2                	cmp    %al,%dl
c0105b02:	74 d4                	je     c0105ad8 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105b04:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b08:	74 18                	je     c0105b22 <strncmp+0x4f>
c0105b0a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b0d:	0f b6 00             	movzbl (%eax),%eax
c0105b10:	0f b6 d0             	movzbl %al,%edx
c0105b13:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b16:	0f b6 00             	movzbl (%eax),%eax
c0105b19:	0f b6 c0             	movzbl %al,%eax
c0105b1c:	29 c2                	sub    %eax,%edx
c0105b1e:	89 d0                	mov    %edx,%eax
c0105b20:	eb 05                	jmp    c0105b27 <strncmp+0x54>
c0105b22:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105b27:	5d                   	pop    %ebp
c0105b28:	c3                   	ret    

c0105b29 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105b29:	55                   	push   %ebp
c0105b2a:	89 e5                	mov    %esp,%ebp
c0105b2c:	83 ec 04             	sub    $0x4,%esp
c0105b2f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b32:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105b35:	eb 14                	jmp    c0105b4b <strchr+0x22>
        if (*s == c) {
c0105b37:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b3a:	0f b6 00             	movzbl (%eax),%eax
c0105b3d:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105b40:	75 05                	jne    c0105b47 <strchr+0x1e>
            return (char *)s;
c0105b42:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b45:	eb 13                	jmp    c0105b5a <strchr+0x31>
        }
        s ++;
c0105b47:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0105b4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b4e:	0f b6 00             	movzbl (%eax),%eax
c0105b51:	84 c0                	test   %al,%al
c0105b53:	75 e2                	jne    c0105b37 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0105b55:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105b5a:	c9                   	leave  
c0105b5b:	c3                   	ret    

c0105b5c <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105b5c:	55                   	push   %ebp
c0105b5d:	89 e5                	mov    %esp,%ebp
c0105b5f:	83 ec 04             	sub    $0x4,%esp
c0105b62:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b65:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105b68:	eb 11                	jmp    c0105b7b <strfind+0x1f>
        if (*s == c) {
c0105b6a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b6d:	0f b6 00             	movzbl (%eax),%eax
c0105b70:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105b73:	75 02                	jne    c0105b77 <strfind+0x1b>
            break;
c0105b75:	eb 0e                	jmp    c0105b85 <strfind+0x29>
        }
        s ++;
c0105b77:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0105b7b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b7e:	0f b6 00             	movzbl (%eax),%eax
c0105b81:	84 c0                	test   %al,%al
c0105b83:	75 e5                	jne    c0105b6a <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c0105b85:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105b88:	c9                   	leave  
c0105b89:	c3                   	ret    

c0105b8a <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105b8a:	55                   	push   %ebp
c0105b8b:	89 e5                	mov    %esp,%ebp
c0105b8d:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105b90:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105b97:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105b9e:	eb 04                	jmp    c0105ba4 <strtol+0x1a>
        s ++;
c0105ba0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105ba4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ba7:	0f b6 00             	movzbl (%eax),%eax
c0105baa:	3c 20                	cmp    $0x20,%al
c0105bac:	74 f2                	je     c0105ba0 <strtol+0x16>
c0105bae:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bb1:	0f b6 00             	movzbl (%eax),%eax
c0105bb4:	3c 09                	cmp    $0x9,%al
c0105bb6:	74 e8                	je     c0105ba0 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0105bb8:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bbb:	0f b6 00             	movzbl (%eax),%eax
c0105bbe:	3c 2b                	cmp    $0x2b,%al
c0105bc0:	75 06                	jne    c0105bc8 <strtol+0x3e>
        s ++;
c0105bc2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105bc6:	eb 15                	jmp    c0105bdd <strtol+0x53>
    }
    else if (*s == '-') {
c0105bc8:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bcb:	0f b6 00             	movzbl (%eax),%eax
c0105bce:	3c 2d                	cmp    $0x2d,%al
c0105bd0:	75 0b                	jne    c0105bdd <strtol+0x53>
        s ++, neg = 1;
c0105bd2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105bd6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105bdd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105be1:	74 06                	je     c0105be9 <strtol+0x5f>
c0105be3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105be7:	75 24                	jne    c0105c0d <strtol+0x83>
c0105be9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bec:	0f b6 00             	movzbl (%eax),%eax
c0105bef:	3c 30                	cmp    $0x30,%al
c0105bf1:	75 1a                	jne    c0105c0d <strtol+0x83>
c0105bf3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bf6:	83 c0 01             	add    $0x1,%eax
c0105bf9:	0f b6 00             	movzbl (%eax),%eax
c0105bfc:	3c 78                	cmp    $0x78,%al
c0105bfe:	75 0d                	jne    c0105c0d <strtol+0x83>
        s += 2, base = 16;
c0105c00:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105c04:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105c0b:	eb 2a                	jmp    c0105c37 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0105c0d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c11:	75 17                	jne    c0105c2a <strtol+0xa0>
c0105c13:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c16:	0f b6 00             	movzbl (%eax),%eax
c0105c19:	3c 30                	cmp    $0x30,%al
c0105c1b:	75 0d                	jne    c0105c2a <strtol+0xa0>
        s ++, base = 8;
c0105c1d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105c21:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105c28:	eb 0d                	jmp    c0105c37 <strtol+0xad>
    }
    else if (base == 0) {
c0105c2a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c2e:	75 07                	jne    c0105c37 <strtol+0xad>
        base = 10;
c0105c30:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105c37:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c3a:	0f b6 00             	movzbl (%eax),%eax
c0105c3d:	3c 2f                	cmp    $0x2f,%al
c0105c3f:	7e 1b                	jle    c0105c5c <strtol+0xd2>
c0105c41:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c44:	0f b6 00             	movzbl (%eax),%eax
c0105c47:	3c 39                	cmp    $0x39,%al
c0105c49:	7f 11                	jg     c0105c5c <strtol+0xd2>
            dig = *s - '0';
c0105c4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c4e:	0f b6 00             	movzbl (%eax),%eax
c0105c51:	0f be c0             	movsbl %al,%eax
c0105c54:	83 e8 30             	sub    $0x30,%eax
c0105c57:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105c5a:	eb 48                	jmp    c0105ca4 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105c5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c5f:	0f b6 00             	movzbl (%eax),%eax
c0105c62:	3c 60                	cmp    $0x60,%al
c0105c64:	7e 1b                	jle    c0105c81 <strtol+0xf7>
c0105c66:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c69:	0f b6 00             	movzbl (%eax),%eax
c0105c6c:	3c 7a                	cmp    $0x7a,%al
c0105c6e:	7f 11                	jg     c0105c81 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0105c70:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c73:	0f b6 00             	movzbl (%eax),%eax
c0105c76:	0f be c0             	movsbl %al,%eax
c0105c79:	83 e8 57             	sub    $0x57,%eax
c0105c7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105c7f:	eb 23                	jmp    c0105ca4 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105c81:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c84:	0f b6 00             	movzbl (%eax),%eax
c0105c87:	3c 40                	cmp    $0x40,%al
c0105c89:	7e 3d                	jle    c0105cc8 <strtol+0x13e>
c0105c8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c8e:	0f b6 00             	movzbl (%eax),%eax
c0105c91:	3c 5a                	cmp    $0x5a,%al
c0105c93:	7f 33                	jg     c0105cc8 <strtol+0x13e>
            dig = *s - 'A' + 10;
c0105c95:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c98:	0f b6 00             	movzbl (%eax),%eax
c0105c9b:	0f be c0             	movsbl %al,%eax
c0105c9e:	83 e8 37             	sub    $0x37,%eax
c0105ca1:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ca7:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105caa:	7c 02                	jl     c0105cae <strtol+0x124>
            break;
c0105cac:	eb 1a                	jmp    c0105cc8 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0105cae:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105cb2:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105cb5:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105cb9:	89 c2                	mov    %eax,%edx
c0105cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105cbe:	01 d0                	add    %edx,%eax
c0105cc0:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0105cc3:	e9 6f ff ff ff       	jmp    c0105c37 <strtol+0xad>

    if (endptr) {
c0105cc8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105ccc:	74 08                	je     c0105cd6 <strtol+0x14c>
        *endptr = (char *) s;
c0105cce:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cd1:	8b 55 08             	mov    0x8(%ebp),%edx
c0105cd4:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105cd6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105cda:	74 07                	je     c0105ce3 <strtol+0x159>
c0105cdc:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105cdf:	f7 d8                	neg    %eax
c0105ce1:	eb 03                	jmp    c0105ce6 <strtol+0x15c>
c0105ce3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105ce6:	c9                   	leave  
c0105ce7:	c3                   	ret    

c0105ce8 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105ce8:	55                   	push   %ebp
c0105ce9:	89 e5                	mov    %esp,%ebp
c0105ceb:	57                   	push   %edi
c0105cec:	83 ec 24             	sub    $0x24,%esp
c0105cef:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cf2:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105cf5:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0105cf9:	8b 55 08             	mov    0x8(%ebp),%edx
c0105cfc:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105cff:	88 45 f7             	mov    %al,-0x9(%ebp)
c0105d02:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d05:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105d08:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105d0b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105d0f:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105d12:	89 d7                	mov    %edx,%edi
c0105d14:	f3 aa                	rep stos %al,%es:(%edi)
c0105d16:	89 fa                	mov    %edi,%edx
c0105d18:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105d1b:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105d1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105d21:	83 c4 24             	add    $0x24,%esp
c0105d24:	5f                   	pop    %edi
c0105d25:	5d                   	pop    %ebp
c0105d26:	c3                   	ret    

c0105d27 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105d27:	55                   	push   %ebp
c0105d28:	89 e5                	mov    %esp,%ebp
c0105d2a:	57                   	push   %edi
c0105d2b:	56                   	push   %esi
c0105d2c:	53                   	push   %ebx
c0105d2d:	83 ec 30             	sub    $0x30,%esp
c0105d30:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d33:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105d36:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d39:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105d3c:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d3f:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105d42:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d45:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105d48:	73 42                	jae    c0105d8c <memmove+0x65>
c0105d4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d4d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105d50:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105d53:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105d56:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105d59:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105d5c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105d5f:	c1 e8 02             	shr    $0x2,%eax
c0105d62:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105d64:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105d67:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105d6a:	89 d7                	mov    %edx,%edi
c0105d6c:	89 c6                	mov    %eax,%esi
c0105d6e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105d70:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105d73:	83 e1 03             	and    $0x3,%ecx
c0105d76:	74 02                	je     c0105d7a <memmove+0x53>
c0105d78:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105d7a:	89 f0                	mov    %esi,%eax
c0105d7c:	89 fa                	mov    %edi,%edx
c0105d7e:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105d81:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105d84:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105d87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105d8a:	eb 36                	jmp    c0105dc2 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105d8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105d8f:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105d92:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105d95:	01 c2                	add    %eax,%edx
c0105d97:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105d9a:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105d9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105da0:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0105da3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105da6:	89 c1                	mov    %eax,%ecx
c0105da8:	89 d8                	mov    %ebx,%eax
c0105daa:	89 d6                	mov    %edx,%esi
c0105dac:	89 c7                	mov    %eax,%edi
c0105dae:	fd                   	std    
c0105daf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105db1:	fc                   	cld    
c0105db2:	89 f8                	mov    %edi,%eax
c0105db4:	89 f2                	mov    %esi,%edx
c0105db6:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105db9:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105dbc:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0105dbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105dc2:	83 c4 30             	add    $0x30,%esp
c0105dc5:	5b                   	pop    %ebx
c0105dc6:	5e                   	pop    %esi
c0105dc7:	5f                   	pop    %edi
c0105dc8:	5d                   	pop    %ebp
c0105dc9:	c3                   	ret    

c0105dca <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105dca:	55                   	push   %ebp
c0105dcb:	89 e5                	mov    %esp,%ebp
c0105dcd:	57                   	push   %edi
c0105dce:	56                   	push   %esi
c0105dcf:	83 ec 20             	sub    $0x20,%esp
c0105dd2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105dd8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ddb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105dde:	8b 45 10             	mov    0x10(%ebp),%eax
c0105de1:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105de4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105de7:	c1 e8 02             	shr    $0x2,%eax
c0105dea:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105dec:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105def:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105df2:	89 d7                	mov    %edx,%edi
c0105df4:	89 c6                	mov    %eax,%esi
c0105df6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105df8:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105dfb:	83 e1 03             	and    $0x3,%ecx
c0105dfe:	74 02                	je     c0105e02 <memcpy+0x38>
c0105e00:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105e02:	89 f0                	mov    %esi,%eax
c0105e04:	89 fa                	mov    %edi,%edx
c0105e06:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105e09:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105e0c:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105e0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105e12:	83 c4 20             	add    $0x20,%esp
c0105e15:	5e                   	pop    %esi
c0105e16:	5f                   	pop    %edi
c0105e17:	5d                   	pop    %ebp
c0105e18:	c3                   	ret    

c0105e19 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105e19:	55                   	push   %ebp
c0105e1a:	89 e5                	mov    %esp,%ebp
c0105e1c:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105e1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e22:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105e25:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e28:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105e2b:	eb 30                	jmp    c0105e5d <memcmp+0x44>
        if (*s1 != *s2) {
c0105e2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105e30:	0f b6 10             	movzbl (%eax),%edx
c0105e33:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105e36:	0f b6 00             	movzbl (%eax),%eax
c0105e39:	38 c2                	cmp    %al,%dl
c0105e3b:	74 18                	je     c0105e55 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105e3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105e40:	0f b6 00             	movzbl (%eax),%eax
c0105e43:	0f b6 d0             	movzbl %al,%edx
c0105e46:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105e49:	0f b6 00             	movzbl (%eax),%eax
c0105e4c:	0f b6 c0             	movzbl %al,%eax
c0105e4f:	29 c2                	sub    %eax,%edx
c0105e51:	89 d0                	mov    %edx,%eax
c0105e53:	eb 1a                	jmp    c0105e6f <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0105e55:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105e59:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0105e5d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e60:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105e63:	89 55 10             	mov    %edx,0x10(%ebp)
c0105e66:	85 c0                	test   %eax,%eax
c0105e68:	75 c3                	jne    c0105e2d <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0105e6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105e6f:	c9                   	leave  
c0105e70:	c3                   	ret    
