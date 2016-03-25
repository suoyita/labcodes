
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
  100000:	0f 01 15 18 70 11 40 	lgdtl  0x40117018
    movl $KERNEL_DS, %eax
  100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
  100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
  100012:	ea 19 00 10 00 08 00 	ljmp   $0x8,$0x100019

00100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
  100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10001e:	bc 00 70 11 00       	mov    $0x117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  100023:	e8 02 00 00 00       	call   10002a <kern_init>

00100028 <spin>:

# should never get here
spin:
    jmp spin
  100028:	eb fe                	jmp    100028 <spin>

0010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  10002a:	55                   	push   %ebp
  10002b:	89 e5                	mov    %esp,%ebp
  10002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100030:	ba 68 89 11 00       	mov    $0x118968,%edx
  100035:	b8 36 7a 11 00       	mov    $0x117a36,%eax
  10003a:	29 c2                	sub    %eax,%edx
  10003c:	89 d0                	mov    %edx,%eax
  10003e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100049:	00 
  10004a:	c7 04 24 36 7a 11 00 	movl   $0x117a36,(%esp)
  100051:	e8 92 5c 00 00       	call   105ce8 <memset>

    cons_init();                // init the console
  100056:	e8 70 15 00 00       	call   1015cb <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10005b:	c7 45 f4 80 5e 10 00 	movl   $0x105e80,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100065:	89 44 24 04          	mov    %eax,0x4(%esp)
  100069:	c7 04 24 9c 5e 10 00 	movl   $0x105e9c,(%esp)
  100070:	e8 c7 02 00 00       	call   10033c <cprintf>

    print_kerninfo();
  100075:	e8 f6 07 00 00       	call   100870 <print_kerninfo>

    grade_backtrace();
  10007a:	e8 86 00 00 00       	call   100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10007f:	e8 6d 41 00 00       	call   1041f1 <pmm_init>

    pic_init();                 // init interrupt controller
  100084:	e8 ab 16 00 00       	call   101734 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100089:	e8 fd 17 00 00       	call   10188b <idt_init>

    clock_init();               // init clock interrupt
  10008e:	e8 ee 0c 00 00       	call   100d81 <clock_init>
    intr_enable();              // enable irq interrupt
  100093:	e8 0a 16 00 00       	call   1016a2 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  100098:	eb fe                	jmp    100098 <kern_init+0x6e>

0010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10009a:	55                   	push   %ebp
  10009b:	89 e5                	mov    %esp,%ebp
  10009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000a7:	00 
  1000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000af:	00 
  1000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000b7:	e8 f7 0b 00 00       	call   100cb3 <mon_backtrace>
}
  1000bc:	c9                   	leave  
  1000bd:	c3                   	ret    

001000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000be:	55                   	push   %ebp
  1000bf:	89 e5                	mov    %esp,%ebp
  1000c1:	53                   	push   %ebx
  1000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000cb:	8d 55 08             	lea    0x8(%ebp),%edx
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000dd:	89 04 24             	mov    %eax,(%esp)
  1000e0:	e8 b5 ff ff ff       	call   10009a <grade_backtrace2>
}
  1000e5:	83 c4 14             	add    $0x14,%esp
  1000e8:	5b                   	pop    %ebx
  1000e9:	5d                   	pop    %ebp
  1000ea:	c3                   	ret    

001000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000eb:	55                   	push   %ebp
  1000ec:	89 e5                	mov    %esp,%ebp
  1000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000f1:	8b 45 10             	mov    0x10(%ebp),%eax
  1000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1000fb:	89 04 24             	mov    %eax,(%esp)
  1000fe:	e8 bb ff ff ff       	call   1000be <grade_backtrace1>
}
  100103:	c9                   	leave  
  100104:	c3                   	ret    

00100105 <grade_backtrace>:

void
grade_backtrace(void) {
  100105:	55                   	push   %ebp
  100106:	89 e5                	mov    %esp,%ebp
  100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10010b:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100117:	ff 
  100118:	89 44 24 04          	mov    %eax,0x4(%esp)
  10011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100123:	e8 c3 ff ff ff       	call   1000eb <grade_backtrace0>
}
  100128:	c9                   	leave  
  100129:	c3                   	ret    

0010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10012a:	55                   	push   %ebp
  10012b:	89 e5                	mov    %esp,%ebp
  10012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100140:	0f b7 c0             	movzwl %ax,%eax
  100143:	83 e0 03             	and    $0x3,%eax
  100146:	89 c2                	mov    %eax,%edx
  100148:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10014d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100151:	89 44 24 04          	mov    %eax,0x4(%esp)
  100155:	c7 04 24 a1 5e 10 00 	movl   $0x105ea1,(%esp)
  10015c:	e8 db 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100165:	0f b7 d0             	movzwl %ax,%edx
  100168:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10016d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100171:	89 44 24 04          	mov    %eax,0x4(%esp)
  100175:	c7 04 24 af 5e 10 00 	movl   $0x105eaf,(%esp)
  10017c:	e8 bb 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100185:	0f b7 d0             	movzwl %ax,%edx
  100188:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10018d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100191:	89 44 24 04          	mov    %eax,0x4(%esp)
  100195:	c7 04 24 bd 5e 10 00 	movl   $0x105ebd,(%esp)
  10019c:	e8 9b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001a5:	0f b7 d0             	movzwl %ax,%edx
  1001a8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b5:	c7 04 24 cb 5e 10 00 	movl   $0x105ecb,(%esp)
  1001bc:	e8 7b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001c5:	0f b7 d0             	movzwl %ax,%edx
  1001c8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d5:	c7 04 24 d9 5e 10 00 	movl   $0x105ed9,(%esp)
  1001dc:	e8 5b 01 00 00       	call   10033c <cprintf>
    round ++;
  1001e1:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001e6:	83 c0 01             	add    $0x1,%eax
  1001e9:	a3 40 7a 11 00       	mov    %eax,0x117a40
}
  1001ee:	c9                   	leave  
  1001ef:	c3                   	ret    

001001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001f0:	55                   	push   %ebp
  1001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001f3:	5d                   	pop    %ebp
  1001f4:	c3                   	ret    

001001f5 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001f5:	55                   	push   %ebp
  1001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001f8:	5d                   	pop    %ebp
  1001f9:	c3                   	ret    

001001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001fa:	55                   	push   %ebp
  1001fb:	89 e5                	mov    %esp,%ebp
  1001fd:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100200:	e8 25 ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100205:	c7 04 24 e8 5e 10 00 	movl   $0x105ee8,(%esp)
  10020c:	e8 2b 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_user();
  100211:	e8 da ff ff ff       	call   1001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
  100216:	e8 0f ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10021b:	c7 04 24 08 5f 10 00 	movl   $0x105f08,(%esp)
  100222:	e8 15 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_kernel();
  100227:	e8 c9 ff ff ff       	call   1001f5 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  10022c:	e8 f9 fe ff ff       	call   10012a <lab1_print_cur_status>
}
  100231:	c9                   	leave  
  100232:	c3                   	ret    

00100233 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100233:	55                   	push   %ebp
  100234:	89 e5                	mov    %esp,%ebp
  100236:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10023d:	74 13                	je     100252 <readline+0x1f>
        cprintf("%s", prompt);
  10023f:	8b 45 08             	mov    0x8(%ebp),%eax
  100242:	89 44 24 04          	mov    %eax,0x4(%esp)
  100246:	c7 04 24 27 5f 10 00 	movl   $0x105f27,(%esp)
  10024d:	e8 ea 00 00 00       	call   10033c <cprintf>
    }
    int i = 0, c;
  100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100259:	e8 66 01 00 00       	call   1003c4 <getchar>
  10025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100265:	79 07                	jns    10026e <readline+0x3b>
            return NULL;
  100267:	b8 00 00 00 00       	mov    $0x0,%eax
  10026c:	eb 79                	jmp    1002e7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10026e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100272:	7e 28                	jle    10029c <readline+0x69>
  100274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10027b:	7f 1f                	jg     10029c <readline+0x69>
            cputchar(c);
  10027d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100280:	89 04 24             	mov    %eax,(%esp)
  100283:	e8 da 00 00 00       	call   100362 <cputchar>
            buf[i ++] = c;
  100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10028b:	8d 50 01             	lea    0x1(%eax),%edx
  10028e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100291:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100294:	88 90 60 7a 11 00    	mov    %dl,0x117a60(%eax)
  10029a:	eb 46                	jmp    1002e2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  10029c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1002a0:	75 17                	jne    1002b9 <readline+0x86>
  1002a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002a6:	7e 11                	jle    1002b9 <readline+0x86>
            cputchar(c);
  1002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002ab:	89 04 24             	mov    %eax,(%esp)
  1002ae:	e8 af 00 00 00       	call   100362 <cputchar>
            i --;
  1002b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1002b7:	eb 29                	jmp    1002e2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  1002b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002bd:	74 06                	je     1002c5 <readline+0x92>
  1002bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002c3:	75 1d                	jne    1002e2 <readline+0xaf>
            cputchar(c);
  1002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002c8:	89 04 24             	mov    %eax,(%esp)
  1002cb:	e8 92 00 00 00       	call   100362 <cputchar>
            buf[i] = '\0';
  1002d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002d3:	05 60 7a 11 00       	add    $0x117a60,%eax
  1002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002db:	b8 60 7a 11 00       	mov    $0x117a60,%eax
  1002e0:	eb 05                	jmp    1002e7 <readline+0xb4>
        }
    }
  1002e2:	e9 72 ff ff ff       	jmp    100259 <readline+0x26>
}
  1002e7:	c9                   	leave  
  1002e8:	c3                   	ret    

001002e9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002e9:	55                   	push   %ebp
  1002ea:	89 e5                	mov    %esp,%ebp
  1002ec:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f2:	89 04 24             	mov    %eax,(%esp)
  1002f5:	e8 fd 12 00 00       	call   1015f7 <cons_putc>
    (*cnt) ++;
  1002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002fd:	8b 00                	mov    (%eax),%eax
  1002ff:	8d 50 01             	lea    0x1(%eax),%edx
  100302:	8b 45 0c             	mov    0xc(%ebp),%eax
  100305:	89 10                	mov    %edx,(%eax)
}
  100307:	c9                   	leave  
  100308:	c3                   	ret    

00100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100309:	55                   	push   %ebp
  10030a:	89 e5                	mov    %esp,%ebp
  10030c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100316:	8b 45 0c             	mov    0xc(%ebp),%eax
  100319:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10031d:	8b 45 08             	mov    0x8(%ebp),%eax
  100320:	89 44 24 08          	mov    %eax,0x8(%esp)
  100324:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100327:	89 44 24 04          	mov    %eax,0x4(%esp)
  10032b:	c7 04 24 e9 02 10 00 	movl   $0x1002e9,(%esp)
  100332:	e8 ca 51 00 00       	call   105501 <vprintfmt>
    return cnt;
  100337:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10033a:	c9                   	leave  
  10033b:	c3                   	ret    

0010033c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10033c:	55                   	push   %ebp
  10033d:	89 e5                	mov    %esp,%ebp
  10033f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100342:	8d 45 0c             	lea    0xc(%ebp),%eax
  100345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10034b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10034f:	8b 45 08             	mov    0x8(%ebp),%eax
  100352:	89 04 24             	mov    %eax,(%esp)
  100355:	e8 af ff ff ff       	call   100309 <vcprintf>
  10035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100360:	c9                   	leave  
  100361:	c3                   	ret    

00100362 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100362:	55                   	push   %ebp
  100363:	89 e5                	mov    %esp,%ebp
  100365:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100368:	8b 45 08             	mov    0x8(%ebp),%eax
  10036b:	89 04 24             	mov    %eax,(%esp)
  10036e:	e8 84 12 00 00       	call   1015f7 <cons_putc>
}
  100373:	c9                   	leave  
  100374:	c3                   	ret    

00100375 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100375:	55                   	push   %ebp
  100376:	89 e5                	mov    %esp,%ebp
  100378:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100382:	eb 13                	jmp    100397 <cputs+0x22>
        cputch(c, &cnt);
  100384:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100388:	8d 55 f0             	lea    -0x10(%ebp),%edx
  10038b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10038f:	89 04 24             	mov    %eax,(%esp)
  100392:	e8 52 ff ff ff       	call   1002e9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  100397:	8b 45 08             	mov    0x8(%ebp),%eax
  10039a:	8d 50 01             	lea    0x1(%eax),%edx
  10039d:	89 55 08             	mov    %edx,0x8(%ebp)
  1003a0:	0f b6 00             	movzbl (%eax),%eax
  1003a3:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003a6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003aa:	75 d8                	jne    100384 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1003ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003ba:	e8 2a ff ff ff       	call   1002e9 <cputch>
    return cnt;
  1003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003c2:	c9                   	leave  
  1003c3:	c3                   	ret    

001003c4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003c4:	55                   	push   %ebp
  1003c5:	89 e5                	mov    %esp,%ebp
  1003c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003ca:	e8 64 12 00 00       	call   101633 <cons_getc>
  1003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003d6:	74 f2                	je     1003ca <getchar+0x6>
        /* do nothing */;
    return c;
  1003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003db:	c9                   	leave  
  1003dc:	c3                   	ret    

001003dd <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003dd:	55                   	push   %ebp
  1003de:	89 e5                	mov    %esp,%ebp
  1003e0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003e6:	8b 00                	mov    (%eax),%eax
  1003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1003ee:	8b 00                	mov    (%eax),%eax
  1003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003fa:	e9 d2 00 00 00       	jmp    1004d1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100402:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100405:	01 d0                	add    %edx,%eax
  100407:	89 c2                	mov    %eax,%edx
  100409:	c1 ea 1f             	shr    $0x1f,%edx
  10040c:	01 d0                	add    %edx,%eax
  10040e:	d1 f8                	sar    %eax
  100410:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100413:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100416:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100419:	eb 04                	jmp    10041f <stab_binsearch+0x42>
            m --;
  10041b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100422:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100425:	7c 1f                	jl     100446 <stab_binsearch+0x69>
  100427:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10042a:	89 d0                	mov    %edx,%eax
  10042c:	01 c0                	add    %eax,%eax
  10042e:	01 d0                	add    %edx,%eax
  100430:	c1 e0 02             	shl    $0x2,%eax
  100433:	89 c2                	mov    %eax,%edx
  100435:	8b 45 08             	mov    0x8(%ebp),%eax
  100438:	01 d0                	add    %edx,%eax
  10043a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10043e:	0f b6 c0             	movzbl %al,%eax
  100441:	3b 45 14             	cmp    0x14(%ebp),%eax
  100444:	75 d5                	jne    10041b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  100446:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100449:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10044c:	7d 0b                	jge    100459 <stab_binsearch+0x7c>
            l = true_m + 1;
  10044e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100451:	83 c0 01             	add    $0x1,%eax
  100454:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100457:	eb 78                	jmp    1004d1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100459:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100460:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100463:	89 d0                	mov    %edx,%eax
  100465:	01 c0                	add    %eax,%eax
  100467:	01 d0                	add    %edx,%eax
  100469:	c1 e0 02             	shl    $0x2,%eax
  10046c:	89 c2                	mov    %eax,%edx
  10046e:	8b 45 08             	mov    0x8(%ebp),%eax
  100471:	01 d0                	add    %edx,%eax
  100473:	8b 40 08             	mov    0x8(%eax),%eax
  100476:	3b 45 18             	cmp    0x18(%ebp),%eax
  100479:	73 13                	jae    10048e <stab_binsearch+0xb1>
            *region_left = m;
  10047b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10047e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100481:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100483:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100486:	83 c0 01             	add    $0x1,%eax
  100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10048c:	eb 43                	jmp    1004d1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  10048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100491:	89 d0                	mov    %edx,%eax
  100493:	01 c0                	add    %eax,%eax
  100495:	01 d0                	add    %edx,%eax
  100497:	c1 e0 02             	shl    $0x2,%eax
  10049a:	89 c2                	mov    %eax,%edx
  10049c:	8b 45 08             	mov    0x8(%ebp),%eax
  10049f:	01 d0                	add    %edx,%eax
  1004a1:	8b 40 08             	mov    0x8(%eax),%eax
  1004a4:	3b 45 18             	cmp    0x18(%ebp),%eax
  1004a7:	76 16                	jbe    1004bf <stab_binsearch+0xe2>
            *region_right = m - 1;
  1004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004af:	8b 45 10             	mov    0x10(%ebp),%eax
  1004b2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b7:	83 e8 01             	sub    $0x1,%eax
  1004ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004bd:	eb 12                	jmp    1004d1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004c5:	89 10                	mov    %edx,(%eax)
            l = m;
  1004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004cd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004d7:	0f 8e 22 ff ff ff    	jle    1003ff <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004e1:	75 0f                	jne    1004f2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004e6:	8b 00                	mov    (%eax),%eax
  1004e8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1004ee:	89 10                	mov    %edx,(%eax)
  1004f0:	eb 3f                	jmp    100531 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004f2:	8b 45 10             	mov    0x10(%ebp),%eax
  1004f5:	8b 00                	mov    (%eax),%eax
  1004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004fa:	eb 04                	jmp    100500 <stab_binsearch+0x123>
  1004fc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  100500:	8b 45 0c             	mov    0xc(%ebp),%eax
  100503:	8b 00                	mov    (%eax),%eax
  100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100508:	7d 1f                	jge    100529 <stab_binsearch+0x14c>
  10050a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10050d:	89 d0                	mov    %edx,%eax
  10050f:	01 c0                	add    %eax,%eax
  100511:	01 d0                	add    %edx,%eax
  100513:	c1 e0 02             	shl    $0x2,%eax
  100516:	89 c2                	mov    %eax,%edx
  100518:	8b 45 08             	mov    0x8(%ebp),%eax
  10051b:	01 d0                	add    %edx,%eax
  10051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100521:	0f b6 c0             	movzbl %al,%eax
  100524:	3b 45 14             	cmp    0x14(%ebp),%eax
  100527:	75 d3                	jne    1004fc <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  100529:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10052f:	89 10                	mov    %edx,(%eax)
    }
}
  100531:	c9                   	leave  
  100532:	c3                   	ret    

00100533 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100533:	55                   	push   %ebp
  100534:	89 e5                	mov    %esp,%ebp
  100536:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100539:	8b 45 0c             	mov    0xc(%ebp),%eax
  10053c:	c7 00 2c 5f 10 00    	movl   $0x105f2c,(%eax)
    info->eip_line = 0;
  100542:	8b 45 0c             	mov    0xc(%ebp),%eax
  100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10054c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10054f:	c7 40 08 2c 5f 10 00 	movl   $0x105f2c,0x8(%eax)
    info->eip_fn_namelen = 9;
  100556:	8b 45 0c             	mov    0xc(%ebp),%eax
  100559:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100560:	8b 45 0c             	mov    0xc(%ebp),%eax
  100563:	8b 55 08             	mov    0x8(%ebp),%edx
  100566:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100569:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100573:	c7 45 f4 58 71 10 00 	movl   $0x107158,-0xc(%ebp)
    stab_end = __STAB_END__;
  10057a:	c7 45 f0 18 1d 11 00 	movl   $0x111d18,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100581:	c7 45 ec 19 1d 11 00 	movl   $0x111d19,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100588:	c7 45 e8 47 47 11 00 	movl   $0x114747,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100595:	76 0d                	jbe    1005a4 <debuginfo_eip+0x71>
  100597:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10059a:	83 e8 01             	sub    $0x1,%eax
  10059d:	0f b6 00             	movzbl (%eax),%eax
  1005a0:	84 c0                	test   %al,%al
  1005a2:	74 0a                	je     1005ae <debuginfo_eip+0x7b>
        return -1;
  1005a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005a9:	e9 c0 02 00 00       	jmp    10086e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005bb:	29 c2                	sub    %eax,%edx
  1005bd:	89 d0                	mov    %edx,%eax
  1005bf:	c1 f8 02             	sar    $0x2,%eax
  1005c2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005c8:	83 e8 01             	sub    $0x1,%eax
  1005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1005d1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005d5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005dc:	00 
  1005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005ee:	89 04 24             	mov    %eax,(%esp)
  1005f1:	e8 e7 fd ff ff       	call   1003dd <stab_binsearch>
    if (lfile == 0)
  1005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005f9:	85 c0                	test   %eax,%eax
  1005fb:	75 0a                	jne    100607 <debuginfo_eip+0xd4>
        return -1;
  1005fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100602:	e9 67 02 00 00       	jmp    10086e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100610:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100613:	8b 45 08             	mov    0x8(%ebp),%eax
  100616:	89 44 24 10          	mov    %eax,0x10(%esp)
  10061a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100621:	00 
  100622:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100625:	89 44 24 08          	mov    %eax,0x8(%esp)
  100629:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10062c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100633:	89 04 24             	mov    %eax,(%esp)
  100636:	e8 a2 fd ff ff       	call   1003dd <stab_binsearch>

    if (lfun <= rfun) {
  10063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10063e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100641:	39 c2                	cmp    %eax,%edx
  100643:	7f 7c                	jg     1006c1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100648:	89 c2                	mov    %eax,%edx
  10064a:	89 d0                	mov    %edx,%eax
  10064c:	01 c0                	add    %eax,%eax
  10064e:	01 d0                	add    %edx,%eax
  100650:	c1 e0 02             	shl    $0x2,%eax
  100653:	89 c2                	mov    %eax,%edx
  100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100658:	01 d0                	add    %edx,%eax
  10065a:	8b 10                	mov    (%eax),%edx
  10065c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100662:	29 c1                	sub    %eax,%ecx
  100664:	89 c8                	mov    %ecx,%eax
  100666:	39 c2                	cmp    %eax,%edx
  100668:	73 22                	jae    10068c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10066d:	89 c2                	mov    %eax,%edx
  10066f:	89 d0                	mov    %edx,%eax
  100671:	01 c0                	add    %eax,%eax
  100673:	01 d0                	add    %edx,%eax
  100675:	c1 e0 02             	shl    $0x2,%eax
  100678:	89 c2                	mov    %eax,%edx
  10067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10067d:	01 d0                	add    %edx,%eax
  10067f:	8b 10                	mov    (%eax),%edx
  100681:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100684:	01 c2                	add    %eax,%edx
  100686:	8b 45 0c             	mov    0xc(%ebp),%eax
  100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10068f:	89 c2                	mov    %eax,%edx
  100691:	89 d0                	mov    %edx,%eax
  100693:	01 c0                	add    %eax,%eax
  100695:	01 d0                	add    %edx,%eax
  100697:	c1 e0 02             	shl    $0x2,%eax
  10069a:	89 c2                	mov    %eax,%edx
  10069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10069f:	01 d0                	add    %edx,%eax
  1006a1:	8b 50 08             	mov    0x8(%eax),%edx
  1006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006a7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006ad:	8b 40 10             	mov    0x10(%eax),%eax
  1006b0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1006b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006bf:	eb 15                	jmp    1006d6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c4:	8b 55 08             	mov    0x8(%ebp),%edx
  1006c7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d9:	8b 40 08             	mov    0x8(%eax),%eax
  1006dc:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006e3:	00 
  1006e4:	89 04 24             	mov    %eax,(%esp)
  1006e7:	e8 70 54 00 00       	call   105b5c <strfind>
  1006ec:	89 c2                	mov    %eax,%edx
  1006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f1:	8b 40 08             	mov    0x8(%eax),%eax
  1006f4:	29 c2                	sub    %eax,%edx
  1006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
  100703:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  10070a:	00 
  10070b:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10070e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100712:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100715:	89 44 24 04          	mov    %eax,0x4(%esp)
  100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10071c:	89 04 24             	mov    %eax,(%esp)
  10071f:	e8 b9 fc ff ff       	call   1003dd <stab_binsearch>
    if (lline <= rline) {
  100724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100727:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10072a:	39 c2                	cmp    %eax,%edx
  10072c:	7f 24                	jg     100752 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  10072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100731:	89 c2                	mov    %eax,%edx
  100733:	89 d0                	mov    %edx,%eax
  100735:	01 c0                	add    %eax,%eax
  100737:	01 d0                	add    %edx,%eax
  100739:	c1 e0 02             	shl    $0x2,%eax
  10073c:	89 c2                	mov    %eax,%edx
  10073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100741:	01 d0                	add    %edx,%eax
  100743:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100747:	0f b7 d0             	movzwl %ax,%edx
  10074a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10074d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100750:	eb 13                	jmp    100765 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100757:	e9 12 01 00 00       	jmp    10086e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10075c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10075f:	83 e8 01             	sub    $0x1,%eax
  100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10076b:	39 c2                	cmp    %eax,%edx
  10076d:	7c 56                	jl     1007c5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  10076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100772:	89 c2                	mov    %eax,%edx
  100774:	89 d0                	mov    %edx,%eax
  100776:	01 c0                	add    %eax,%eax
  100778:	01 d0                	add    %edx,%eax
  10077a:	c1 e0 02             	shl    $0x2,%eax
  10077d:	89 c2                	mov    %eax,%edx
  10077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100782:	01 d0                	add    %edx,%eax
  100784:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100788:	3c 84                	cmp    $0x84,%al
  10078a:	74 39                	je     1007c5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10078c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10078f:	89 c2                	mov    %eax,%edx
  100791:	89 d0                	mov    %edx,%eax
  100793:	01 c0                	add    %eax,%eax
  100795:	01 d0                	add    %edx,%eax
  100797:	c1 e0 02             	shl    $0x2,%eax
  10079a:	89 c2                	mov    %eax,%edx
  10079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10079f:	01 d0                	add    %edx,%eax
  1007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007a5:	3c 64                	cmp    $0x64,%al
  1007a7:	75 b3                	jne    10075c <debuginfo_eip+0x229>
  1007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007ac:	89 c2                	mov    %eax,%edx
  1007ae:	89 d0                	mov    %edx,%eax
  1007b0:	01 c0                	add    %eax,%eax
  1007b2:	01 d0                	add    %edx,%eax
  1007b4:	c1 e0 02             	shl    $0x2,%eax
  1007b7:	89 c2                	mov    %eax,%edx
  1007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007bc:	01 d0                	add    %edx,%eax
  1007be:	8b 40 08             	mov    0x8(%eax),%eax
  1007c1:	85 c0                	test   %eax,%eax
  1007c3:	74 97                	je     10075c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007cb:	39 c2                	cmp    %eax,%edx
  1007cd:	7c 46                	jl     100815 <debuginfo_eip+0x2e2>
  1007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007d2:	89 c2                	mov    %eax,%edx
  1007d4:	89 d0                	mov    %edx,%eax
  1007d6:	01 c0                	add    %eax,%eax
  1007d8:	01 d0                	add    %edx,%eax
  1007da:	c1 e0 02             	shl    $0x2,%eax
  1007dd:	89 c2                	mov    %eax,%edx
  1007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007e2:	01 d0                	add    %edx,%eax
  1007e4:	8b 10                	mov    (%eax),%edx
  1007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007ec:	29 c1                	sub    %eax,%ecx
  1007ee:	89 c8                	mov    %ecx,%eax
  1007f0:	39 c2                	cmp    %eax,%edx
  1007f2:	73 21                	jae    100815 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007f7:	89 c2                	mov    %eax,%edx
  1007f9:	89 d0                	mov    %edx,%eax
  1007fb:	01 c0                	add    %eax,%eax
  1007fd:	01 d0                	add    %edx,%eax
  1007ff:	c1 e0 02             	shl    $0x2,%eax
  100802:	89 c2                	mov    %eax,%edx
  100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100807:	01 d0                	add    %edx,%eax
  100809:	8b 10                	mov    (%eax),%edx
  10080b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10080e:	01 c2                	add    %eax,%edx
  100810:	8b 45 0c             	mov    0xc(%ebp),%eax
  100813:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100815:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100818:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10081b:	39 c2                	cmp    %eax,%edx
  10081d:	7d 4a                	jge    100869 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  10081f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100822:	83 c0 01             	add    $0x1,%eax
  100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100828:	eb 18                	jmp    100842 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  10082a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10082d:	8b 40 14             	mov    0x14(%eax),%eax
  100830:	8d 50 01             	lea    0x1(%eax),%edx
  100833:	8b 45 0c             	mov    0xc(%ebp),%eax
  100836:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  100839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10083c:	83 c0 01             	add    $0x1,%eax
  10083f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100845:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  100848:	39 c2                	cmp    %eax,%edx
  10084a:	7d 1d                	jge    100869 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10084f:	89 c2                	mov    %eax,%edx
  100851:	89 d0                	mov    %edx,%eax
  100853:	01 c0                	add    %eax,%eax
  100855:	01 d0                	add    %edx,%eax
  100857:	c1 e0 02             	shl    $0x2,%eax
  10085a:	89 c2                	mov    %eax,%edx
  10085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10085f:	01 d0                	add    %edx,%eax
  100861:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100865:	3c a0                	cmp    $0xa0,%al
  100867:	74 c1                	je     10082a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  100869:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10086e:	c9                   	leave  
  10086f:	c3                   	ret    

00100870 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100870:	55                   	push   %ebp
  100871:	89 e5                	mov    %esp,%ebp
  100873:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100876:	c7 04 24 36 5f 10 00 	movl   $0x105f36,(%esp)
  10087d:	e8 ba fa ff ff       	call   10033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100882:	c7 44 24 04 2a 00 10 	movl   $0x10002a,0x4(%esp)
  100889:	00 
  10088a:	c7 04 24 4f 5f 10 00 	movl   $0x105f4f,(%esp)
  100891:	e8 a6 fa ff ff       	call   10033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100896:	c7 44 24 04 71 5e 10 	movl   $0x105e71,0x4(%esp)
  10089d:	00 
  10089e:	c7 04 24 67 5f 10 00 	movl   $0x105f67,(%esp)
  1008a5:	e8 92 fa ff ff       	call   10033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008aa:	c7 44 24 04 36 7a 11 	movl   $0x117a36,0x4(%esp)
  1008b1:	00 
  1008b2:	c7 04 24 7f 5f 10 00 	movl   $0x105f7f,(%esp)
  1008b9:	e8 7e fa ff ff       	call   10033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008be:	c7 44 24 04 68 89 11 	movl   $0x118968,0x4(%esp)
  1008c5:	00 
  1008c6:	c7 04 24 97 5f 10 00 	movl   $0x105f97,(%esp)
  1008cd:	e8 6a fa ff ff       	call   10033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008d2:	b8 68 89 11 00       	mov    $0x118968,%eax
  1008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008dd:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  1008e2:	29 c2                	sub    %eax,%edx
  1008e4:	89 d0                	mov    %edx,%eax
  1008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008ec:	85 c0                	test   %eax,%eax
  1008ee:	0f 48 c2             	cmovs  %edx,%eax
  1008f1:	c1 f8 0a             	sar    $0xa,%eax
  1008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008f8:	c7 04 24 b0 5f 10 00 	movl   $0x105fb0,(%esp)
  1008ff:	e8 38 fa ff ff       	call   10033c <cprintf>
}
  100904:	c9                   	leave  
  100905:	c3                   	ret    

00100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100906:	55                   	push   %ebp
  100907:	89 e5                	mov    %esp,%ebp
  100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100912:	89 44 24 04          	mov    %eax,0x4(%esp)
  100916:	8b 45 08             	mov    0x8(%ebp),%eax
  100919:	89 04 24             	mov    %eax,(%esp)
  10091c:	e8 12 fc ff ff       	call   100533 <debuginfo_eip>
  100921:	85 c0                	test   %eax,%eax
  100923:	74 15                	je     10093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100925:	8b 45 08             	mov    0x8(%ebp),%eax
  100928:	89 44 24 04          	mov    %eax,0x4(%esp)
  10092c:	c7 04 24 da 5f 10 00 	movl   $0x105fda,(%esp)
  100933:	e8 04 fa ff ff       	call   10033c <cprintf>
  100938:	eb 6d                	jmp    1009a7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100941:	eb 1c                	jmp    10095f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100949:	01 d0                	add    %edx,%eax
  10094b:	0f b6 00             	movzbl (%eax),%eax
  10094e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100954:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100957:	01 ca                	add    %ecx,%edx
  100959:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10095b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10095f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100965:	7f dc                	jg     100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  100967:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  10096d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100970:	01 d0                	add    %edx,%eax
  100972:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100975:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100978:	8b 55 08             	mov    0x8(%ebp),%edx
  10097b:	89 d1                	mov    %edx,%ecx
  10097d:	29 c1                	sub    %eax,%ecx
  10097f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100982:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100985:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100989:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10098f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100993:	89 54 24 08          	mov    %edx,0x8(%esp)
  100997:	89 44 24 04          	mov    %eax,0x4(%esp)
  10099b:	c7 04 24 f6 5f 10 00 	movl   $0x105ff6,(%esp)
  1009a2:	e8 95 f9 ff ff       	call   10033c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  1009a7:	c9                   	leave  
  1009a8:	c3                   	ret    

001009a9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  1009a9:	55                   	push   %ebp
  1009aa:	89 e5                	mov    %esp,%ebp
  1009ac:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  1009af:	8b 45 04             	mov    0x4(%ebp),%eax
  1009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  1009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1009b8:	c9                   	leave  
  1009b9:	c3                   	ret    

001009ba <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009ba:	55                   	push   %ebp
  1009bb:	89 e5                	mov    %esp,%ebp
  1009bd:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009c0:	89 e8                	mov    %ebp,%eax
  1009c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
  1009c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
  1009c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip = read_eip();
  1009cb:	e8 d9 ff ff ff       	call   1009a9 <read_eip>
  1009d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i;
	for (i = 0; i < STACKFRAME_DEPTH; ++i) {
  1009d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009da:	e9 8d 00 00 00       	jmp    100a6c <print_stackframe+0xb2>
		if (ebp == 0) break;
  1009df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1009e3:	75 05                	jne    1009ea <print_stackframe+0x30>
  1009e5:	e9 8c 00 00 00       	jmp    100a76 <print_stackframe+0xbc>
		cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  1009ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009ed:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009f8:	c7 04 24 08 60 10 00 	movl   $0x106008,(%esp)
  1009ff:	e8 38 f9 ff ff       	call   10033c <cprintf>
		int j;
		for (j = 0; j < 4; ++j) cprintf("0x%08x ", ((uint32_t *) ebp + 2)[j]);
  100a04:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a0b:	eb 28                	jmp    100a35 <print_stackframe+0x7b>
  100a0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a10:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a1a:	01 d0                	add    %edx,%eax
  100a1c:	83 c0 08             	add    $0x8,%eax
  100a1f:	8b 00                	mov    (%eax),%eax
  100a21:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a25:	c7 04 24 24 60 10 00 	movl   $0x106024,(%esp)
  100a2c:	e8 0b f9 ff ff       	call   10033c <cprintf>
  100a31:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a35:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a39:	7e d2                	jle    100a0d <print_stackframe+0x53>
		cprintf("\n");
  100a3b:	c7 04 24 2c 60 10 00 	movl   $0x10602c,(%esp)
  100a42:	e8 f5 f8 ff ff       	call   10033c <cprintf>
		print_debuginfo(eip - 1);
  100a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a4a:	83 e8 01             	sub    $0x1,%eax
  100a4d:	89 04 24             	mov    %eax,(%esp)
  100a50:	e8 b1 fe ff ff       	call   100906 <print_debuginfo>
		eip = *((uint32_t *) ebp + 1);
  100a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a58:	83 c0 04             	add    $0x4,%eax
  100a5b:	8b 00                	mov    (%eax),%eax
  100a5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp = *((uint32_t *) ebp);
  100a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a63:	8b 00                	mov    (%eax),%eax
  100a65:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
	uint32_t eip = read_eip();
	int i;
	for (i = 0; i < STACKFRAME_DEPTH; ++i) {
  100a68:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a6c:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a70:	0f 8e 69 ff ff ff    	jle    1009df <print_stackframe+0x25>
		cprintf("\n");
		print_debuginfo(eip - 1);
		eip = *((uint32_t *) ebp + 1);
		ebp = *((uint32_t *) ebp);
	}
}
  100a76:	c9                   	leave  
  100a77:	c3                   	ret    

00100a78 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a78:	55                   	push   %ebp
  100a79:	89 e5                	mov    %esp,%ebp
  100a7b:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a7e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a85:	eb 0c                	jmp    100a93 <parse+0x1b>
            *buf ++ = '\0';
  100a87:	8b 45 08             	mov    0x8(%ebp),%eax
  100a8a:	8d 50 01             	lea    0x1(%eax),%edx
  100a8d:	89 55 08             	mov    %edx,0x8(%ebp)
  100a90:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a93:	8b 45 08             	mov    0x8(%ebp),%eax
  100a96:	0f b6 00             	movzbl (%eax),%eax
  100a99:	84 c0                	test   %al,%al
  100a9b:	74 1d                	je     100aba <parse+0x42>
  100a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa0:	0f b6 00             	movzbl (%eax),%eax
  100aa3:	0f be c0             	movsbl %al,%eax
  100aa6:	89 44 24 04          	mov    %eax,0x4(%esp)
  100aaa:	c7 04 24 b0 60 10 00 	movl   $0x1060b0,(%esp)
  100ab1:	e8 73 50 00 00       	call   105b29 <strchr>
  100ab6:	85 c0                	test   %eax,%eax
  100ab8:	75 cd                	jne    100a87 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100aba:	8b 45 08             	mov    0x8(%ebp),%eax
  100abd:	0f b6 00             	movzbl (%eax),%eax
  100ac0:	84 c0                	test   %al,%al
  100ac2:	75 02                	jne    100ac6 <parse+0x4e>
            break;
  100ac4:	eb 67                	jmp    100b2d <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100ac6:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100aca:	75 14                	jne    100ae0 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100acc:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100ad3:	00 
  100ad4:	c7 04 24 b5 60 10 00 	movl   $0x1060b5,(%esp)
  100adb:	e8 5c f8 ff ff       	call   10033c <cprintf>
        }
        argv[argc ++] = buf;
  100ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ae3:	8d 50 01             	lea    0x1(%eax),%edx
  100ae6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100ae9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100af0:	8b 45 0c             	mov    0xc(%ebp),%eax
  100af3:	01 c2                	add    %eax,%edx
  100af5:	8b 45 08             	mov    0x8(%ebp),%eax
  100af8:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100afa:	eb 04                	jmp    100b00 <parse+0x88>
            buf ++;
  100afc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b00:	8b 45 08             	mov    0x8(%ebp),%eax
  100b03:	0f b6 00             	movzbl (%eax),%eax
  100b06:	84 c0                	test   %al,%al
  100b08:	74 1d                	je     100b27 <parse+0xaf>
  100b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  100b0d:	0f b6 00             	movzbl (%eax),%eax
  100b10:	0f be c0             	movsbl %al,%eax
  100b13:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b17:	c7 04 24 b0 60 10 00 	movl   $0x1060b0,(%esp)
  100b1e:	e8 06 50 00 00       	call   105b29 <strchr>
  100b23:	85 c0                	test   %eax,%eax
  100b25:	74 d5                	je     100afc <parse+0x84>
            buf ++;
        }
    }
  100b27:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b28:	e9 66 ff ff ff       	jmp    100a93 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b30:	c9                   	leave  
  100b31:	c3                   	ret    

00100b32 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b32:	55                   	push   %ebp
  100b33:	89 e5                	mov    %esp,%ebp
  100b35:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b38:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  100b42:	89 04 24             	mov    %eax,(%esp)
  100b45:	e8 2e ff ff ff       	call   100a78 <parse>
  100b4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b4d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b51:	75 0a                	jne    100b5d <runcmd+0x2b>
        return 0;
  100b53:	b8 00 00 00 00       	mov    $0x0,%eax
  100b58:	e9 85 00 00 00       	jmp    100be2 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b64:	eb 5c                	jmp    100bc2 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b66:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b6c:	89 d0                	mov    %edx,%eax
  100b6e:	01 c0                	add    %eax,%eax
  100b70:	01 d0                	add    %edx,%eax
  100b72:	c1 e0 02             	shl    $0x2,%eax
  100b75:	05 20 70 11 00       	add    $0x117020,%eax
  100b7a:	8b 00                	mov    (%eax),%eax
  100b7c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b80:	89 04 24             	mov    %eax,(%esp)
  100b83:	e8 02 4f 00 00       	call   105a8a <strcmp>
  100b88:	85 c0                	test   %eax,%eax
  100b8a:	75 32                	jne    100bbe <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b8f:	89 d0                	mov    %edx,%eax
  100b91:	01 c0                	add    %eax,%eax
  100b93:	01 d0                	add    %edx,%eax
  100b95:	c1 e0 02             	shl    $0x2,%eax
  100b98:	05 20 70 11 00       	add    $0x117020,%eax
  100b9d:	8b 40 08             	mov    0x8(%eax),%eax
  100ba0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100ba3:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100ba6:	8b 55 0c             	mov    0xc(%ebp),%edx
  100ba9:	89 54 24 08          	mov    %edx,0x8(%esp)
  100bad:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100bb0:	83 c2 04             	add    $0x4,%edx
  100bb3:	89 54 24 04          	mov    %edx,0x4(%esp)
  100bb7:	89 0c 24             	mov    %ecx,(%esp)
  100bba:	ff d0                	call   *%eax
  100bbc:	eb 24                	jmp    100be2 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bbe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bc5:	83 f8 02             	cmp    $0x2,%eax
  100bc8:	76 9c                	jbe    100b66 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bca:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bcd:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bd1:	c7 04 24 d3 60 10 00 	movl   $0x1060d3,(%esp)
  100bd8:	e8 5f f7 ff ff       	call   10033c <cprintf>
    return 0;
  100bdd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100be2:	c9                   	leave  
  100be3:	c3                   	ret    

00100be4 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100be4:	55                   	push   %ebp
  100be5:	89 e5                	mov    %esp,%ebp
  100be7:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bea:	c7 04 24 ec 60 10 00 	movl   $0x1060ec,(%esp)
  100bf1:	e8 46 f7 ff ff       	call   10033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bf6:	c7 04 24 14 61 10 00 	movl   $0x106114,(%esp)
  100bfd:	e8 3a f7 ff ff       	call   10033c <cprintf>

    if (tf != NULL) {
  100c02:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c06:	74 0b                	je     100c13 <kmonitor+0x2f>
        print_trapframe(tf);
  100c08:	8b 45 08             	mov    0x8(%ebp),%eax
  100c0b:	89 04 24             	mov    %eax,(%esp)
  100c0e:	e8 cf 0d 00 00       	call   1019e2 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c13:	c7 04 24 39 61 10 00 	movl   $0x106139,(%esp)
  100c1a:	e8 14 f6 ff ff       	call   100233 <readline>
  100c1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c26:	74 18                	je     100c40 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c28:	8b 45 08             	mov    0x8(%ebp),%eax
  100c2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c32:	89 04 24             	mov    %eax,(%esp)
  100c35:	e8 f8 fe ff ff       	call   100b32 <runcmd>
  100c3a:	85 c0                	test   %eax,%eax
  100c3c:	79 02                	jns    100c40 <kmonitor+0x5c>
                break;
  100c3e:	eb 02                	jmp    100c42 <kmonitor+0x5e>
            }
        }
    }
  100c40:	eb d1                	jmp    100c13 <kmonitor+0x2f>
}
  100c42:	c9                   	leave  
  100c43:	c3                   	ret    

00100c44 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c44:	55                   	push   %ebp
  100c45:	89 e5                	mov    %esp,%ebp
  100c47:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c4a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c51:	eb 3f                	jmp    100c92 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c56:	89 d0                	mov    %edx,%eax
  100c58:	01 c0                	add    %eax,%eax
  100c5a:	01 d0                	add    %edx,%eax
  100c5c:	c1 e0 02             	shl    $0x2,%eax
  100c5f:	05 20 70 11 00       	add    $0x117020,%eax
  100c64:	8b 48 04             	mov    0x4(%eax),%ecx
  100c67:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c6a:	89 d0                	mov    %edx,%eax
  100c6c:	01 c0                	add    %eax,%eax
  100c6e:	01 d0                	add    %edx,%eax
  100c70:	c1 e0 02             	shl    $0x2,%eax
  100c73:	05 20 70 11 00       	add    $0x117020,%eax
  100c78:	8b 00                	mov    (%eax),%eax
  100c7a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c82:	c7 04 24 3d 61 10 00 	movl   $0x10613d,(%esp)
  100c89:	e8 ae f6 ff ff       	call   10033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c8e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c95:	83 f8 02             	cmp    $0x2,%eax
  100c98:	76 b9                	jbe    100c53 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100c9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c9f:	c9                   	leave  
  100ca0:	c3                   	ret    

00100ca1 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100ca1:	55                   	push   %ebp
  100ca2:	89 e5                	mov    %esp,%ebp
  100ca4:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100ca7:	e8 c4 fb ff ff       	call   100870 <print_kerninfo>
    return 0;
  100cac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cb1:	c9                   	leave  
  100cb2:	c3                   	ret    

00100cb3 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100cb3:	55                   	push   %ebp
  100cb4:	89 e5                	mov    %esp,%ebp
  100cb6:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100cb9:	e8 fc fc ff ff       	call   1009ba <print_stackframe>
    return 0;
  100cbe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cc3:	c9                   	leave  
  100cc4:	c3                   	ret    

00100cc5 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100cc5:	55                   	push   %ebp
  100cc6:	89 e5                	mov    %esp,%ebp
  100cc8:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100ccb:	a1 60 7e 11 00       	mov    0x117e60,%eax
  100cd0:	85 c0                	test   %eax,%eax
  100cd2:	74 02                	je     100cd6 <__panic+0x11>
        goto panic_dead;
  100cd4:	eb 48                	jmp    100d1e <__panic+0x59>
    }
    is_panic = 1;
  100cd6:	c7 05 60 7e 11 00 01 	movl   $0x1,0x117e60
  100cdd:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100ce0:	8d 45 14             	lea    0x14(%ebp),%eax
  100ce3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100ce6:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ce9:	89 44 24 08          	mov    %eax,0x8(%esp)
  100ced:	8b 45 08             	mov    0x8(%ebp),%eax
  100cf0:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cf4:	c7 04 24 46 61 10 00 	movl   $0x106146,(%esp)
  100cfb:	e8 3c f6 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100d00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d03:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d07:	8b 45 10             	mov    0x10(%ebp),%eax
  100d0a:	89 04 24             	mov    %eax,(%esp)
  100d0d:	e8 f7 f5 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100d12:	c7 04 24 62 61 10 00 	movl   $0x106162,(%esp)
  100d19:	e8 1e f6 ff ff       	call   10033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100d1e:	e8 85 09 00 00       	call   1016a8 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d23:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d2a:	e8 b5 fe ff ff       	call   100be4 <kmonitor>
    }
  100d2f:	eb f2                	jmp    100d23 <__panic+0x5e>

00100d31 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d31:	55                   	push   %ebp
  100d32:	89 e5                	mov    %esp,%ebp
  100d34:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d37:	8d 45 14             	lea    0x14(%ebp),%eax
  100d3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d40:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d44:	8b 45 08             	mov    0x8(%ebp),%eax
  100d47:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d4b:	c7 04 24 64 61 10 00 	movl   $0x106164,(%esp)
  100d52:	e8 e5 f5 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d5e:	8b 45 10             	mov    0x10(%ebp),%eax
  100d61:	89 04 24             	mov    %eax,(%esp)
  100d64:	e8 a0 f5 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100d69:	c7 04 24 62 61 10 00 	movl   $0x106162,(%esp)
  100d70:	e8 c7 f5 ff ff       	call   10033c <cprintf>
    va_end(ap);
}
  100d75:	c9                   	leave  
  100d76:	c3                   	ret    

00100d77 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d77:	55                   	push   %ebp
  100d78:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d7a:	a1 60 7e 11 00       	mov    0x117e60,%eax
}
  100d7f:	5d                   	pop    %ebp
  100d80:	c3                   	ret    

00100d81 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d81:	55                   	push   %ebp
  100d82:	89 e5                	mov    %esp,%ebp
  100d84:	83 ec 28             	sub    $0x28,%esp
  100d87:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d8d:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100d91:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d95:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d99:	ee                   	out    %al,(%dx)
  100d9a:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100da0:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100da4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100da8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100dac:	ee                   	out    %al,(%dx)
  100dad:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100db3:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100db7:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dbb:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dbf:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dc0:	c7 05 4c 89 11 00 00 	movl   $0x0,0x11894c
  100dc7:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100dca:	c7 04 24 82 61 10 00 	movl   $0x106182,(%esp)
  100dd1:	e8 66 f5 ff ff       	call   10033c <cprintf>
    pic_enable(IRQ_TIMER);
  100dd6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100ddd:	e8 24 09 00 00       	call   101706 <pic_enable>
}
  100de2:	c9                   	leave  
  100de3:	c3                   	ret    

00100de4 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100de4:	55                   	push   %ebp
  100de5:	89 e5                	mov    %esp,%ebp
  100de7:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100dea:	9c                   	pushf  
  100deb:	58                   	pop    %eax
  100dec:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100def:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100df2:	25 00 02 00 00       	and    $0x200,%eax
  100df7:	85 c0                	test   %eax,%eax
  100df9:	74 0c                	je     100e07 <__intr_save+0x23>
        intr_disable();
  100dfb:	e8 a8 08 00 00       	call   1016a8 <intr_disable>
        return 1;
  100e00:	b8 01 00 00 00       	mov    $0x1,%eax
  100e05:	eb 05                	jmp    100e0c <__intr_save+0x28>
    }
    return 0;
  100e07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e0c:	c9                   	leave  
  100e0d:	c3                   	ret    

00100e0e <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e0e:	55                   	push   %ebp
  100e0f:	89 e5                	mov    %esp,%ebp
  100e11:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e14:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e18:	74 05                	je     100e1f <__intr_restore+0x11>
        intr_enable();
  100e1a:	e8 83 08 00 00       	call   1016a2 <intr_enable>
    }
}
  100e1f:	c9                   	leave  
  100e20:	c3                   	ret    

00100e21 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e21:	55                   	push   %ebp
  100e22:	89 e5                	mov    %esp,%ebp
  100e24:	83 ec 10             	sub    $0x10,%esp
  100e27:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e2d:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e31:	89 c2                	mov    %eax,%edx
  100e33:	ec                   	in     (%dx),%al
  100e34:	88 45 fd             	mov    %al,-0x3(%ebp)
  100e37:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e3d:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e41:	89 c2                	mov    %eax,%edx
  100e43:	ec                   	in     (%dx),%al
  100e44:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e47:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e4d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e51:	89 c2                	mov    %eax,%edx
  100e53:	ec                   	in     (%dx),%al
  100e54:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e57:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e5d:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e61:	89 c2                	mov    %eax,%edx
  100e63:	ec                   	in     (%dx),%al
  100e64:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e67:	c9                   	leave  
  100e68:	c3                   	ret    

00100e69 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e69:	55                   	push   %ebp
  100e6a:	89 e5                	mov    %esp,%ebp
  100e6c:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e6f:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e76:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e79:	0f b7 00             	movzwl (%eax),%eax
  100e7c:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e80:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e83:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e8b:	0f b7 00             	movzwl (%eax),%eax
  100e8e:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e92:	74 12                	je     100ea6 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100e94:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100e9b:	66 c7 05 86 7e 11 00 	movw   $0x3b4,0x117e86
  100ea2:	b4 03 
  100ea4:	eb 13                	jmp    100eb9 <cga_init+0x50>
    } else {
        *cp = was;
  100ea6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ea9:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100ead:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100eb0:	66 c7 05 86 7e 11 00 	movw   $0x3d4,0x117e86
  100eb7:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100eb9:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ec0:	0f b7 c0             	movzwl %ax,%eax
  100ec3:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100ec7:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ecb:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ecf:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100ed3:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100ed4:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100edb:	83 c0 01             	add    $0x1,%eax
  100ede:	0f b7 c0             	movzwl %ax,%eax
  100ee1:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ee5:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100ee9:	89 c2                	mov    %eax,%edx
  100eeb:	ec                   	in     (%dx),%al
  100eec:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100eef:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ef3:	0f b6 c0             	movzbl %al,%eax
  100ef6:	c1 e0 08             	shl    $0x8,%eax
  100ef9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100efc:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f03:	0f b7 c0             	movzwl %ax,%eax
  100f06:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100f0a:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f0e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f12:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f16:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f17:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f1e:	83 c0 01             	add    $0x1,%eax
  100f21:	0f b7 c0             	movzwl %ax,%eax
  100f24:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f28:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100f2c:	89 c2                	mov    %eax,%edx
  100f2e:	ec                   	in     (%dx),%al
  100f2f:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100f32:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f36:	0f b6 c0             	movzbl %al,%eax
  100f39:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f3f:	a3 80 7e 11 00       	mov    %eax,0x117e80
    crt_pos = pos;
  100f44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f47:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
}
  100f4d:	c9                   	leave  
  100f4e:	c3                   	ret    

00100f4f <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f4f:	55                   	push   %ebp
  100f50:	89 e5                	mov    %esp,%ebp
  100f52:	83 ec 48             	sub    $0x48,%esp
  100f55:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f5b:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f5f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f63:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f67:	ee                   	out    %al,(%dx)
  100f68:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f6e:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f72:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f76:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f7a:	ee                   	out    %al,(%dx)
  100f7b:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f81:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f85:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f89:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f8d:	ee                   	out    %al,(%dx)
  100f8e:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f94:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f98:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f9c:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fa0:	ee                   	out    %al,(%dx)
  100fa1:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100fa7:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100fab:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100faf:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fb3:	ee                   	out    %al,(%dx)
  100fb4:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100fba:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100fbe:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fc2:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fc6:	ee                   	out    %al,(%dx)
  100fc7:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fcd:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100fd1:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fd5:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fd9:	ee                   	out    %al,(%dx)
  100fda:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fe0:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100fe4:	89 c2                	mov    %eax,%edx
  100fe6:	ec                   	in     (%dx),%al
  100fe7:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100fea:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100fee:	3c ff                	cmp    $0xff,%al
  100ff0:	0f 95 c0             	setne  %al
  100ff3:	0f b6 c0             	movzbl %al,%eax
  100ff6:	a3 88 7e 11 00       	mov    %eax,0x117e88
  100ffb:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101001:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  101005:	89 c2                	mov    %eax,%edx
  101007:	ec                   	in     (%dx),%al
  101008:	88 45 d5             	mov    %al,-0x2b(%ebp)
  10100b:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  101011:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  101015:	89 c2                	mov    %eax,%edx
  101017:	ec                   	in     (%dx),%al
  101018:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  10101b:	a1 88 7e 11 00       	mov    0x117e88,%eax
  101020:	85 c0                	test   %eax,%eax
  101022:	74 0c                	je     101030 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  101024:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  10102b:	e8 d6 06 00 00       	call   101706 <pic_enable>
    }
}
  101030:	c9                   	leave  
  101031:	c3                   	ret    

00101032 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  101032:	55                   	push   %ebp
  101033:	89 e5                	mov    %esp,%ebp
  101035:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101038:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10103f:	eb 09                	jmp    10104a <lpt_putc_sub+0x18>
        delay();
  101041:	e8 db fd ff ff       	call   100e21 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101046:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10104a:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101050:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101054:	89 c2                	mov    %eax,%edx
  101056:	ec                   	in     (%dx),%al
  101057:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10105a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10105e:	84 c0                	test   %al,%al
  101060:	78 09                	js     10106b <lpt_putc_sub+0x39>
  101062:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101069:	7e d6                	jle    101041 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  10106b:	8b 45 08             	mov    0x8(%ebp),%eax
  10106e:	0f b6 c0             	movzbl %al,%eax
  101071:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  101077:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10107a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10107e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101082:	ee                   	out    %al,(%dx)
  101083:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101089:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  10108d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101091:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101095:	ee                   	out    %al,(%dx)
  101096:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  10109c:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  1010a0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010a4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010a8:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010a9:	c9                   	leave  
  1010aa:	c3                   	ret    

001010ab <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010ab:	55                   	push   %ebp
  1010ac:	89 e5                	mov    %esp,%ebp
  1010ae:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010b1:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010b5:	74 0d                	je     1010c4 <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  1010ba:	89 04 24             	mov    %eax,(%esp)
  1010bd:	e8 70 ff ff ff       	call   101032 <lpt_putc_sub>
  1010c2:	eb 24                	jmp    1010e8 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  1010c4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010cb:	e8 62 ff ff ff       	call   101032 <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010d0:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010d7:	e8 56 ff ff ff       	call   101032 <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010dc:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010e3:	e8 4a ff ff ff       	call   101032 <lpt_putc_sub>
    }
}
  1010e8:	c9                   	leave  
  1010e9:	c3                   	ret    

001010ea <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010ea:	55                   	push   %ebp
  1010eb:	89 e5                	mov    %esp,%ebp
  1010ed:	53                   	push   %ebx
  1010ee:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1010f4:	b0 00                	mov    $0x0,%al
  1010f6:	85 c0                	test   %eax,%eax
  1010f8:	75 07                	jne    101101 <cga_putc+0x17>
        c |= 0x0700;
  1010fa:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101101:	8b 45 08             	mov    0x8(%ebp),%eax
  101104:	0f b6 c0             	movzbl %al,%eax
  101107:	83 f8 0a             	cmp    $0xa,%eax
  10110a:	74 4c                	je     101158 <cga_putc+0x6e>
  10110c:	83 f8 0d             	cmp    $0xd,%eax
  10110f:	74 57                	je     101168 <cga_putc+0x7e>
  101111:	83 f8 08             	cmp    $0x8,%eax
  101114:	0f 85 88 00 00 00    	jne    1011a2 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  10111a:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101121:	66 85 c0             	test   %ax,%ax
  101124:	74 30                	je     101156 <cga_putc+0x6c>
            crt_pos --;
  101126:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10112d:	83 e8 01             	sub    $0x1,%eax
  101130:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101136:	a1 80 7e 11 00       	mov    0x117e80,%eax
  10113b:	0f b7 15 84 7e 11 00 	movzwl 0x117e84,%edx
  101142:	0f b7 d2             	movzwl %dx,%edx
  101145:	01 d2                	add    %edx,%edx
  101147:	01 c2                	add    %eax,%edx
  101149:	8b 45 08             	mov    0x8(%ebp),%eax
  10114c:	b0 00                	mov    $0x0,%al
  10114e:	83 c8 20             	or     $0x20,%eax
  101151:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101154:	eb 72                	jmp    1011c8 <cga_putc+0xde>
  101156:	eb 70                	jmp    1011c8 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  101158:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10115f:	83 c0 50             	add    $0x50,%eax
  101162:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101168:	0f b7 1d 84 7e 11 00 	movzwl 0x117e84,%ebx
  10116f:	0f b7 0d 84 7e 11 00 	movzwl 0x117e84,%ecx
  101176:	0f b7 c1             	movzwl %cx,%eax
  101179:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  10117f:	c1 e8 10             	shr    $0x10,%eax
  101182:	89 c2                	mov    %eax,%edx
  101184:	66 c1 ea 06          	shr    $0x6,%dx
  101188:	89 d0                	mov    %edx,%eax
  10118a:	c1 e0 02             	shl    $0x2,%eax
  10118d:	01 d0                	add    %edx,%eax
  10118f:	c1 e0 04             	shl    $0x4,%eax
  101192:	29 c1                	sub    %eax,%ecx
  101194:	89 ca                	mov    %ecx,%edx
  101196:	89 d8                	mov    %ebx,%eax
  101198:	29 d0                	sub    %edx,%eax
  10119a:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
        break;
  1011a0:	eb 26                	jmp    1011c8 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011a2:	8b 0d 80 7e 11 00    	mov    0x117e80,%ecx
  1011a8:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011af:	8d 50 01             	lea    0x1(%eax),%edx
  1011b2:	66 89 15 84 7e 11 00 	mov    %dx,0x117e84
  1011b9:	0f b7 c0             	movzwl %ax,%eax
  1011bc:	01 c0                	add    %eax,%eax
  1011be:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1011c4:	66 89 02             	mov    %ax,(%edx)
        break;
  1011c7:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011c8:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011cf:	66 3d cf 07          	cmp    $0x7cf,%ax
  1011d3:	76 5b                	jbe    101230 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011d5:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011da:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011e0:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011e5:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011ec:	00 
  1011ed:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011f1:	89 04 24             	mov    %eax,(%esp)
  1011f4:	e8 2e 4b 00 00       	call   105d27 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011f9:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101200:	eb 15                	jmp    101217 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  101202:	a1 80 7e 11 00       	mov    0x117e80,%eax
  101207:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10120a:	01 d2                	add    %edx,%edx
  10120c:	01 d0                	add    %edx,%eax
  10120e:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101213:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101217:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  10121e:	7e e2                	jle    101202 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  101220:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101227:	83 e8 50             	sub    $0x50,%eax
  10122a:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101230:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  101237:	0f b7 c0             	movzwl %ax,%eax
  10123a:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  10123e:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  101242:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101246:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10124a:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  10124b:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101252:	66 c1 e8 08          	shr    $0x8,%ax
  101256:	0f b6 c0             	movzbl %al,%eax
  101259:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  101260:	83 c2 01             	add    $0x1,%edx
  101263:	0f b7 d2             	movzwl %dx,%edx
  101266:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  10126a:	88 45 ed             	mov    %al,-0x13(%ebp)
  10126d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101271:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101275:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101276:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  10127d:	0f b7 c0             	movzwl %ax,%eax
  101280:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  101284:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101288:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10128c:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101290:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101291:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101298:	0f b6 c0             	movzbl %al,%eax
  10129b:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  1012a2:	83 c2 01             	add    $0x1,%edx
  1012a5:	0f b7 d2             	movzwl %dx,%edx
  1012a8:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  1012ac:	88 45 e5             	mov    %al,-0x1b(%ebp)
  1012af:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012b3:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012b7:	ee                   	out    %al,(%dx)
}
  1012b8:	83 c4 34             	add    $0x34,%esp
  1012bb:	5b                   	pop    %ebx
  1012bc:	5d                   	pop    %ebp
  1012bd:	c3                   	ret    

001012be <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012be:	55                   	push   %ebp
  1012bf:	89 e5                	mov    %esp,%ebp
  1012c1:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012cb:	eb 09                	jmp    1012d6 <serial_putc_sub+0x18>
        delay();
  1012cd:	e8 4f fb ff ff       	call   100e21 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012d2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1012d6:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012dc:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012e0:	89 c2                	mov    %eax,%edx
  1012e2:	ec                   	in     (%dx),%al
  1012e3:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012e6:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012ea:	0f b6 c0             	movzbl %al,%eax
  1012ed:	83 e0 20             	and    $0x20,%eax
  1012f0:	85 c0                	test   %eax,%eax
  1012f2:	75 09                	jne    1012fd <serial_putc_sub+0x3f>
  1012f4:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012fb:	7e d0                	jle    1012cd <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  1012fd:	8b 45 08             	mov    0x8(%ebp),%eax
  101300:	0f b6 c0             	movzbl %al,%eax
  101303:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101309:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10130c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101310:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101314:	ee                   	out    %al,(%dx)
}
  101315:	c9                   	leave  
  101316:	c3                   	ret    

00101317 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101317:	55                   	push   %ebp
  101318:	89 e5                	mov    %esp,%ebp
  10131a:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10131d:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101321:	74 0d                	je     101330 <serial_putc+0x19>
        serial_putc_sub(c);
  101323:	8b 45 08             	mov    0x8(%ebp),%eax
  101326:	89 04 24             	mov    %eax,(%esp)
  101329:	e8 90 ff ff ff       	call   1012be <serial_putc_sub>
  10132e:	eb 24                	jmp    101354 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  101330:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101337:	e8 82 ff ff ff       	call   1012be <serial_putc_sub>
        serial_putc_sub(' ');
  10133c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101343:	e8 76 ff ff ff       	call   1012be <serial_putc_sub>
        serial_putc_sub('\b');
  101348:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10134f:	e8 6a ff ff ff       	call   1012be <serial_putc_sub>
    }
}
  101354:	c9                   	leave  
  101355:	c3                   	ret    

00101356 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101356:	55                   	push   %ebp
  101357:	89 e5                	mov    %esp,%ebp
  101359:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  10135c:	eb 33                	jmp    101391 <cons_intr+0x3b>
        if (c != 0) {
  10135e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101362:	74 2d                	je     101391 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101364:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101369:	8d 50 01             	lea    0x1(%eax),%edx
  10136c:	89 15 a4 80 11 00    	mov    %edx,0x1180a4
  101372:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101375:	88 90 a0 7e 11 00    	mov    %dl,0x117ea0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  10137b:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101380:	3d 00 02 00 00       	cmp    $0x200,%eax
  101385:	75 0a                	jne    101391 <cons_intr+0x3b>
                cons.wpos = 0;
  101387:	c7 05 a4 80 11 00 00 	movl   $0x0,0x1180a4
  10138e:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101391:	8b 45 08             	mov    0x8(%ebp),%eax
  101394:	ff d0                	call   *%eax
  101396:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101399:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10139d:	75 bf                	jne    10135e <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  10139f:	c9                   	leave  
  1013a0:	c3                   	ret    

001013a1 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013a1:	55                   	push   %ebp
  1013a2:	89 e5                	mov    %esp,%ebp
  1013a4:	83 ec 10             	sub    $0x10,%esp
  1013a7:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013ad:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013b1:	89 c2                	mov    %eax,%edx
  1013b3:	ec                   	in     (%dx),%al
  1013b4:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013b7:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013bb:	0f b6 c0             	movzbl %al,%eax
  1013be:	83 e0 01             	and    $0x1,%eax
  1013c1:	85 c0                	test   %eax,%eax
  1013c3:	75 07                	jne    1013cc <serial_proc_data+0x2b>
        return -1;
  1013c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013ca:	eb 2a                	jmp    1013f6 <serial_proc_data+0x55>
  1013cc:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013d2:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013d6:	89 c2                	mov    %eax,%edx
  1013d8:	ec                   	in     (%dx),%al
  1013d9:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013dc:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013e0:	0f b6 c0             	movzbl %al,%eax
  1013e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013e6:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013ea:	75 07                	jne    1013f3 <serial_proc_data+0x52>
        c = '\b';
  1013ec:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013f6:	c9                   	leave  
  1013f7:	c3                   	ret    

001013f8 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013f8:	55                   	push   %ebp
  1013f9:	89 e5                	mov    %esp,%ebp
  1013fb:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  1013fe:	a1 88 7e 11 00       	mov    0x117e88,%eax
  101403:	85 c0                	test   %eax,%eax
  101405:	74 0c                	je     101413 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101407:	c7 04 24 a1 13 10 00 	movl   $0x1013a1,(%esp)
  10140e:	e8 43 ff ff ff       	call   101356 <cons_intr>
    }
}
  101413:	c9                   	leave  
  101414:	c3                   	ret    

00101415 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101415:	55                   	push   %ebp
  101416:	89 e5                	mov    %esp,%ebp
  101418:	83 ec 38             	sub    $0x38,%esp
  10141b:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101421:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  101425:	89 c2                	mov    %eax,%edx
  101427:	ec                   	in     (%dx),%al
  101428:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  10142b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  10142f:	0f b6 c0             	movzbl %al,%eax
  101432:	83 e0 01             	and    $0x1,%eax
  101435:	85 c0                	test   %eax,%eax
  101437:	75 0a                	jne    101443 <kbd_proc_data+0x2e>
        return -1;
  101439:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10143e:	e9 59 01 00 00       	jmp    10159c <kbd_proc_data+0x187>
  101443:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101449:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10144d:	89 c2                	mov    %eax,%edx
  10144f:	ec                   	in     (%dx),%al
  101450:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101453:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101457:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  10145a:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  10145e:	75 17                	jne    101477 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  101460:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101465:	83 c8 40             	or     $0x40,%eax
  101468:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  10146d:	b8 00 00 00 00       	mov    $0x0,%eax
  101472:	e9 25 01 00 00       	jmp    10159c <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101477:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10147b:	84 c0                	test   %al,%al
  10147d:	79 47                	jns    1014c6 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  10147f:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101484:	83 e0 40             	and    $0x40,%eax
  101487:	85 c0                	test   %eax,%eax
  101489:	75 09                	jne    101494 <kbd_proc_data+0x7f>
  10148b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10148f:	83 e0 7f             	and    $0x7f,%eax
  101492:	eb 04                	jmp    101498 <kbd_proc_data+0x83>
  101494:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101498:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10149b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10149f:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014a6:	83 c8 40             	or     $0x40,%eax
  1014a9:	0f b6 c0             	movzbl %al,%eax
  1014ac:	f7 d0                	not    %eax
  1014ae:	89 c2                	mov    %eax,%edx
  1014b0:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014b5:	21 d0                	and    %edx,%eax
  1014b7:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  1014bc:	b8 00 00 00 00       	mov    $0x0,%eax
  1014c1:	e9 d6 00 00 00       	jmp    10159c <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  1014c6:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014cb:	83 e0 40             	and    $0x40,%eax
  1014ce:	85 c0                	test   %eax,%eax
  1014d0:	74 11                	je     1014e3 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014d2:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014d6:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014db:	83 e0 bf             	and    $0xffffffbf,%eax
  1014de:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    }

    shift |= shiftcode[data];
  1014e3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014e7:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014ee:	0f b6 d0             	movzbl %al,%edx
  1014f1:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014f6:	09 d0                	or     %edx,%eax
  1014f8:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    shift ^= togglecode[data];
  1014fd:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101501:	0f b6 80 60 71 11 00 	movzbl 0x117160(%eax),%eax
  101508:	0f b6 d0             	movzbl %al,%edx
  10150b:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101510:	31 d0                	xor    %edx,%eax
  101512:	a3 a8 80 11 00       	mov    %eax,0x1180a8

    c = charcode[shift & (CTL | SHIFT)][data];
  101517:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10151c:	83 e0 03             	and    $0x3,%eax
  10151f:	8b 14 85 60 75 11 00 	mov    0x117560(,%eax,4),%edx
  101526:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10152a:	01 d0                	add    %edx,%eax
  10152c:	0f b6 00             	movzbl (%eax),%eax
  10152f:	0f b6 c0             	movzbl %al,%eax
  101532:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101535:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10153a:	83 e0 08             	and    $0x8,%eax
  10153d:	85 c0                	test   %eax,%eax
  10153f:	74 22                	je     101563 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  101541:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101545:	7e 0c                	jle    101553 <kbd_proc_data+0x13e>
  101547:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  10154b:	7f 06                	jg     101553 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  10154d:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101551:	eb 10                	jmp    101563 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  101553:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101557:	7e 0a                	jle    101563 <kbd_proc_data+0x14e>
  101559:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  10155d:	7f 04                	jg     101563 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  10155f:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101563:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101568:	f7 d0                	not    %eax
  10156a:	83 e0 06             	and    $0x6,%eax
  10156d:	85 c0                	test   %eax,%eax
  10156f:	75 28                	jne    101599 <kbd_proc_data+0x184>
  101571:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101578:	75 1f                	jne    101599 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  10157a:	c7 04 24 9d 61 10 00 	movl   $0x10619d,(%esp)
  101581:	e8 b6 ed ff ff       	call   10033c <cprintf>
  101586:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  10158c:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101590:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101594:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101598:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101599:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10159c:	c9                   	leave  
  10159d:	c3                   	ret    

0010159e <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10159e:	55                   	push   %ebp
  10159f:	89 e5                	mov    %esp,%ebp
  1015a1:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015a4:	c7 04 24 15 14 10 00 	movl   $0x101415,(%esp)
  1015ab:	e8 a6 fd ff ff       	call   101356 <cons_intr>
}
  1015b0:	c9                   	leave  
  1015b1:	c3                   	ret    

001015b2 <kbd_init>:

static void
kbd_init(void) {
  1015b2:	55                   	push   %ebp
  1015b3:	89 e5                	mov    %esp,%ebp
  1015b5:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015b8:	e8 e1 ff ff ff       	call   10159e <kbd_intr>
    pic_enable(IRQ_KBD);
  1015bd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015c4:	e8 3d 01 00 00       	call   101706 <pic_enable>
}
  1015c9:	c9                   	leave  
  1015ca:	c3                   	ret    

001015cb <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015cb:	55                   	push   %ebp
  1015cc:	89 e5                	mov    %esp,%ebp
  1015ce:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015d1:	e8 93 f8 ff ff       	call   100e69 <cga_init>
    serial_init();
  1015d6:	e8 74 f9 ff ff       	call   100f4f <serial_init>
    kbd_init();
  1015db:	e8 d2 ff ff ff       	call   1015b2 <kbd_init>
    if (!serial_exists) {
  1015e0:	a1 88 7e 11 00       	mov    0x117e88,%eax
  1015e5:	85 c0                	test   %eax,%eax
  1015e7:	75 0c                	jne    1015f5 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  1015e9:	c7 04 24 a9 61 10 00 	movl   $0x1061a9,(%esp)
  1015f0:	e8 47 ed ff ff       	call   10033c <cprintf>
    }
}
  1015f5:	c9                   	leave  
  1015f6:	c3                   	ret    

001015f7 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015f7:	55                   	push   %ebp
  1015f8:	89 e5                	mov    %esp,%ebp
  1015fa:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  1015fd:	e8 e2 f7 ff ff       	call   100de4 <__intr_save>
  101602:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  101605:	8b 45 08             	mov    0x8(%ebp),%eax
  101608:	89 04 24             	mov    %eax,(%esp)
  10160b:	e8 9b fa ff ff       	call   1010ab <lpt_putc>
        cga_putc(c);
  101610:	8b 45 08             	mov    0x8(%ebp),%eax
  101613:	89 04 24             	mov    %eax,(%esp)
  101616:	e8 cf fa ff ff       	call   1010ea <cga_putc>
        serial_putc(c);
  10161b:	8b 45 08             	mov    0x8(%ebp),%eax
  10161e:	89 04 24             	mov    %eax,(%esp)
  101621:	e8 f1 fc ff ff       	call   101317 <serial_putc>
    }
    local_intr_restore(intr_flag);
  101626:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101629:	89 04 24             	mov    %eax,(%esp)
  10162c:	e8 dd f7 ff ff       	call   100e0e <__intr_restore>
}
  101631:	c9                   	leave  
  101632:	c3                   	ret    

00101633 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101633:	55                   	push   %ebp
  101634:	89 e5                	mov    %esp,%ebp
  101636:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  101639:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  101640:	e8 9f f7 ff ff       	call   100de4 <__intr_save>
  101645:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  101648:	e8 ab fd ff ff       	call   1013f8 <serial_intr>
        kbd_intr();
  10164d:	e8 4c ff ff ff       	call   10159e <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  101652:	8b 15 a0 80 11 00    	mov    0x1180a0,%edx
  101658:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  10165d:	39 c2                	cmp    %eax,%edx
  10165f:	74 31                	je     101692 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  101661:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  101666:	8d 50 01             	lea    0x1(%eax),%edx
  101669:	89 15 a0 80 11 00    	mov    %edx,0x1180a0
  10166f:	0f b6 80 a0 7e 11 00 	movzbl 0x117ea0(%eax),%eax
  101676:	0f b6 c0             	movzbl %al,%eax
  101679:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  10167c:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  101681:	3d 00 02 00 00       	cmp    $0x200,%eax
  101686:	75 0a                	jne    101692 <cons_getc+0x5f>
                cons.rpos = 0;
  101688:	c7 05 a0 80 11 00 00 	movl   $0x0,0x1180a0
  10168f:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  101692:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101695:	89 04 24             	mov    %eax,(%esp)
  101698:	e8 71 f7 ff ff       	call   100e0e <__intr_restore>
    return c;
  10169d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1016a0:	c9                   	leave  
  1016a1:	c3                   	ret    

001016a2 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1016a2:	55                   	push   %ebp
  1016a3:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  1016a5:	fb                   	sti    
    sti();
}
  1016a6:	5d                   	pop    %ebp
  1016a7:	c3                   	ret    

001016a8 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1016a8:	55                   	push   %ebp
  1016a9:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  1016ab:	fa                   	cli    
    cli();
}
  1016ac:	5d                   	pop    %ebp
  1016ad:	c3                   	ret    

001016ae <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016ae:	55                   	push   %ebp
  1016af:	89 e5                	mov    %esp,%ebp
  1016b1:	83 ec 14             	sub    $0x14,%esp
  1016b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1016b7:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016bb:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016bf:	66 a3 70 75 11 00    	mov    %ax,0x117570
    if (did_init) {
  1016c5:	a1 ac 80 11 00       	mov    0x1180ac,%eax
  1016ca:	85 c0                	test   %eax,%eax
  1016cc:	74 36                	je     101704 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016ce:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016d2:	0f b6 c0             	movzbl %al,%eax
  1016d5:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016db:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1016de:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016e2:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016e6:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1016e7:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016eb:	66 c1 e8 08          	shr    $0x8,%ax
  1016ef:	0f b6 c0             	movzbl %al,%eax
  1016f2:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016f8:	88 45 f9             	mov    %al,-0x7(%ebp)
  1016fb:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016ff:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101703:	ee                   	out    %al,(%dx)
    }
}
  101704:	c9                   	leave  
  101705:	c3                   	ret    

00101706 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101706:	55                   	push   %ebp
  101707:	89 e5                	mov    %esp,%ebp
  101709:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  10170c:	8b 45 08             	mov    0x8(%ebp),%eax
  10170f:	ba 01 00 00 00       	mov    $0x1,%edx
  101714:	89 c1                	mov    %eax,%ecx
  101716:	d3 e2                	shl    %cl,%edx
  101718:	89 d0                	mov    %edx,%eax
  10171a:	f7 d0                	not    %eax
  10171c:	89 c2                	mov    %eax,%edx
  10171e:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101725:	21 d0                	and    %edx,%eax
  101727:	0f b7 c0             	movzwl %ax,%eax
  10172a:	89 04 24             	mov    %eax,(%esp)
  10172d:	e8 7c ff ff ff       	call   1016ae <pic_setmask>
}
  101732:	c9                   	leave  
  101733:	c3                   	ret    

00101734 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101734:	55                   	push   %ebp
  101735:	89 e5                	mov    %esp,%ebp
  101737:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  10173a:	c7 05 ac 80 11 00 01 	movl   $0x1,0x1180ac
  101741:	00 00 00 
  101744:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  10174a:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  10174e:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101752:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101756:	ee                   	out    %al,(%dx)
  101757:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  10175d:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  101761:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101765:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101769:	ee                   	out    %al,(%dx)
  10176a:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101770:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  101774:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101778:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10177c:	ee                   	out    %al,(%dx)
  10177d:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  101783:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  101787:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10178b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10178f:	ee                   	out    %al,(%dx)
  101790:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  101796:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  10179a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10179e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017a2:	ee                   	out    %al,(%dx)
  1017a3:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  1017a9:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  1017ad:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1017b1:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017b5:	ee                   	out    %al,(%dx)
  1017b6:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  1017bc:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  1017c0:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017c4:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017c8:	ee                   	out    %al,(%dx)
  1017c9:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  1017cf:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  1017d3:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017d7:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017db:	ee                   	out    %al,(%dx)
  1017dc:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  1017e2:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  1017e6:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017ea:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1017ee:	ee                   	out    %al,(%dx)
  1017ef:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  1017f5:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  1017f9:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  1017fd:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101801:	ee                   	out    %al,(%dx)
  101802:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  101808:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  10180c:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101810:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101814:	ee                   	out    %al,(%dx)
  101815:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  10181b:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  10181f:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101823:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101827:	ee                   	out    %al,(%dx)
  101828:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  10182e:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  101832:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101836:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  10183a:	ee                   	out    %al,(%dx)
  10183b:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  101841:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  101845:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101849:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  10184d:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  10184e:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101855:	66 83 f8 ff          	cmp    $0xffff,%ax
  101859:	74 12                	je     10186d <pic_init+0x139>
        pic_setmask(irq_mask);
  10185b:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101862:	0f b7 c0             	movzwl %ax,%eax
  101865:	89 04 24             	mov    %eax,(%esp)
  101868:	e8 41 fe ff ff       	call   1016ae <pic_setmask>
    }
}
  10186d:	c9                   	leave  
  10186e:	c3                   	ret    

0010186f <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  10186f:	55                   	push   %ebp
  101870:	89 e5                	mov    %esp,%ebp
  101872:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101875:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  10187c:	00 
  10187d:	c7 04 24 e0 61 10 00 	movl   $0x1061e0,(%esp)
  101884:	e8 b3 ea ff ff       	call   10033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  101889:	c9                   	leave  
  10188a:	c3                   	ret    

0010188b <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  10188b:	55                   	push   %ebp
  10188c:	89 e5                	mov    %esp,%ebp
  10188e:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	   extern uintptr_t __vectors[];
	    int i;
	    for (i = 0; i < 256; i++)
  101891:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101898:	e9 e2 00 00 00       	jmp    10197f <idt_init+0xf4>
	        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], i == T_SYSCALL ? DPL_USER : DPL_KERNEL);
  10189d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018a0:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  1018a7:	89 c2                	mov    %eax,%edx
  1018a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ac:	66 89 14 c5 c0 80 11 	mov    %dx,0x1180c0(,%eax,8)
  1018b3:	00 
  1018b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018b7:	66 c7 04 c5 c2 80 11 	movw   $0x8,0x1180c2(,%eax,8)
  1018be:	00 08 00 
  1018c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018c4:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1018cb:	00 
  1018cc:	83 e2 e0             	and    $0xffffffe0,%edx
  1018cf:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  1018d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d9:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1018e0:	00 
  1018e1:	83 e2 1f             	and    $0x1f,%edx
  1018e4:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  1018eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ee:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  1018f5:	00 
  1018f6:	83 e2 f0             	and    $0xfffffff0,%edx
  1018f9:	83 ca 0e             	or     $0xe,%edx
  1018fc:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101903:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101906:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  10190d:	00 
  10190e:	83 e2 ef             	and    $0xffffffef,%edx
  101911:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101918:	81 7d fc 80 00 00 00 	cmpl   $0x80,-0x4(%ebp)
  10191f:	75 07                	jne    101928 <idt_init+0x9d>
  101921:	ba 03 00 00 00       	mov    $0x3,%edx
  101926:	eb 05                	jmp    10192d <idt_init+0xa2>
  101928:	ba 00 00 00 00       	mov    $0x0,%edx
  10192d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101930:	83 e2 03             	and    $0x3,%edx
  101933:	89 d1                	mov    %edx,%ecx
  101935:	c1 e1 05             	shl    $0x5,%ecx
  101938:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  10193f:	00 
  101940:	83 e2 9f             	and    $0xffffff9f,%edx
  101943:	09 ca                	or     %ecx,%edx
  101945:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  10194c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10194f:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101956:	00 
  101957:	83 ca 80             	or     $0xffffff80,%edx
  10195a:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101961:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101964:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  10196b:	c1 e8 10             	shr    $0x10,%eax
  10196e:	89 c2                	mov    %eax,%edx
  101970:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101973:	66 89 14 c5 c6 80 11 	mov    %dx,0x1180c6(,%eax,8)
  10197a:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	   extern uintptr_t __vectors[];
	    int i;
	    for (i = 0; i < 256; i++)
  10197b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10197f:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  101986:	0f 8e 11 ff ff ff    	jle    10189d <idt_init+0x12>
  10198c:	c7 45 f8 80 75 11 00 	movl   $0x117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101993:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101996:	0f 01 18             	lidtl  (%eax)
	        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], i == T_SYSCALL ? DPL_USER : DPL_KERNEL);
	    lidt(&idt_pd);
}
  101999:	c9                   	leave  
  10199a:	c3                   	ret    

0010199b <trapname>:

static const char *
trapname(int trapno) {
  10199b:	55                   	push   %ebp
  10199c:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  10199e:	8b 45 08             	mov    0x8(%ebp),%eax
  1019a1:	83 f8 13             	cmp    $0x13,%eax
  1019a4:	77 0c                	ja     1019b2 <trapname+0x17>
        return excnames[trapno];
  1019a6:	8b 45 08             	mov    0x8(%ebp),%eax
  1019a9:	8b 04 85 40 65 10 00 	mov    0x106540(,%eax,4),%eax
  1019b0:	eb 18                	jmp    1019ca <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  1019b2:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  1019b6:	7e 0d                	jle    1019c5 <trapname+0x2a>
  1019b8:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  1019bc:	7f 07                	jg     1019c5 <trapname+0x2a>
        return "Hardware Interrupt";
  1019be:	b8 ea 61 10 00       	mov    $0x1061ea,%eax
  1019c3:	eb 05                	jmp    1019ca <trapname+0x2f>
    }
    return "(unknown trap)";
  1019c5:	b8 fd 61 10 00       	mov    $0x1061fd,%eax
}
  1019ca:	5d                   	pop    %ebp
  1019cb:	c3                   	ret    

001019cc <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  1019cc:	55                   	push   %ebp
  1019cd:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  1019cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1019d2:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1019d6:	66 83 f8 08          	cmp    $0x8,%ax
  1019da:	0f 94 c0             	sete   %al
  1019dd:	0f b6 c0             	movzbl %al,%eax
}
  1019e0:	5d                   	pop    %ebp
  1019e1:	c3                   	ret    

001019e2 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  1019e2:	55                   	push   %ebp
  1019e3:	89 e5                	mov    %esp,%ebp
  1019e5:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  1019e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1019eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019ef:	c7 04 24 3e 62 10 00 	movl   $0x10623e,(%esp)
  1019f6:	e8 41 e9 ff ff       	call   10033c <cprintf>
    print_regs(&tf->tf_regs);
  1019fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1019fe:	89 04 24             	mov    %eax,(%esp)
  101a01:	e8 a1 01 00 00       	call   101ba7 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a06:	8b 45 08             	mov    0x8(%ebp),%eax
  101a09:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a0d:	0f b7 c0             	movzwl %ax,%eax
  101a10:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a14:	c7 04 24 4f 62 10 00 	movl   $0x10624f,(%esp)
  101a1b:	e8 1c e9 ff ff       	call   10033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a20:	8b 45 08             	mov    0x8(%ebp),%eax
  101a23:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a27:	0f b7 c0             	movzwl %ax,%eax
  101a2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a2e:	c7 04 24 62 62 10 00 	movl   $0x106262,(%esp)
  101a35:	e8 02 e9 ff ff       	call   10033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  101a3d:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a41:	0f b7 c0             	movzwl %ax,%eax
  101a44:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a48:	c7 04 24 75 62 10 00 	movl   $0x106275,(%esp)
  101a4f:	e8 e8 e8 ff ff       	call   10033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a54:	8b 45 08             	mov    0x8(%ebp),%eax
  101a57:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a5b:	0f b7 c0             	movzwl %ax,%eax
  101a5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a62:	c7 04 24 88 62 10 00 	movl   $0x106288,(%esp)
  101a69:	e8 ce e8 ff ff       	call   10033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  101a71:	8b 40 30             	mov    0x30(%eax),%eax
  101a74:	89 04 24             	mov    %eax,(%esp)
  101a77:	e8 1f ff ff ff       	call   10199b <trapname>
  101a7c:	8b 55 08             	mov    0x8(%ebp),%edx
  101a7f:	8b 52 30             	mov    0x30(%edx),%edx
  101a82:	89 44 24 08          	mov    %eax,0x8(%esp)
  101a86:	89 54 24 04          	mov    %edx,0x4(%esp)
  101a8a:	c7 04 24 9b 62 10 00 	movl   $0x10629b,(%esp)
  101a91:	e8 a6 e8 ff ff       	call   10033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101a96:	8b 45 08             	mov    0x8(%ebp),%eax
  101a99:	8b 40 34             	mov    0x34(%eax),%eax
  101a9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aa0:	c7 04 24 ad 62 10 00 	movl   $0x1062ad,(%esp)
  101aa7:	e8 90 e8 ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101aac:	8b 45 08             	mov    0x8(%ebp),%eax
  101aaf:	8b 40 38             	mov    0x38(%eax),%eax
  101ab2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ab6:	c7 04 24 bc 62 10 00 	movl   $0x1062bc,(%esp)
  101abd:	e8 7a e8 ff ff       	call   10033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac5:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ac9:	0f b7 c0             	movzwl %ax,%eax
  101acc:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ad0:	c7 04 24 cb 62 10 00 	movl   $0x1062cb,(%esp)
  101ad7:	e8 60 e8 ff ff       	call   10033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101adc:	8b 45 08             	mov    0x8(%ebp),%eax
  101adf:	8b 40 40             	mov    0x40(%eax),%eax
  101ae2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ae6:	c7 04 24 de 62 10 00 	movl   $0x1062de,(%esp)
  101aed:	e8 4a e8 ff ff       	call   10033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101af2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101af9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b00:	eb 3e                	jmp    101b40 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b02:	8b 45 08             	mov    0x8(%ebp),%eax
  101b05:	8b 50 40             	mov    0x40(%eax),%edx
  101b08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b0b:	21 d0                	and    %edx,%eax
  101b0d:	85 c0                	test   %eax,%eax
  101b0f:	74 28                	je     101b39 <print_trapframe+0x157>
  101b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b14:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101b1b:	85 c0                	test   %eax,%eax
  101b1d:	74 1a                	je     101b39 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b22:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101b29:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b2d:	c7 04 24 ed 62 10 00 	movl   $0x1062ed,(%esp)
  101b34:	e8 03 e8 ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b39:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101b3d:	d1 65 f0             	shll   -0x10(%ebp)
  101b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b43:	83 f8 17             	cmp    $0x17,%eax
  101b46:	76 ba                	jbe    101b02 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b48:	8b 45 08             	mov    0x8(%ebp),%eax
  101b4b:	8b 40 40             	mov    0x40(%eax),%eax
  101b4e:	25 00 30 00 00       	and    $0x3000,%eax
  101b53:	c1 e8 0c             	shr    $0xc,%eax
  101b56:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b5a:	c7 04 24 f1 62 10 00 	movl   $0x1062f1,(%esp)
  101b61:	e8 d6 e7 ff ff       	call   10033c <cprintf>

    if (!trap_in_kernel(tf)) {
  101b66:	8b 45 08             	mov    0x8(%ebp),%eax
  101b69:	89 04 24             	mov    %eax,(%esp)
  101b6c:	e8 5b fe ff ff       	call   1019cc <trap_in_kernel>
  101b71:	85 c0                	test   %eax,%eax
  101b73:	75 30                	jne    101ba5 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101b75:	8b 45 08             	mov    0x8(%ebp),%eax
  101b78:	8b 40 44             	mov    0x44(%eax),%eax
  101b7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b7f:	c7 04 24 fa 62 10 00 	movl   $0x1062fa,(%esp)
  101b86:	e8 b1 e7 ff ff       	call   10033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b8e:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101b92:	0f b7 c0             	movzwl %ax,%eax
  101b95:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b99:	c7 04 24 09 63 10 00 	movl   $0x106309,(%esp)
  101ba0:	e8 97 e7 ff ff       	call   10033c <cprintf>
    }
}
  101ba5:	c9                   	leave  
  101ba6:	c3                   	ret    

00101ba7 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101ba7:	55                   	push   %ebp
  101ba8:	89 e5                	mov    %esp,%ebp
  101baa:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101bad:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb0:	8b 00                	mov    (%eax),%eax
  101bb2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bb6:	c7 04 24 1c 63 10 00 	movl   $0x10631c,(%esp)
  101bbd:	e8 7a e7 ff ff       	call   10033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc5:	8b 40 04             	mov    0x4(%eax),%eax
  101bc8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bcc:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  101bd3:	e8 64 e7 ff ff       	call   10033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  101bdb:	8b 40 08             	mov    0x8(%eax),%eax
  101bde:	89 44 24 04          	mov    %eax,0x4(%esp)
  101be2:	c7 04 24 3a 63 10 00 	movl   $0x10633a,(%esp)
  101be9:	e8 4e e7 ff ff       	call   10033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101bee:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf1:	8b 40 0c             	mov    0xc(%eax),%eax
  101bf4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bf8:	c7 04 24 49 63 10 00 	movl   $0x106349,(%esp)
  101bff:	e8 38 e7 ff ff       	call   10033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c04:	8b 45 08             	mov    0x8(%ebp),%eax
  101c07:	8b 40 10             	mov    0x10(%eax),%eax
  101c0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c0e:	c7 04 24 58 63 10 00 	movl   $0x106358,(%esp)
  101c15:	e8 22 e7 ff ff       	call   10033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  101c1d:	8b 40 14             	mov    0x14(%eax),%eax
  101c20:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c24:	c7 04 24 67 63 10 00 	movl   $0x106367,(%esp)
  101c2b:	e8 0c e7 ff ff       	call   10033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c30:	8b 45 08             	mov    0x8(%ebp),%eax
  101c33:	8b 40 18             	mov    0x18(%eax),%eax
  101c36:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c3a:	c7 04 24 76 63 10 00 	movl   $0x106376,(%esp)
  101c41:	e8 f6 e6 ff ff       	call   10033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c46:	8b 45 08             	mov    0x8(%ebp),%eax
  101c49:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c50:	c7 04 24 85 63 10 00 	movl   $0x106385,(%esp)
  101c57:	e8 e0 e6 ff ff       	call   10033c <cprintf>
}
  101c5c:	c9                   	leave  
  101c5d:	c3                   	ret    

00101c5e <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101c5e:	55                   	push   %ebp
  101c5f:	89 e5                	mov    %esp,%ebp
  101c61:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101c64:	8b 45 08             	mov    0x8(%ebp),%eax
  101c67:	8b 40 30             	mov    0x30(%eax),%eax
  101c6a:	83 f8 2f             	cmp    $0x2f,%eax
  101c6d:	77 1d                	ja     101c8c <trap_dispatch+0x2e>
  101c6f:	83 f8 2e             	cmp    $0x2e,%eax
  101c72:	0f 83 ed 00 00 00    	jae    101d65 <trap_dispatch+0x107>
  101c78:	83 f8 21             	cmp    $0x21,%eax
  101c7b:	74 6e                	je     101ceb <trap_dispatch+0x8d>
  101c7d:	83 f8 24             	cmp    $0x24,%eax
  101c80:	74 43                	je     101cc5 <trap_dispatch+0x67>
  101c82:	83 f8 20             	cmp    $0x20,%eax
  101c85:	74 13                	je     101c9a <trap_dispatch+0x3c>
  101c87:	e9 a1 00 00 00       	jmp    101d2d <trap_dispatch+0xcf>
  101c8c:	83 e8 78             	sub    $0x78,%eax
  101c8f:	83 f8 01             	cmp    $0x1,%eax
  101c92:	0f 87 95 00 00 00    	ja     101d2d <trap_dispatch+0xcf>
  101c98:	eb 77                	jmp    101d11 <trap_dispatch+0xb3>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
    	if (++ticks == TICK_NUM) {
  101c9a:	a1 4c 89 11 00       	mov    0x11894c,%eax
  101c9f:	83 c0 01             	add    $0x1,%eax
  101ca2:	a3 4c 89 11 00       	mov    %eax,0x11894c
  101ca7:	83 f8 64             	cmp    $0x64,%eax
  101caa:	75 14                	jne    101cc0 <trap_dispatch+0x62>
    		print_ticks();
  101cac:	e8 be fb ff ff       	call   10186f <print_ticks>
    		ticks = 0;
  101cb1:	c7 05 4c 89 11 00 00 	movl   $0x0,0x11894c
  101cb8:	00 00 00 
    	}
        break;
  101cbb:	e9 a6 00 00 00       	jmp    101d66 <trap_dispatch+0x108>
  101cc0:	e9 a1 00 00 00       	jmp    101d66 <trap_dispatch+0x108>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101cc5:	e8 69 f9 ff ff       	call   101633 <cons_getc>
  101cca:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101ccd:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101cd1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101cd5:	89 54 24 08          	mov    %edx,0x8(%esp)
  101cd9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cdd:	c7 04 24 94 63 10 00 	movl   $0x106394,(%esp)
  101ce4:	e8 53 e6 ff ff       	call   10033c <cprintf>
        break;
  101ce9:	eb 7b                	jmp    101d66 <trap_dispatch+0x108>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101ceb:	e8 43 f9 ff ff       	call   101633 <cons_getc>
  101cf0:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101cf3:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101cf7:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101cfb:	89 54 24 08          	mov    %edx,0x8(%esp)
  101cff:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d03:	c7 04 24 a6 63 10 00 	movl   $0x1063a6,(%esp)
  101d0a:	e8 2d e6 ff ff       	call   10033c <cprintf>
        break;
  101d0f:	eb 55                	jmp    101d66 <trap_dispatch+0x108>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101d11:	c7 44 24 08 b5 63 10 	movl   $0x1063b5,0x8(%esp)
  101d18:	00 
  101d19:	c7 44 24 04 ab 00 00 	movl   $0xab,0x4(%esp)
  101d20:	00 
  101d21:	c7 04 24 c5 63 10 00 	movl   $0x1063c5,(%esp)
  101d28:	e8 98 ef ff ff       	call   100cc5 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  101d30:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d34:	0f b7 c0             	movzwl %ax,%eax
  101d37:	83 e0 03             	and    $0x3,%eax
  101d3a:	85 c0                	test   %eax,%eax
  101d3c:	75 28                	jne    101d66 <trap_dispatch+0x108>
            print_trapframe(tf);
  101d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  101d41:	89 04 24             	mov    %eax,(%esp)
  101d44:	e8 99 fc ff ff       	call   1019e2 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101d49:	c7 44 24 08 d6 63 10 	movl   $0x1063d6,0x8(%esp)
  101d50:	00 
  101d51:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
  101d58:	00 
  101d59:	c7 04 24 c5 63 10 00 	movl   $0x1063c5,(%esp)
  101d60:	e8 60 ef ff ff       	call   100cc5 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101d65:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101d66:	c9                   	leave  
  101d67:	c3                   	ret    

00101d68 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101d68:	55                   	push   %ebp
  101d69:	89 e5                	mov    %esp,%ebp
  101d6b:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  101d71:	89 04 24             	mov    %eax,(%esp)
  101d74:	e8 e5 fe ff ff       	call   101c5e <trap_dispatch>
}
  101d79:	c9                   	leave  
  101d7a:	c3                   	ret    

00101d7b <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101d7b:	1e                   	push   %ds
    pushl %es
  101d7c:	06                   	push   %es
    pushl %fs
  101d7d:	0f a0                	push   %fs
    pushl %gs
  101d7f:	0f a8                	push   %gs
    pushal
  101d81:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101d82:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101d87:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101d89:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101d8b:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101d8c:	e8 d7 ff ff ff       	call   101d68 <trap>

    # pop the pushed stack pointer
    popl %esp
  101d91:	5c                   	pop    %esp

00101d92 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101d92:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101d93:	0f a9                	pop    %gs
    popl %fs
  101d95:	0f a1                	pop    %fs
    popl %es
  101d97:	07                   	pop    %es
    popl %ds
  101d98:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101d99:	83 c4 08             	add    $0x8,%esp
    iret
  101d9c:	cf                   	iret   

00101d9d <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101d9d:	6a 00                	push   $0x0
  pushl $0
  101d9f:	6a 00                	push   $0x0
  jmp __alltraps
  101da1:	e9 d5 ff ff ff       	jmp    101d7b <__alltraps>

00101da6 <vector1>:
.globl vector1
vector1:
  pushl $0
  101da6:	6a 00                	push   $0x0
  pushl $1
  101da8:	6a 01                	push   $0x1
  jmp __alltraps
  101daa:	e9 cc ff ff ff       	jmp    101d7b <__alltraps>

00101daf <vector2>:
.globl vector2
vector2:
  pushl $0
  101daf:	6a 00                	push   $0x0
  pushl $2
  101db1:	6a 02                	push   $0x2
  jmp __alltraps
  101db3:	e9 c3 ff ff ff       	jmp    101d7b <__alltraps>

00101db8 <vector3>:
.globl vector3
vector3:
  pushl $0
  101db8:	6a 00                	push   $0x0
  pushl $3
  101dba:	6a 03                	push   $0x3
  jmp __alltraps
  101dbc:	e9 ba ff ff ff       	jmp    101d7b <__alltraps>

00101dc1 <vector4>:
.globl vector4
vector4:
  pushl $0
  101dc1:	6a 00                	push   $0x0
  pushl $4
  101dc3:	6a 04                	push   $0x4
  jmp __alltraps
  101dc5:	e9 b1 ff ff ff       	jmp    101d7b <__alltraps>

00101dca <vector5>:
.globl vector5
vector5:
  pushl $0
  101dca:	6a 00                	push   $0x0
  pushl $5
  101dcc:	6a 05                	push   $0x5
  jmp __alltraps
  101dce:	e9 a8 ff ff ff       	jmp    101d7b <__alltraps>

00101dd3 <vector6>:
.globl vector6
vector6:
  pushl $0
  101dd3:	6a 00                	push   $0x0
  pushl $6
  101dd5:	6a 06                	push   $0x6
  jmp __alltraps
  101dd7:	e9 9f ff ff ff       	jmp    101d7b <__alltraps>

00101ddc <vector7>:
.globl vector7
vector7:
  pushl $0
  101ddc:	6a 00                	push   $0x0
  pushl $7
  101dde:	6a 07                	push   $0x7
  jmp __alltraps
  101de0:	e9 96 ff ff ff       	jmp    101d7b <__alltraps>

00101de5 <vector8>:
.globl vector8
vector8:
  pushl $8
  101de5:	6a 08                	push   $0x8
  jmp __alltraps
  101de7:	e9 8f ff ff ff       	jmp    101d7b <__alltraps>

00101dec <vector9>:
.globl vector9
vector9:
  pushl $9
  101dec:	6a 09                	push   $0x9
  jmp __alltraps
  101dee:	e9 88 ff ff ff       	jmp    101d7b <__alltraps>

00101df3 <vector10>:
.globl vector10
vector10:
  pushl $10
  101df3:	6a 0a                	push   $0xa
  jmp __alltraps
  101df5:	e9 81 ff ff ff       	jmp    101d7b <__alltraps>

00101dfa <vector11>:
.globl vector11
vector11:
  pushl $11
  101dfa:	6a 0b                	push   $0xb
  jmp __alltraps
  101dfc:	e9 7a ff ff ff       	jmp    101d7b <__alltraps>

00101e01 <vector12>:
.globl vector12
vector12:
  pushl $12
  101e01:	6a 0c                	push   $0xc
  jmp __alltraps
  101e03:	e9 73 ff ff ff       	jmp    101d7b <__alltraps>

00101e08 <vector13>:
.globl vector13
vector13:
  pushl $13
  101e08:	6a 0d                	push   $0xd
  jmp __alltraps
  101e0a:	e9 6c ff ff ff       	jmp    101d7b <__alltraps>

00101e0f <vector14>:
.globl vector14
vector14:
  pushl $14
  101e0f:	6a 0e                	push   $0xe
  jmp __alltraps
  101e11:	e9 65 ff ff ff       	jmp    101d7b <__alltraps>

00101e16 <vector15>:
.globl vector15
vector15:
  pushl $0
  101e16:	6a 00                	push   $0x0
  pushl $15
  101e18:	6a 0f                	push   $0xf
  jmp __alltraps
  101e1a:	e9 5c ff ff ff       	jmp    101d7b <__alltraps>

00101e1f <vector16>:
.globl vector16
vector16:
  pushl $0
  101e1f:	6a 00                	push   $0x0
  pushl $16
  101e21:	6a 10                	push   $0x10
  jmp __alltraps
  101e23:	e9 53 ff ff ff       	jmp    101d7b <__alltraps>

00101e28 <vector17>:
.globl vector17
vector17:
  pushl $17
  101e28:	6a 11                	push   $0x11
  jmp __alltraps
  101e2a:	e9 4c ff ff ff       	jmp    101d7b <__alltraps>

00101e2f <vector18>:
.globl vector18
vector18:
  pushl $0
  101e2f:	6a 00                	push   $0x0
  pushl $18
  101e31:	6a 12                	push   $0x12
  jmp __alltraps
  101e33:	e9 43 ff ff ff       	jmp    101d7b <__alltraps>

00101e38 <vector19>:
.globl vector19
vector19:
  pushl $0
  101e38:	6a 00                	push   $0x0
  pushl $19
  101e3a:	6a 13                	push   $0x13
  jmp __alltraps
  101e3c:	e9 3a ff ff ff       	jmp    101d7b <__alltraps>

00101e41 <vector20>:
.globl vector20
vector20:
  pushl $0
  101e41:	6a 00                	push   $0x0
  pushl $20
  101e43:	6a 14                	push   $0x14
  jmp __alltraps
  101e45:	e9 31 ff ff ff       	jmp    101d7b <__alltraps>

00101e4a <vector21>:
.globl vector21
vector21:
  pushl $0
  101e4a:	6a 00                	push   $0x0
  pushl $21
  101e4c:	6a 15                	push   $0x15
  jmp __alltraps
  101e4e:	e9 28 ff ff ff       	jmp    101d7b <__alltraps>

00101e53 <vector22>:
.globl vector22
vector22:
  pushl $0
  101e53:	6a 00                	push   $0x0
  pushl $22
  101e55:	6a 16                	push   $0x16
  jmp __alltraps
  101e57:	e9 1f ff ff ff       	jmp    101d7b <__alltraps>

00101e5c <vector23>:
.globl vector23
vector23:
  pushl $0
  101e5c:	6a 00                	push   $0x0
  pushl $23
  101e5e:	6a 17                	push   $0x17
  jmp __alltraps
  101e60:	e9 16 ff ff ff       	jmp    101d7b <__alltraps>

00101e65 <vector24>:
.globl vector24
vector24:
  pushl $0
  101e65:	6a 00                	push   $0x0
  pushl $24
  101e67:	6a 18                	push   $0x18
  jmp __alltraps
  101e69:	e9 0d ff ff ff       	jmp    101d7b <__alltraps>

00101e6e <vector25>:
.globl vector25
vector25:
  pushl $0
  101e6e:	6a 00                	push   $0x0
  pushl $25
  101e70:	6a 19                	push   $0x19
  jmp __alltraps
  101e72:	e9 04 ff ff ff       	jmp    101d7b <__alltraps>

00101e77 <vector26>:
.globl vector26
vector26:
  pushl $0
  101e77:	6a 00                	push   $0x0
  pushl $26
  101e79:	6a 1a                	push   $0x1a
  jmp __alltraps
  101e7b:	e9 fb fe ff ff       	jmp    101d7b <__alltraps>

00101e80 <vector27>:
.globl vector27
vector27:
  pushl $0
  101e80:	6a 00                	push   $0x0
  pushl $27
  101e82:	6a 1b                	push   $0x1b
  jmp __alltraps
  101e84:	e9 f2 fe ff ff       	jmp    101d7b <__alltraps>

00101e89 <vector28>:
.globl vector28
vector28:
  pushl $0
  101e89:	6a 00                	push   $0x0
  pushl $28
  101e8b:	6a 1c                	push   $0x1c
  jmp __alltraps
  101e8d:	e9 e9 fe ff ff       	jmp    101d7b <__alltraps>

00101e92 <vector29>:
.globl vector29
vector29:
  pushl $0
  101e92:	6a 00                	push   $0x0
  pushl $29
  101e94:	6a 1d                	push   $0x1d
  jmp __alltraps
  101e96:	e9 e0 fe ff ff       	jmp    101d7b <__alltraps>

00101e9b <vector30>:
.globl vector30
vector30:
  pushl $0
  101e9b:	6a 00                	push   $0x0
  pushl $30
  101e9d:	6a 1e                	push   $0x1e
  jmp __alltraps
  101e9f:	e9 d7 fe ff ff       	jmp    101d7b <__alltraps>

00101ea4 <vector31>:
.globl vector31
vector31:
  pushl $0
  101ea4:	6a 00                	push   $0x0
  pushl $31
  101ea6:	6a 1f                	push   $0x1f
  jmp __alltraps
  101ea8:	e9 ce fe ff ff       	jmp    101d7b <__alltraps>

00101ead <vector32>:
.globl vector32
vector32:
  pushl $0
  101ead:	6a 00                	push   $0x0
  pushl $32
  101eaf:	6a 20                	push   $0x20
  jmp __alltraps
  101eb1:	e9 c5 fe ff ff       	jmp    101d7b <__alltraps>

00101eb6 <vector33>:
.globl vector33
vector33:
  pushl $0
  101eb6:	6a 00                	push   $0x0
  pushl $33
  101eb8:	6a 21                	push   $0x21
  jmp __alltraps
  101eba:	e9 bc fe ff ff       	jmp    101d7b <__alltraps>

00101ebf <vector34>:
.globl vector34
vector34:
  pushl $0
  101ebf:	6a 00                	push   $0x0
  pushl $34
  101ec1:	6a 22                	push   $0x22
  jmp __alltraps
  101ec3:	e9 b3 fe ff ff       	jmp    101d7b <__alltraps>

00101ec8 <vector35>:
.globl vector35
vector35:
  pushl $0
  101ec8:	6a 00                	push   $0x0
  pushl $35
  101eca:	6a 23                	push   $0x23
  jmp __alltraps
  101ecc:	e9 aa fe ff ff       	jmp    101d7b <__alltraps>

00101ed1 <vector36>:
.globl vector36
vector36:
  pushl $0
  101ed1:	6a 00                	push   $0x0
  pushl $36
  101ed3:	6a 24                	push   $0x24
  jmp __alltraps
  101ed5:	e9 a1 fe ff ff       	jmp    101d7b <__alltraps>

00101eda <vector37>:
.globl vector37
vector37:
  pushl $0
  101eda:	6a 00                	push   $0x0
  pushl $37
  101edc:	6a 25                	push   $0x25
  jmp __alltraps
  101ede:	e9 98 fe ff ff       	jmp    101d7b <__alltraps>

00101ee3 <vector38>:
.globl vector38
vector38:
  pushl $0
  101ee3:	6a 00                	push   $0x0
  pushl $38
  101ee5:	6a 26                	push   $0x26
  jmp __alltraps
  101ee7:	e9 8f fe ff ff       	jmp    101d7b <__alltraps>

00101eec <vector39>:
.globl vector39
vector39:
  pushl $0
  101eec:	6a 00                	push   $0x0
  pushl $39
  101eee:	6a 27                	push   $0x27
  jmp __alltraps
  101ef0:	e9 86 fe ff ff       	jmp    101d7b <__alltraps>

00101ef5 <vector40>:
.globl vector40
vector40:
  pushl $0
  101ef5:	6a 00                	push   $0x0
  pushl $40
  101ef7:	6a 28                	push   $0x28
  jmp __alltraps
  101ef9:	e9 7d fe ff ff       	jmp    101d7b <__alltraps>

00101efe <vector41>:
.globl vector41
vector41:
  pushl $0
  101efe:	6a 00                	push   $0x0
  pushl $41
  101f00:	6a 29                	push   $0x29
  jmp __alltraps
  101f02:	e9 74 fe ff ff       	jmp    101d7b <__alltraps>

00101f07 <vector42>:
.globl vector42
vector42:
  pushl $0
  101f07:	6a 00                	push   $0x0
  pushl $42
  101f09:	6a 2a                	push   $0x2a
  jmp __alltraps
  101f0b:	e9 6b fe ff ff       	jmp    101d7b <__alltraps>

00101f10 <vector43>:
.globl vector43
vector43:
  pushl $0
  101f10:	6a 00                	push   $0x0
  pushl $43
  101f12:	6a 2b                	push   $0x2b
  jmp __alltraps
  101f14:	e9 62 fe ff ff       	jmp    101d7b <__alltraps>

00101f19 <vector44>:
.globl vector44
vector44:
  pushl $0
  101f19:	6a 00                	push   $0x0
  pushl $44
  101f1b:	6a 2c                	push   $0x2c
  jmp __alltraps
  101f1d:	e9 59 fe ff ff       	jmp    101d7b <__alltraps>

00101f22 <vector45>:
.globl vector45
vector45:
  pushl $0
  101f22:	6a 00                	push   $0x0
  pushl $45
  101f24:	6a 2d                	push   $0x2d
  jmp __alltraps
  101f26:	e9 50 fe ff ff       	jmp    101d7b <__alltraps>

00101f2b <vector46>:
.globl vector46
vector46:
  pushl $0
  101f2b:	6a 00                	push   $0x0
  pushl $46
  101f2d:	6a 2e                	push   $0x2e
  jmp __alltraps
  101f2f:	e9 47 fe ff ff       	jmp    101d7b <__alltraps>

00101f34 <vector47>:
.globl vector47
vector47:
  pushl $0
  101f34:	6a 00                	push   $0x0
  pushl $47
  101f36:	6a 2f                	push   $0x2f
  jmp __alltraps
  101f38:	e9 3e fe ff ff       	jmp    101d7b <__alltraps>

00101f3d <vector48>:
.globl vector48
vector48:
  pushl $0
  101f3d:	6a 00                	push   $0x0
  pushl $48
  101f3f:	6a 30                	push   $0x30
  jmp __alltraps
  101f41:	e9 35 fe ff ff       	jmp    101d7b <__alltraps>

00101f46 <vector49>:
.globl vector49
vector49:
  pushl $0
  101f46:	6a 00                	push   $0x0
  pushl $49
  101f48:	6a 31                	push   $0x31
  jmp __alltraps
  101f4a:	e9 2c fe ff ff       	jmp    101d7b <__alltraps>

00101f4f <vector50>:
.globl vector50
vector50:
  pushl $0
  101f4f:	6a 00                	push   $0x0
  pushl $50
  101f51:	6a 32                	push   $0x32
  jmp __alltraps
  101f53:	e9 23 fe ff ff       	jmp    101d7b <__alltraps>

00101f58 <vector51>:
.globl vector51
vector51:
  pushl $0
  101f58:	6a 00                	push   $0x0
  pushl $51
  101f5a:	6a 33                	push   $0x33
  jmp __alltraps
  101f5c:	e9 1a fe ff ff       	jmp    101d7b <__alltraps>

00101f61 <vector52>:
.globl vector52
vector52:
  pushl $0
  101f61:	6a 00                	push   $0x0
  pushl $52
  101f63:	6a 34                	push   $0x34
  jmp __alltraps
  101f65:	e9 11 fe ff ff       	jmp    101d7b <__alltraps>

00101f6a <vector53>:
.globl vector53
vector53:
  pushl $0
  101f6a:	6a 00                	push   $0x0
  pushl $53
  101f6c:	6a 35                	push   $0x35
  jmp __alltraps
  101f6e:	e9 08 fe ff ff       	jmp    101d7b <__alltraps>

00101f73 <vector54>:
.globl vector54
vector54:
  pushl $0
  101f73:	6a 00                	push   $0x0
  pushl $54
  101f75:	6a 36                	push   $0x36
  jmp __alltraps
  101f77:	e9 ff fd ff ff       	jmp    101d7b <__alltraps>

00101f7c <vector55>:
.globl vector55
vector55:
  pushl $0
  101f7c:	6a 00                	push   $0x0
  pushl $55
  101f7e:	6a 37                	push   $0x37
  jmp __alltraps
  101f80:	e9 f6 fd ff ff       	jmp    101d7b <__alltraps>

00101f85 <vector56>:
.globl vector56
vector56:
  pushl $0
  101f85:	6a 00                	push   $0x0
  pushl $56
  101f87:	6a 38                	push   $0x38
  jmp __alltraps
  101f89:	e9 ed fd ff ff       	jmp    101d7b <__alltraps>

00101f8e <vector57>:
.globl vector57
vector57:
  pushl $0
  101f8e:	6a 00                	push   $0x0
  pushl $57
  101f90:	6a 39                	push   $0x39
  jmp __alltraps
  101f92:	e9 e4 fd ff ff       	jmp    101d7b <__alltraps>

00101f97 <vector58>:
.globl vector58
vector58:
  pushl $0
  101f97:	6a 00                	push   $0x0
  pushl $58
  101f99:	6a 3a                	push   $0x3a
  jmp __alltraps
  101f9b:	e9 db fd ff ff       	jmp    101d7b <__alltraps>

00101fa0 <vector59>:
.globl vector59
vector59:
  pushl $0
  101fa0:	6a 00                	push   $0x0
  pushl $59
  101fa2:	6a 3b                	push   $0x3b
  jmp __alltraps
  101fa4:	e9 d2 fd ff ff       	jmp    101d7b <__alltraps>

00101fa9 <vector60>:
.globl vector60
vector60:
  pushl $0
  101fa9:	6a 00                	push   $0x0
  pushl $60
  101fab:	6a 3c                	push   $0x3c
  jmp __alltraps
  101fad:	e9 c9 fd ff ff       	jmp    101d7b <__alltraps>

00101fb2 <vector61>:
.globl vector61
vector61:
  pushl $0
  101fb2:	6a 00                	push   $0x0
  pushl $61
  101fb4:	6a 3d                	push   $0x3d
  jmp __alltraps
  101fb6:	e9 c0 fd ff ff       	jmp    101d7b <__alltraps>

00101fbb <vector62>:
.globl vector62
vector62:
  pushl $0
  101fbb:	6a 00                	push   $0x0
  pushl $62
  101fbd:	6a 3e                	push   $0x3e
  jmp __alltraps
  101fbf:	e9 b7 fd ff ff       	jmp    101d7b <__alltraps>

00101fc4 <vector63>:
.globl vector63
vector63:
  pushl $0
  101fc4:	6a 00                	push   $0x0
  pushl $63
  101fc6:	6a 3f                	push   $0x3f
  jmp __alltraps
  101fc8:	e9 ae fd ff ff       	jmp    101d7b <__alltraps>

00101fcd <vector64>:
.globl vector64
vector64:
  pushl $0
  101fcd:	6a 00                	push   $0x0
  pushl $64
  101fcf:	6a 40                	push   $0x40
  jmp __alltraps
  101fd1:	e9 a5 fd ff ff       	jmp    101d7b <__alltraps>

00101fd6 <vector65>:
.globl vector65
vector65:
  pushl $0
  101fd6:	6a 00                	push   $0x0
  pushl $65
  101fd8:	6a 41                	push   $0x41
  jmp __alltraps
  101fda:	e9 9c fd ff ff       	jmp    101d7b <__alltraps>

00101fdf <vector66>:
.globl vector66
vector66:
  pushl $0
  101fdf:	6a 00                	push   $0x0
  pushl $66
  101fe1:	6a 42                	push   $0x42
  jmp __alltraps
  101fe3:	e9 93 fd ff ff       	jmp    101d7b <__alltraps>

00101fe8 <vector67>:
.globl vector67
vector67:
  pushl $0
  101fe8:	6a 00                	push   $0x0
  pushl $67
  101fea:	6a 43                	push   $0x43
  jmp __alltraps
  101fec:	e9 8a fd ff ff       	jmp    101d7b <__alltraps>

00101ff1 <vector68>:
.globl vector68
vector68:
  pushl $0
  101ff1:	6a 00                	push   $0x0
  pushl $68
  101ff3:	6a 44                	push   $0x44
  jmp __alltraps
  101ff5:	e9 81 fd ff ff       	jmp    101d7b <__alltraps>

00101ffa <vector69>:
.globl vector69
vector69:
  pushl $0
  101ffa:	6a 00                	push   $0x0
  pushl $69
  101ffc:	6a 45                	push   $0x45
  jmp __alltraps
  101ffe:	e9 78 fd ff ff       	jmp    101d7b <__alltraps>

00102003 <vector70>:
.globl vector70
vector70:
  pushl $0
  102003:	6a 00                	push   $0x0
  pushl $70
  102005:	6a 46                	push   $0x46
  jmp __alltraps
  102007:	e9 6f fd ff ff       	jmp    101d7b <__alltraps>

0010200c <vector71>:
.globl vector71
vector71:
  pushl $0
  10200c:	6a 00                	push   $0x0
  pushl $71
  10200e:	6a 47                	push   $0x47
  jmp __alltraps
  102010:	e9 66 fd ff ff       	jmp    101d7b <__alltraps>

00102015 <vector72>:
.globl vector72
vector72:
  pushl $0
  102015:	6a 00                	push   $0x0
  pushl $72
  102017:	6a 48                	push   $0x48
  jmp __alltraps
  102019:	e9 5d fd ff ff       	jmp    101d7b <__alltraps>

0010201e <vector73>:
.globl vector73
vector73:
  pushl $0
  10201e:	6a 00                	push   $0x0
  pushl $73
  102020:	6a 49                	push   $0x49
  jmp __alltraps
  102022:	e9 54 fd ff ff       	jmp    101d7b <__alltraps>

00102027 <vector74>:
.globl vector74
vector74:
  pushl $0
  102027:	6a 00                	push   $0x0
  pushl $74
  102029:	6a 4a                	push   $0x4a
  jmp __alltraps
  10202b:	e9 4b fd ff ff       	jmp    101d7b <__alltraps>

00102030 <vector75>:
.globl vector75
vector75:
  pushl $0
  102030:	6a 00                	push   $0x0
  pushl $75
  102032:	6a 4b                	push   $0x4b
  jmp __alltraps
  102034:	e9 42 fd ff ff       	jmp    101d7b <__alltraps>

00102039 <vector76>:
.globl vector76
vector76:
  pushl $0
  102039:	6a 00                	push   $0x0
  pushl $76
  10203b:	6a 4c                	push   $0x4c
  jmp __alltraps
  10203d:	e9 39 fd ff ff       	jmp    101d7b <__alltraps>

00102042 <vector77>:
.globl vector77
vector77:
  pushl $0
  102042:	6a 00                	push   $0x0
  pushl $77
  102044:	6a 4d                	push   $0x4d
  jmp __alltraps
  102046:	e9 30 fd ff ff       	jmp    101d7b <__alltraps>

0010204b <vector78>:
.globl vector78
vector78:
  pushl $0
  10204b:	6a 00                	push   $0x0
  pushl $78
  10204d:	6a 4e                	push   $0x4e
  jmp __alltraps
  10204f:	e9 27 fd ff ff       	jmp    101d7b <__alltraps>

00102054 <vector79>:
.globl vector79
vector79:
  pushl $0
  102054:	6a 00                	push   $0x0
  pushl $79
  102056:	6a 4f                	push   $0x4f
  jmp __alltraps
  102058:	e9 1e fd ff ff       	jmp    101d7b <__alltraps>

0010205d <vector80>:
.globl vector80
vector80:
  pushl $0
  10205d:	6a 00                	push   $0x0
  pushl $80
  10205f:	6a 50                	push   $0x50
  jmp __alltraps
  102061:	e9 15 fd ff ff       	jmp    101d7b <__alltraps>

00102066 <vector81>:
.globl vector81
vector81:
  pushl $0
  102066:	6a 00                	push   $0x0
  pushl $81
  102068:	6a 51                	push   $0x51
  jmp __alltraps
  10206a:	e9 0c fd ff ff       	jmp    101d7b <__alltraps>

0010206f <vector82>:
.globl vector82
vector82:
  pushl $0
  10206f:	6a 00                	push   $0x0
  pushl $82
  102071:	6a 52                	push   $0x52
  jmp __alltraps
  102073:	e9 03 fd ff ff       	jmp    101d7b <__alltraps>

00102078 <vector83>:
.globl vector83
vector83:
  pushl $0
  102078:	6a 00                	push   $0x0
  pushl $83
  10207a:	6a 53                	push   $0x53
  jmp __alltraps
  10207c:	e9 fa fc ff ff       	jmp    101d7b <__alltraps>

00102081 <vector84>:
.globl vector84
vector84:
  pushl $0
  102081:	6a 00                	push   $0x0
  pushl $84
  102083:	6a 54                	push   $0x54
  jmp __alltraps
  102085:	e9 f1 fc ff ff       	jmp    101d7b <__alltraps>

0010208a <vector85>:
.globl vector85
vector85:
  pushl $0
  10208a:	6a 00                	push   $0x0
  pushl $85
  10208c:	6a 55                	push   $0x55
  jmp __alltraps
  10208e:	e9 e8 fc ff ff       	jmp    101d7b <__alltraps>

00102093 <vector86>:
.globl vector86
vector86:
  pushl $0
  102093:	6a 00                	push   $0x0
  pushl $86
  102095:	6a 56                	push   $0x56
  jmp __alltraps
  102097:	e9 df fc ff ff       	jmp    101d7b <__alltraps>

0010209c <vector87>:
.globl vector87
vector87:
  pushl $0
  10209c:	6a 00                	push   $0x0
  pushl $87
  10209e:	6a 57                	push   $0x57
  jmp __alltraps
  1020a0:	e9 d6 fc ff ff       	jmp    101d7b <__alltraps>

001020a5 <vector88>:
.globl vector88
vector88:
  pushl $0
  1020a5:	6a 00                	push   $0x0
  pushl $88
  1020a7:	6a 58                	push   $0x58
  jmp __alltraps
  1020a9:	e9 cd fc ff ff       	jmp    101d7b <__alltraps>

001020ae <vector89>:
.globl vector89
vector89:
  pushl $0
  1020ae:	6a 00                	push   $0x0
  pushl $89
  1020b0:	6a 59                	push   $0x59
  jmp __alltraps
  1020b2:	e9 c4 fc ff ff       	jmp    101d7b <__alltraps>

001020b7 <vector90>:
.globl vector90
vector90:
  pushl $0
  1020b7:	6a 00                	push   $0x0
  pushl $90
  1020b9:	6a 5a                	push   $0x5a
  jmp __alltraps
  1020bb:	e9 bb fc ff ff       	jmp    101d7b <__alltraps>

001020c0 <vector91>:
.globl vector91
vector91:
  pushl $0
  1020c0:	6a 00                	push   $0x0
  pushl $91
  1020c2:	6a 5b                	push   $0x5b
  jmp __alltraps
  1020c4:	e9 b2 fc ff ff       	jmp    101d7b <__alltraps>

001020c9 <vector92>:
.globl vector92
vector92:
  pushl $0
  1020c9:	6a 00                	push   $0x0
  pushl $92
  1020cb:	6a 5c                	push   $0x5c
  jmp __alltraps
  1020cd:	e9 a9 fc ff ff       	jmp    101d7b <__alltraps>

001020d2 <vector93>:
.globl vector93
vector93:
  pushl $0
  1020d2:	6a 00                	push   $0x0
  pushl $93
  1020d4:	6a 5d                	push   $0x5d
  jmp __alltraps
  1020d6:	e9 a0 fc ff ff       	jmp    101d7b <__alltraps>

001020db <vector94>:
.globl vector94
vector94:
  pushl $0
  1020db:	6a 00                	push   $0x0
  pushl $94
  1020dd:	6a 5e                	push   $0x5e
  jmp __alltraps
  1020df:	e9 97 fc ff ff       	jmp    101d7b <__alltraps>

001020e4 <vector95>:
.globl vector95
vector95:
  pushl $0
  1020e4:	6a 00                	push   $0x0
  pushl $95
  1020e6:	6a 5f                	push   $0x5f
  jmp __alltraps
  1020e8:	e9 8e fc ff ff       	jmp    101d7b <__alltraps>

001020ed <vector96>:
.globl vector96
vector96:
  pushl $0
  1020ed:	6a 00                	push   $0x0
  pushl $96
  1020ef:	6a 60                	push   $0x60
  jmp __alltraps
  1020f1:	e9 85 fc ff ff       	jmp    101d7b <__alltraps>

001020f6 <vector97>:
.globl vector97
vector97:
  pushl $0
  1020f6:	6a 00                	push   $0x0
  pushl $97
  1020f8:	6a 61                	push   $0x61
  jmp __alltraps
  1020fa:	e9 7c fc ff ff       	jmp    101d7b <__alltraps>

001020ff <vector98>:
.globl vector98
vector98:
  pushl $0
  1020ff:	6a 00                	push   $0x0
  pushl $98
  102101:	6a 62                	push   $0x62
  jmp __alltraps
  102103:	e9 73 fc ff ff       	jmp    101d7b <__alltraps>

00102108 <vector99>:
.globl vector99
vector99:
  pushl $0
  102108:	6a 00                	push   $0x0
  pushl $99
  10210a:	6a 63                	push   $0x63
  jmp __alltraps
  10210c:	e9 6a fc ff ff       	jmp    101d7b <__alltraps>

00102111 <vector100>:
.globl vector100
vector100:
  pushl $0
  102111:	6a 00                	push   $0x0
  pushl $100
  102113:	6a 64                	push   $0x64
  jmp __alltraps
  102115:	e9 61 fc ff ff       	jmp    101d7b <__alltraps>

0010211a <vector101>:
.globl vector101
vector101:
  pushl $0
  10211a:	6a 00                	push   $0x0
  pushl $101
  10211c:	6a 65                	push   $0x65
  jmp __alltraps
  10211e:	e9 58 fc ff ff       	jmp    101d7b <__alltraps>

00102123 <vector102>:
.globl vector102
vector102:
  pushl $0
  102123:	6a 00                	push   $0x0
  pushl $102
  102125:	6a 66                	push   $0x66
  jmp __alltraps
  102127:	e9 4f fc ff ff       	jmp    101d7b <__alltraps>

0010212c <vector103>:
.globl vector103
vector103:
  pushl $0
  10212c:	6a 00                	push   $0x0
  pushl $103
  10212e:	6a 67                	push   $0x67
  jmp __alltraps
  102130:	e9 46 fc ff ff       	jmp    101d7b <__alltraps>

00102135 <vector104>:
.globl vector104
vector104:
  pushl $0
  102135:	6a 00                	push   $0x0
  pushl $104
  102137:	6a 68                	push   $0x68
  jmp __alltraps
  102139:	e9 3d fc ff ff       	jmp    101d7b <__alltraps>

0010213e <vector105>:
.globl vector105
vector105:
  pushl $0
  10213e:	6a 00                	push   $0x0
  pushl $105
  102140:	6a 69                	push   $0x69
  jmp __alltraps
  102142:	e9 34 fc ff ff       	jmp    101d7b <__alltraps>

00102147 <vector106>:
.globl vector106
vector106:
  pushl $0
  102147:	6a 00                	push   $0x0
  pushl $106
  102149:	6a 6a                	push   $0x6a
  jmp __alltraps
  10214b:	e9 2b fc ff ff       	jmp    101d7b <__alltraps>

00102150 <vector107>:
.globl vector107
vector107:
  pushl $0
  102150:	6a 00                	push   $0x0
  pushl $107
  102152:	6a 6b                	push   $0x6b
  jmp __alltraps
  102154:	e9 22 fc ff ff       	jmp    101d7b <__alltraps>

00102159 <vector108>:
.globl vector108
vector108:
  pushl $0
  102159:	6a 00                	push   $0x0
  pushl $108
  10215b:	6a 6c                	push   $0x6c
  jmp __alltraps
  10215d:	e9 19 fc ff ff       	jmp    101d7b <__alltraps>

00102162 <vector109>:
.globl vector109
vector109:
  pushl $0
  102162:	6a 00                	push   $0x0
  pushl $109
  102164:	6a 6d                	push   $0x6d
  jmp __alltraps
  102166:	e9 10 fc ff ff       	jmp    101d7b <__alltraps>

0010216b <vector110>:
.globl vector110
vector110:
  pushl $0
  10216b:	6a 00                	push   $0x0
  pushl $110
  10216d:	6a 6e                	push   $0x6e
  jmp __alltraps
  10216f:	e9 07 fc ff ff       	jmp    101d7b <__alltraps>

00102174 <vector111>:
.globl vector111
vector111:
  pushl $0
  102174:	6a 00                	push   $0x0
  pushl $111
  102176:	6a 6f                	push   $0x6f
  jmp __alltraps
  102178:	e9 fe fb ff ff       	jmp    101d7b <__alltraps>

0010217d <vector112>:
.globl vector112
vector112:
  pushl $0
  10217d:	6a 00                	push   $0x0
  pushl $112
  10217f:	6a 70                	push   $0x70
  jmp __alltraps
  102181:	e9 f5 fb ff ff       	jmp    101d7b <__alltraps>

00102186 <vector113>:
.globl vector113
vector113:
  pushl $0
  102186:	6a 00                	push   $0x0
  pushl $113
  102188:	6a 71                	push   $0x71
  jmp __alltraps
  10218a:	e9 ec fb ff ff       	jmp    101d7b <__alltraps>

0010218f <vector114>:
.globl vector114
vector114:
  pushl $0
  10218f:	6a 00                	push   $0x0
  pushl $114
  102191:	6a 72                	push   $0x72
  jmp __alltraps
  102193:	e9 e3 fb ff ff       	jmp    101d7b <__alltraps>

00102198 <vector115>:
.globl vector115
vector115:
  pushl $0
  102198:	6a 00                	push   $0x0
  pushl $115
  10219a:	6a 73                	push   $0x73
  jmp __alltraps
  10219c:	e9 da fb ff ff       	jmp    101d7b <__alltraps>

001021a1 <vector116>:
.globl vector116
vector116:
  pushl $0
  1021a1:	6a 00                	push   $0x0
  pushl $116
  1021a3:	6a 74                	push   $0x74
  jmp __alltraps
  1021a5:	e9 d1 fb ff ff       	jmp    101d7b <__alltraps>

001021aa <vector117>:
.globl vector117
vector117:
  pushl $0
  1021aa:	6a 00                	push   $0x0
  pushl $117
  1021ac:	6a 75                	push   $0x75
  jmp __alltraps
  1021ae:	e9 c8 fb ff ff       	jmp    101d7b <__alltraps>

001021b3 <vector118>:
.globl vector118
vector118:
  pushl $0
  1021b3:	6a 00                	push   $0x0
  pushl $118
  1021b5:	6a 76                	push   $0x76
  jmp __alltraps
  1021b7:	e9 bf fb ff ff       	jmp    101d7b <__alltraps>

001021bc <vector119>:
.globl vector119
vector119:
  pushl $0
  1021bc:	6a 00                	push   $0x0
  pushl $119
  1021be:	6a 77                	push   $0x77
  jmp __alltraps
  1021c0:	e9 b6 fb ff ff       	jmp    101d7b <__alltraps>

001021c5 <vector120>:
.globl vector120
vector120:
  pushl $0
  1021c5:	6a 00                	push   $0x0
  pushl $120
  1021c7:	6a 78                	push   $0x78
  jmp __alltraps
  1021c9:	e9 ad fb ff ff       	jmp    101d7b <__alltraps>

001021ce <vector121>:
.globl vector121
vector121:
  pushl $0
  1021ce:	6a 00                	push   $0x0
  pushl $121
  1021d0:	6a 79                	push   $0x79
  jmp __alltraps
  1021d2:	e9 a4 fb ff ff       	jmp    101d7b <__alltraps>

001021d7 <vector122>:
.globl vector122
vector122:
  pushl $0
  1021d7:	6a 00                	push   $0x0
  pushl $122
  1021d9:	6a 7a                	push   $0x7a
  jmp __alltraps
  1021db:	e9 9b fb ff ff       	jmp    101d7b <__alltraps>

001021e0 <vector123>:
.globl vector123
vector123:
  pushl $0
  1021e0:	6a 00                	push   $0x0
  pushl $123
  1021e2:	6a 7b                	push   $0x7b
  jmp __alltraps
  1021e4:	e9 92 fb ff ff       	jmp    101d7b <__alltraps>

001021e9 <vector124>:
.globl vector124
vector124:
  pushl $0
  1021e9:	6a 00                	push   $0x0
  pushl $124
  1021eb:	6a 7c                	push   $0x7c
  jmp __alltraps
  1021ed:	e9 89 fb ff ff       	jmp    101d7b <__alltraps>

001021f2 <vector125>:
.globl vector125
vector125:
  pushl $0
  1021f2:	6a 00                	push   $0x0
  pushl $125
  1021f4:	6a 7d                	push   $0x7d
  jmp __alltraps
  1021f6:	e9 80 fb ff ff       	jmp    101d7b <__alltraps>

001021fb <vector126>:
.globl vector126
vector126:
  pushl $0
  1021fb:	6a 00                	push   $0x0
  pushl $126
  1021fd:	6a 7e                	push   $0x7e
  jmp __alltraps
  1021ff:	e9 77 fb ff ff       	jmp    101d7b <__alltraps>

00102204 <vector127>:
.globl vector127
vector127:
  pushl $0
  102204:	6a 00                	push   $0x0
  pushl $127
  102206:	6a 7f                	push   $0x7f
  jmp __alltraps
  102208:	e9 6e fb ff ff       	jmp    101d7b <__alltraps>

0010220d <vector128>:
.globl vector128
vector128:
  pushl $0
  10220d:	6a 00                	push   $0x0
  pushl $128
  10220f:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102214:	e9 62 fb ff ff       	jmp    101d7b <__alltraps>

00102219 <vector129>:
.globl vector129
vector129:
  pushl $0
  102219:	6a 00                	push   $0x0
  pushl $129
  10221b:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102220:	e9 56 fb ff ff       	jmp    101d7b <__alltraps>

00102225 <vector130>:
.globl vector130
vector130:
  pushl $0
  102225:	6a 00                	push   $0x0
  pushl $130
  102227:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10222c:	e9 4a fb ff ff       	jmp    101d7b <__alltraps>

00102231 <vector131>:
.globl vector131
vector131:
  pushl $0
  102231:	6a 00                	push   $0x0
  pushl $131
  102233:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102238:	e9 3e fb ff ff       	jmp    101d7b <__alltraps>

0010223d <vector132>:
.globl vector132
vector132:
  pushl $0
  10223d:	6a 00                	push   $0x0
  pushl $132
  10223f:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102244:	e9 32 fb ff ff       	jmp    101d7b <__alltraps>

00102249 <vector133>:
.globl vector133
vector133:
  pushl $0
  102249:	6a 00                	push   $0x0
  pushl $133
  10224b:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102250:	e9 26 fb ff ff       	jmp    101d7b <__alltraps>

00102255 <vector134>:
.globl vector134
vector134:
  pushl $0
  102255:	6a 00                	push   $0x0
  pushl $134
  102257:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10225c:	e9 1a fb ff ff       	jmp    101d7b <__alltraps>

00102261 <vector135>:
.globl vector135
vector135:
  pushl $0
  102261:	6a 00                	push   $0x0
  pushl $135
  102263:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102268:	e9 0e fb ff ff       	jmp    101d7b <__alltraps>

0010226d <vector136>:
.globl vector136
vector136:
  pushl $0
  10226d:	6a 00                	push   $0x0
  pushl $136
  10226f:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102274:	e9 02 fb ff ff       	jmp    101d7b <__alltraps>

00102279 <vector137>:
.globl vector137
vector137:
  pushl $0
  102279:	6a 00                	push   $0x0
  pushl $137
  10227b:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102280:	e9 f6 fa ff ff       	jmp    101d7b <__alltraps>

00102285 <vector138>:
.globl vector138
vector138:
  pushl $0
  102285:	6a 00                	push   $0x0
  pushl $138
  102287:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  10228c:	e9 ea fa ff ff       	jmp    101d7b <__alltraps>

00102291 <vector139>:
.globl vector139
vector139:
  pushl $0
  102291:	6a 00                	push   $0x0
  pushl $139
  102293:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102298:	e9 de fa ff ff       	jmp    101d7b <__alltraps>

0010229d <vector140>:
.globl vector140
vector140:
  pushl $0
  10229d:	6a 00                	push   $0x0
  pushl $140
  10229f:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1022a4:	e9 d2 fa ff ff       	jmp    101d7b <__alltraps>

001022a9 <vector141>:
.globl vector141
vector141:
  pushl $0
  1022a9:	6a 00                	push   $0x0
  pushl $141
  1022ab:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1022b0:	e9 c6 fa ff ff       	jmp    101d7b <__alltraps>

001022b5 <vector142>:
.globl vector142
vector142:
  pushl $0
  1022b5:	6a 00                	push   $0x0
  pushl $142
  1022b7:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1022bc:	e9 ba fa ff ff       	jmp    101d7b <__alltraps>

001022c1 <vector143>:
.globl vector143
vector143:
  pushl $0
  1022c1:	6a 00                	push   $0x0
  pushl $143
  1022c3:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1022c8:	e9 ae fa ff ff       	jmp    101d7b <__alltraps>

001022cd <vector144>:
.globl vector144
vector144:
  pushl $0
  1022cd:	6a 00                	push   $0x0
  pushl $144
  1022cf:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1022d4:	e9 a2 fa ff ff       	jmp    101d7b <__alltraps>

001022d9 <vector145>:
.globl vector145
vector145:
  pushl $0
  1022d9:	6a 00                	push   $0x0
  pushl $145
  1022db:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1022e0:	e9 96 fa ff ff       	jmp    101d7b <__alltraps>

001022e5 <vector146>:
.globl vector146
vector146:
  pushl $0
  1022e5:	6a 00                	push   $0x0
  pushl $146
  1022e7:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1022ec:	e9 8a fa ff ff       	jmp    101d7b <__alltraps>

001022f1 <vector147>:
.globl vector147
vector147:
  pushl $0
  1022f1:	6a 00                	push   $0x0
  pushl $147
  1022f3:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1022f8:	e9 7e fa ff ff       	jmp    101d7b <__alltraps>

001022fd <vector148>:
.globl vector148
vector148:
  pushl $0
  1022fd:	6a 00                	push   $0x0
  pushl $148
  1022ff:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102304:	e9 72 fa ff ff       	jmp    101d7b <__alltraps>

00102309 <vector149>:
.globl vector149
vector149:
  pushl $0
  102309:	6a 00                	push   $0x0
  pushl $149
  10230b:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102310:	e9 66 fa ff ff       	jmp    101d7b <__alltraps>

00102315 <vector150>:
.globl vector150
vector150:
  pushl $0
  102315:	6a 00                	push   $0x0
  pushl $150
  102317:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10231c:	e9 5a fa ff ff       	jmp    101d7b <__alltraps>

00102321 <vector151>:
.globl vector151
vector151:
  pushl $0
  102321:	6a 00                	push   $0x0
  pushl $151
  102323:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102328:	e9 4e fa ff ff       	jmp    101d7b <__alltraps>

0010232d <vector152>:
.globl vector152
vector152:
  pushl $0
  10232d:	6a 00                	push   $0x0
  pushl $152
  10232f:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102334:	e9 42 fa ff ff       	jmp    101d7b <__alltraps>

00102339 <vector153>:
.globl vector153
vector153:
  pushl $0
  102339:	6a 00                	push   $0x0
  pushl $153
  10233b:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102340:	e9 36 fa ff ff       	jmp    101d7b <__alltraps>

00102345 <vector154>:
.globl vector154
vector154:
  pushl $0
  102345:	6a 00                	push   $0x0
  pushl $154
  102347:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10234c:	e9 2a fa ff ff       	jmp    101d7b <__alltraps>

00102351 <vector155>:
.globl vector155
vector155:
  pushl $0
  102351:	6a 00                	push   $0x0
  pushl $155
  102353:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102358:	e9 1e fa ff ff       	jmp    101d7b <__alltraps>

0010235d <vector156>:
.globl vector156
vector156:
  pushl $0
  10235d:	6a 00                	push   $0x0
  pushl $156
  10235f:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102364:	e9 12 fa ff ff       	jmp    101d7b <__alltraps>

00102369 <vector157>:
.globl vector157
vector157:
  pushl $0
  102369:	6a 00                	push   $0x0
  pushl $157
  10236b:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102370:	e9 06 fa ff ff       	jmp    101d7b <__alltraps>

00102375 <vector158>:
.globl vector158
vector158:
  pushl $0
  102375:	6a 00                	push   $0x0
  pushl $158
  102377:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10237c:	e9 fa f9 ff ff       	jmp    101d7b <__alltraps>

00102381 <vector159>:
.globl vector159
vector159:
  pushl $0
  102381:	6a 00                	push   $0x0
  pushl $159
  102383:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102388:	e9 ee f9 ff ff       	jmp    101d7b <__alltraps>

0010238d <vector160>:
.globl vector160
vector160:
  pushl $0
  10238d:	6a 00                	push   $0x0
  pushl $160
  10238f:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102394:	e9 e2 f9 ff ff       	jmp    101d7b <__alltraps>

00102399 <vector161>:
.globl vector161
vector161:
  pushl $0
  102399:	6a 00                	push   $0x0
  pushl $161
  10239b:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1023a0:	e9 d6 f9 ff ff       	jmp    101d7b <__alltraps>

001023a5 <vector162>:
.globl vector162
vector162:
  pushl $0
  1023a5:	6a 00                	push   $0x0
  pushl $162
  1023a7:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1023ac:	e9 ca f9 ff ff       	jmp    101d7b <__alltraps>

001023b1 <vector163>:
.globl vector163
vector163:
  pushl $0
  1023b1:	6a 00                	push   $0x0
  pushl $163
  1023b3:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1023b8:	e9 be f9 ff ff       	jmp    101d7b <__alltraps>

001023bd <vector164>:
.globl vector164
vector164:
  pushl $0
  1023bd:	6a 00                	push   $0x0
  pushl $164
  1023bf:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1023c4:	e9 b2 f9 ff ff       	jmp    101d7b <__alltraps>

001023c9 <vector165>:
.globl vector165
vector165:
  pushl $0
  1023c9:	6a 00                	push   $0x0
  pushl $165
  1023cb:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1023d0:	e9 a6 f9 ff ff       	jmp    101d7b <__alltraps>

001023d5 <vector166>:
.globl vector166
vector166:
  pushl $0
  1023d5:	6a 00                	push   $0x0
  pushl $166
  1023d7:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1023dc:	e9 9a f9 ff ff       	jmp    101d7b <__alltraps>

001023e1 <vector167>:
.globl vector167
vector167:
  pushl $0
  1023e1:	6a 00                	push   $0x0
  pushl $167
  1023e3:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1023e8:	e9 8e f9 ff ff       	jmp    101d7b <__alltraps>

001023ed <vector168>:
.globl vector168
vector168:
  pushl $0
  1023ed:	6a 00                	push   $0x0
  pushl $168
  1023ef:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1023f4:	e9 82 f9 ff ff       	jmp    101d7b <__alltraps>

001023f9 <vector169>:
.globl vector169
vector169:
  pushl $0
  1023f9:	6a 00                	push   $0x0
  pushl $169
  1023fb:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102400:	e9 76 f9 ff ff       	jmp    101d7b <__alltraps>

00102405 <vector170>:
.globl vector170
vector170:
  pushl $0
  102405:	6a 00                	push   $0x0
  pushl $170
  102407:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10240c:	e9 6a f9 ff ff       	jmp    101d7b <__alltraps>

00102411 <vector171>:
.globl vector171
vector171:
  pushl $0
  102411:	6a 00                	push   $0x0
  pushl $171
  102413:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102418:	e9 5e f9 ff ff       	jmp    101d7b <__alltraps>

0010241d <vector172>:
.globl vector172
vector172:
  pushl $0
  10241d:	6a 00                	push   $0x0
  pushl $172
  10241f:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102424:	e9 52 f9 ff ff       	jmp    101d7b <__alltraps>

00102429 <vector173>:
.globl vector173
vector173:
  pushl $0
  102429:	6a 00                	push   $0x0
  pushl $173
  10242b:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102430:	e9 46 f9 ff ff       	jmp    101d7b <__alltraps>

00102435 <vector174>:
.globl vector174
vector174:
  pushl $0
  102435:	6a 00                	push   $0x0
  pushl $174
  102437:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10243c:	e9 3a f9 ff ff       	jmp    101d7b <__alltraps>

00102441 <vector175>:
.globl vector175
vector175:
  pushl $0
  102441:	6a 00                	push   $0x0
  pushl $175
  102443:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102448:	e9 2e f9 ff ff       	jmp    101d7b <__alltraps>

0010244d <vector176>:
.globl vector176
vector176:
  pushl $0
  10244d:	6a 00                	push   $0x0
  pushl $176
  10244f:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102454:	e9 22 f9 ff ff       	jmp    101d7b <__alltraps>

00102459 <vector177>:
.globl vector177
vector177:
  pushl $0
  102459:	6a 00                	push   $0x0
  pushl $177
  10245b:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102460:	e9 16 f9 ff ff       	jmp    101d7b <__alltraps>

00102465 <vector178>:
.globl vector178
vector178:
  pushl $0
  102465:	6a 00                	push   $0x0
  pushl $178
  102467:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  10246c:	e9 0a f9 ff ff       	jmp    101d7b <__alltraps>

00102471 <vector179>:
.globl vector179
vector179:
  pushl $0
  102471:	6a 00                	push   $0x0
  pushl $179
  102473:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102478:	e9 fe f8 ff ff       	jmp    101d7b <__alltraps>

0010247d <vector180>:
.globl vector180
vector180:
  pushl $0
  10247d:	6a 00                	push   $0x0
  pushl $180
  10247f:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102484:	e9 f2 f8 ff ff       	jmp    101d7b <__alltraps>

00102489 <vector181>:
.globl vector181
vector181:
  pushl $0
  102489:	6a 00                	push   $0x0
  pushl $181
  10248b:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102490:	e9 e6 f8 ff ff       	jmp    101d7b <__alltraps>

00102495 <vector182>:
.globl vector182
vector182:
  pushl $0
  102495:	6a 00                	push   $0x0
  pushl $182
  102497:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  10249c:	e9 da f8 ff ff       	jmp    101d7b <__alltraps>

001024a1 <vector183>:
.globl vector183
vector183:
  pushl $0
  1024a1:	6a 00                	push   $0x0
  pushl $183
  1024a3:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1024a8:	e9 ce f8 ff ff       	jmp    101d7b <__alltraps>

001024ad <vector184>:
.globl vector184
vector184:
  pushl $0
  1024ad:	6a 00                	push   $0x0
  pushl $184
  1024af:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1024b4:	e9 c2 f8 ff ff       	jmp    101d7b <__alltraps>

001024b9 <vector185>:
.globl vector185
vector185:
  pushl $0
  1024b9:	6a 00                	push   $0x0
  pushl $185
  1024bb:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1024c0:	e9 b6 f8 ff ff       	jmp    101d7b <__alltraps>

001024c5 <vector186>:
.globl vector186
vector186:
  pushl $0
  1024c5:	6a 00                	push   $0x0
  pushl $186
  1024c7:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1024cc:	e9 aa f8 ff ff       	jmp    101d7b <__alltraps>

001024d1 <vector187>:
.globl vector187
vector187:
  pushl $0
  1024d1:	6a 00                	push   $0x0
  pushl $187
  1024d3:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1024d8:	e9 9e f8 ff ff       	jmp    101d7b <__alltraps>

001024dd <vector188>:
.globl vector188
vector188:
  pushl $0
  1024dd:	6a 00                	push   $0x0
  pushl $188
  1024df:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1024e4:	e9 92 f8 ff ff       	jmp    101d7b <__alltraps>

001024e9 <vector189>:
.globl vector189
vector189:
  pushl $0
  1024e9:	6a 00                	push   $0x0
  pushl $189
  1024eb:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1024f0:	e9 86 f8 ff ff       	jmp    101d7b <__alltraps>

001024f5 <vector190>:
.globl vector190
vector190:
  pushl $0
  1024f5:	6a 00                	push   $0x0
  pushl $190
  1024f7:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1024fc:	e9 7a f8 ff ff       	jmp    101d7b <__alltraps>

00102501 <vector191>:
.globl vector191
vector191:
  pushl $0
  102501:	6a 00                	push   $0x0
  pushl $191
  102503:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102508:	e9 6e f8 ff ff       	jmp    101d7b <__alltraps>

0010250d <vector192>:
.globl vector192
vector192:
  pushl $0
  10250d:	6a 00                	push   $0x0
  pushl $192
  10250f:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102514:	e9 62 f8 ff ff       	jmp    101d7b <__alltraps>

00102519 <vector193>:
.globl vector193
vector193:
  pushl $0
  102519:	6a 00                	push   $0x0
  pushl $193
  10251b:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102520:	e9 56 f8 ff ff       	jmp    101d7b <__alltraps>

00102525 <vector194>:
.globl vector194
vector194:
  pushl $0
  102525:	6a 00                	push   $0x0
  pushl $194
  102527:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10252c:	e9 4a f8 ff ff       	jmp    101d7b <__alltraps>

00102531 <vector195>:
.globl vector195
vector195:
  pushl $0
  102531:	6a 00                	push   $0x0
  pushl $195
  102533:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102538:	e9 3e f8 ff ff       	jmp    101d7b <__alltraps>

0010253d <vector196>:
.globl vector196
vector196:
  pushl $0
  10253d:	6a 00                	push   $0x0
  pushl $196
  10253f:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102544:	e9 32 f8 ff ff       	jmp    101d7b <__alltraps>

00102549 <vector197>:
.globl vector197
vector197:
  pushl $0
  102549:	6a 00                	push   $0x0
  pushl $197
  10254b:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102550:	e9 26 f8 ff ff       	jmp    101d7b <__alltraps>

00102555 <vector198>:
.globl vector198
vector198:
  pushl $0
  102555:	6a 00                	push   $0x0
  pushl $198
  102557:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  10255c:	e9 1a f8 ff ff       	jmp    101d7b <__alltraps>

00102561 <vector199>:
.globl vector199
vector199:
  pushl $0
  102561:	6a 00                	push   $0x0
  pushl $199
  102563:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102568:	e9 0e f8 ff ff       	jmp    101d7b <__alltraps>

0010256d <vector200>:
.globl vector200
vector200:
  pushl $0
  10256d:	6a 00                	push   $0x0
  pushl $200
  10256f:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102574:	e9 02 f8 ff ff       	jmp    101d7b <__alltraps>

00102579 <vector201>:
.globl vector201
vector201:
  pushl $0
  102579:	6a 00                	push   $0x0
  pushl $201
  10257b:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102580:	e9 f6 f7 ff ff       	jmp    101d7b <__alltraps>

00102585 <vector202>:
.globl vector202
vector202:
  pushl $0
  102585:	6a 00                	push   $0x0
  pushl $202
  102587:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  10258c:	e9 ea f7 ff ff       	jmp    101d7b <__alltraps>

00102591 <vector203>:
.globl vector203
vector203:
  pushl $0
  102591:	6a 00                	push   $0x0
  pushl $203
  102593:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102598:	e9 de f7 ff ff       	jmp    101d7b <__alltraps>

0010259d <vector204>:
.globl vector204
vector204:
  pushl $0
  10259d:	6a 00                	push   $0x0
  pushl $204
  10259f:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1025a4:	e9 d2 f7 ff ff       	jmp    101d7b <__alltraps>

001025a9 <vector205>:
.globl vector205
vector205:
  pushl $0
  1025a9:	6a 00                	push   $0x0
  pushl $205
  1025ab:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1025b0:	e9 c6 f7 ff ff       	jmp    101d7b <__alltraps>

001025b5 <vector206>:
.globl vector206
vector206:
  pushl $0
  1025b5:	6a 00                	push   $0x0
  pushl $206
  1025b7:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1025bc:	e9 ba f7 ff ff       	jmp    101d7b <__alltraps>

001025c1 <vector207>:
.globl vector207
vector207:
  pushl $0
  1025c1:	6a 00                	push   $0x0
  pushl $207
  1025c3:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1025c8:	e9 ae f7 ff ff       	jmp    101d7b <__alltraps>

001025cd <vector208>:
.globl vector208
vector208:
  pushl $0
  1025cd:	6a 00                	push   $0x0
  pushl $208
  1025cf:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1025d4:	e9 a2 f7 ff ff       	jmp    101d7b <__alltraps>

001025d9 <vector209>:
.globl vector209
vector209:
  pushl $0
  1025d9:	6a 00                	push   $0x0
  pushl $209
  1025db:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1025e0:	e9 96 f7 ff ff       	jmp    101d7b <__alltraps>

001025e5 <vector210>:
.globl vector210
vector210:
  pushl $0
  1025e5:	6a 00                	push   $0x0
  pushl $210
  1025e7:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1025ec:	e9 8a f7 ff ff       	jmp    101d7b <__alltraps>

001025f1 <vector211>:
.globl vector211
vector211:
  pushl $0
  1025f1:	6a 00                	push   $0x0
  pushl $211
  1025f3:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1025f8:	e9 7e f7 ff ff       	jmp    101d7b <__alltraps>

001025fd <vector212>:
.globl vector212
vector212:
  pushl $0
  1025fd:	6a 00                	push   $0x0
  pushl $212
  1025ff:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102604:	e9 72 f7 ff ff       	jmp    101d7b <__alltraps>

00102609 <vector213>:
.globl vector213
vector213:
  pushl $0
  102609:	6a 00                	push   $0x0
  pushl $213
  10260b:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102610:	e9 66 f7 ff ff       	jmp    101d7b <__alltraps>

00102615 <vector214>:
.globl vector214
vector214:
  pushl $0
  102615:	6a 00                	push   $0x0
  pushl $214
  102617:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10261c:	e9 5a f7 ff ff       	jmp    101d7b <__alltraps>

00102621 <vector215>:
.globl vector215
vector215:
  pushl $0
  102621:	6a 00                	push   $0x0
  pushl $215
  102623:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102628:	e9 4e f7 ff ff       	jmp    101d7b <__alltraps>

0010262d <vector216>:
.globl vector216
vector216:
  pushl $0
  10262d:	6a 00                	push   $0x0
  pushl $216
  10262f:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102634:	e9 42 f7 ff ff       	jmp    101d7b <__alltraps>

00102639 <vector217>:
.globl vector217
vector217:
  pushl $0
  102639:	6a 00                	push   $0x0
  pushl $217
  10263b:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102640:	e9 36 f7 ff ff       	jmp    101d7b <__alltraps>

00102645 <vector218>:
.globl vector218
vector218:
  pushl $0
  102645:	6a 00                	push   $0x0
  pushl $218
  102647:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10264c:	e9 2a f7 ff ff       	jmp    101d7b <__alltraps>

00102651 <vector219>:
.globl vector219
vector219:
  pushl $0
  102651:	6a 00                	push   $0x0
  pushl $219
  102653:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102658:	e9 1e f7 ff ff       	jmp    101d7b <__alltraps>

0010265d <vector220>:
.globl vector220
vector220:
  pushl $0
  10265d:	6a 00                	push   $0x0
  pushl $220
  10265f:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102664:	e9 12 f7 ff ff       	jmp    101d7b <__alltraps>

00102669 <vector221>:
.globl vector221
vector221:
  pushl $0
  102669:	6a 00                	push   $0x0
  pushl $221
  10266b:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102670:	e9 06 f7 ff ff       	jmp    101d7b <__alltraps>

00102675 <vector222>:
.globl vector222
vector222:
  pushl $0
  102675:	6a 00                	push   $0x0
  pushl $222
  102677:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  10267c:	e9 fa f6 ff ff       	jmp    101d7b <__alltraps>

00102681 <vector223>:
.globl vector223
vector223:
  pushl $0
  102681:	6a 00                	push   $0x0
  pushl $223
  102683:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102688:	e9 ee f6 ff ff       	jmp    101d7b <__alltraps>

0010268d <vector224>:
.globl vector224
vector224:
  pushl $0
  10268d:	6a 00                	push   $0x0
  pushl $224
  10268f:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102694:	e9 e2 f6 ff ff       	jmp    101d7b <__alltraps>

00102699 <vector225>:
.globl vector225
vector225:
  pushl $0
  102699:	6a 00                	push   $0x0
  pushl $225
  10269b:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1026a0:	e9 d6 f6 ff ff       	jmp    101d7b <__alltraps>

001026a5 <vector226>:
.globl vector226
vector226:
  pushl $0
  1026a5:	6a 00                	push   $0x0
  pushl $226
  1026a7:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1026ac:	e9 ca f6 ff ff       	jmp    101d7b <__alltraps>

001026b1 <vector227>:
.globl vector227
vector227:
  pushl $0
  1026b1:	6a 00                	push   $0x0
  pushl $227
  1026b3:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1026b8:	e9 be f6 ff ff       	jmp    101d7b <__alltraps>

001026bd <vector228>:
.globl vector228
vector228:
  pushl $0
  1026bd:	6a 00                	push   $0x0
  pushl $228
  1026bf:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1026c4:	e9 b2 f6 ff ff       	jmp    101d7b <__alltraps>

001026c9 <vector229>:
.globl vector229
vector229:
  pushl $0
  1026c9:	6a 00                	push   $0x0
  pushl $229
  1026cb:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1026d0:	e9 a6 f6 ff ff       	jmp    101d7b <__alltraps>

001026d5 <vector230>:
.globl vector230
vector230:
  pushl $0
  1026d5:	6a 00                	push   $0x0
  pushl $230
  1026d7:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1026dc:	e9 9a f6 ff ff       	jmp    101d7b <__alltraps>

001026e1 <vector231>:
.globl vector231
vector231:
  pushl $0
  1026e1:	6a 00                	push   $0x0
  pushl $231
  1026e3:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1026e8:	e9 8e f6 ff ff       	jmp    101d7b <__alltraps>

001026ed <vector232>:
.globl vector232
vector232:
  pushl $0
  1026ed:	6a 00                	push   $0x0
  pushl $232
  1026ef:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1026f4:	e9 82 f6 ff ff       	jmp    101d7b <__alltraps>

001026f9 <vector233>:
.globl vector233
vector233:
  pushl $0
  1026f9:	6a 00                	push   $0x0
  pushl $233
  1026fb:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102700:	e9 76 f6 ff ff       	jmp    101d7b <__alltraps>

00102705 <vector234>:
.globl vector234
vector234:
  pushl $0
  102705:	6a 00                	push   $0x0
  pushl $234
  102707:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10270c:	e9 6a f6 ff ff       	jmp    101d7b <__alltraps>

00102711 <vector235>:
.globl vector235
vector235:
  pushl $0
  102711:	6a 00                	push   $0x0
  pushl $235
  102713:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102718:	e9 5e f6 ff ff       	jmp    101d7b <__alltraps>

0010271d <vector236>:
.globl vector236
vector236:
  pushl $0
  10271d:	6a 00                	push   $0x0
  pushl $236
  10271f:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102724:	e9 52 f6 ff ff       	jmp    101d7b <__alltraps>

00102729 <vector237>:
.globl vector237
vector237:
  pushl $0
  102729:	6a 00                	push   $0x0
  pushl $237
  10272b:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102730:	e9 46 f6 ff ff       	jmp    101d7b <__alltraps>

00102735 <vector238>:
.globl vector238
vector238:
  pushl $0
  102735:	6a 00                	push   $0x0
  pushl $238
  102737:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  10273c:	e9 3a f6 ff ff       	jmp    101d7b <__alltraps>

00102741 <vector239>:
.globl vector239
vector239:
  pushl $0
  102741:	6a 00                	push   $0x0
  pushl $239
  102743:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102748:	e9 2e f6 ff ff       	jmp    101d7b <__alltraps>

0010274d <vector240>:
.globl vector240
vector240:
  pushl $0
  10274d:	6a 00                	push   $0x0
  pushl $240
  10274f:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102754:	e9 22 f6 ff ff       	jmp    101d7b <__alltraps>

00102759 <vector241>:
.globl vector241
vector241:
  pushl $0
  102759:	6a 00                	push   $0x0
  pushl $241
  10275b:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102760:	e9 16 f6 ff ff       	jmp    101d7b <__alltraps>

00102765 <vector242>:
.globl vector242
vector242:
  pushl $0
  102765:	6a 00                	push   $0x0
  pushl $242
  102767:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  10276c:	e9 0a f6 ff ff       	jmp    101d7b <__alltraps>

00102771 <vector243>:
.globl vector243
vector243:
  pushl $0
  102771:	6a 00                	push   $0x0
  pushl $243
  102773:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102778:	e9 fe f5 ff ff       	jmp    101d7b <__alltraps>

0010277d <vector244>:
.globl vector244
vector244:
  pushl $0
  10277d:	6a 00                	push   $0x0
  pushl $244
  10277f:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102784:	e9 f2 f5 ff ff       	jmp    101d7b <__alltraps>

00102789 <vector245>:
.globl vector245
vector245:
  pushl $0
  102789:	6a 00                	push   $0x0
  pushl $245
  10278b:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102790:	e9 e6 f5 ff ff       	jmp    101d7b <__alltraps>

00102795 <vector246>:
.globl vector246
vector246:
  pushl $0
  102795:	6a 00                	push   $0x0
  pushl $246
  102797:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  10279c:	e9 da f5 ff ff       	jmp    101d7b <__alltraps>

001027a1 <vector247>:
.globl vector247
vector247:
  pushl $0
  1027a1:	6a 00                	push   $0x0
  pushl $247
  1027a3:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1027a8:	e9 ce f5 ff ff       	jmp    101d7b <__alltraps>

001027ad <vector248>:
.globl vector248
vector248:
  pushl $0
  1027ad:	6a 00                	push   $0x0
  pushl $248
  1027af:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1027b4:	e9 c2 f5 ff ff       	jmp    101d7b <__alltraps>

001027b9 <vector249>:
.globl vector249
vector249:
  pushl $0
  1027b9:	6a 00                	push   $0x0
  pushl $249
  1027bb:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1027c0:	e9 b6 f5 ff ff       	jmp    101d7b <__alltraps>

001027c5 <vector250>:
.globl vector250
vector250:
  pushl $0
  1027c5:	6a 00                	push   $0x0
  pushl $250
  1027c7:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1027cc:	e9 aa f5 ff ff       	jmp    101d7b <__alltraps>

001027d1 <vector251>:
.globl vector251
vector251:
  pushl $0
  1027d1:	6a 00                	push   $0x0
  pushl $251
  1027d3:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1027d8:	e9 9e f5 ff ff       	jmp    101d7b <__alltraps>

001027dd <vector252>:
.globl vector252
vector252:
  pushl $0
  1027dd:	6a 00                	push   $0x0
  pushl $252
  1027df:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1027e4:	e9 92 f5 ff ff       	jmp    101d7b <__alltraps>

001027e9 <vector253>:
.globl vector253
vector253:
  pushl $0
  1027e9:	6a 00                	push   $0x0
  pushl $253
  1027eb:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1027f0:	e9 86 f5 ff ff       	jmp    101d7b <__alltraps>

001027f5 <vector254>:
.globl vector254
vector254:
  pushl $0
  1027f5:	6a 00                	push   $0x0
  pushl $254
  1027f7:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1027fc:	e9 7a f5 ff ff       	jmp    101d7b <__alltraps>

00102801 <vector255>:
.globl vector255
vector255:
  pushl $0
  102801:	6a 00                	push   $0x0
  pushl $255
  102803:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102808:	e9 6e f5 ff ff       	jmp    101d7b <__alltraps>

0010280d <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  10280d:	55                   	push   %ebp
  10280e:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102810:	8b 55 08             	mov    0x8(%ebp),%edx
  102813:	a1 64 89 11 00       	mov    0x118964,%eax
  102818:	29 c2                	sub    %eax,%edx
  10281a:	89 d0                	mov    %edx,%eax
  10281c:	c1 f8 02             	sar    $0x2,%eax
  10281f:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  102825:	5d                   	pop    %ebp
  102826:	c3                   	ret    

00102827 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  102827:	55                   	push   %ebp
  102828:	89 e5                	mov    %esp,%ebp
  10282a:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  10282d:	8b 45 08             	mov    0x8(%ebp),%eax
  102830:	89 04 24             	mov    %eax,(%esp)
  102833:	e8 d5 ff ff ff       	call   10280d <page2ppn>
  102838:	c1 e0 0c             	shl    $0xc,%eax
}
  10283b:	c9                   	leave  
  10283c:	c3                   	ret    

0010283d <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  10283d:	55                   	push   %ebp
  10283e:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102840:	8b 45 08             	mov    0x8(%ebp),%eax
  102843:	8b 00                	mov    (%eax),%eax
}
  102845:	5d                   	pop    %ebp
  102846:	c3                   	ret    

00102847 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102847:	55                   	push   %ebp
  102848:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  10284a:	8b 45 08             	mov    0x8(%ebp),%eax
  10284d:	8b 55 0c             	mov    0xc(%ebp),%edx
  102850:	89 10                	mov    %edx,(%eax)
}
  102852:	5d                   	pop    %ebp
  102853:	c3                   	ret    

00102854 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  102854:	55                   	push   %ebp
  102855:	89 e5                	mov    %esp,%ebp
  102857:	83 ec 10             	sub    $0x10,%esp
  10285a:	c7 45 fc 50 89 11 00 	movl   $0x118950,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  102861:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102864:	8b 55 fc             	mov    -0x4(%ebp),%edx
  102867:	89 50 04             	mov    %edx,0x4(%eax)
  10286a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10286d:	8b 50 04             	mov    0x4(%eax),%edx
  102870:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102873:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  102875:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  10287c:	00 00 00 
}
  10287f:	c9                   	leave  
  102880:	c3                   	ret    

00102881 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  102881:	55                   	push   %ebp
  102882:	89 e5                	mov    %esp,%ebp
  102884:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
  102887:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10288b:	75 24                	jne    1028b1 <default_init_memmap+0x30>
  10288d:	c7 44 24 0c 90 65 10 	movl   $0x106590,0xc(%esp)
  102894:	00 
  102895:	c7 44 24 08 96 65 10 	movl   $0x106596,0x8(%esp)
  10289c:	00 
  10289d:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
  1028a4:	00 
  1028a5:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  1028ac:	e8 14 e4 ff ff       	call   100cc5 <__panic>
    struct Page* p = base;
  1028b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1028b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for(; p != base + n; p ++)
  1028b7:	e9 d2 00 00 00       	jmp    10298e <default_init_memmap+0x10d>
    {
	assert(PageReserved(p));
  1028bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1028bf:	83 c0 04             	add    $0x4,%eax
  1028c2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  1028c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1028cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1028cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1028d2:	0f a3 10             	bt     %edx,(%eax)
  1028d5:	19 c0                	sbb    %eax,%eax
  1028d7:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  1028da:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1028de:	0f 95 c0             	setne  %al
  1028e1:	0f b6 c0             	movzbl %al,%eax
  1028e4:	85 c0                	test   %eax,%eax
  1028e6:	75 24                	jne    10290c <default_init_memmap+0x8b>
  1028e8:	c7 44 24 0c c1 65 10 	movl   $0x1065c1,0xc(%esp)
  1028ef:	00 
  1028f0:	c7 44 24 08 96 65 10 	movl   $0x106596,0x8(%esp)
  1028f7:	00 
  1028f8:	c7 44 24 04 4a 00 00 	movl   $0x4a,0x4(%esp)
  1028ff:	00 
  102900:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  102907:	e8 b9 e3 ff ff       	call   100cc5 <__panic>
	SetPageProperty(p);
  10290c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10290f:	83 c0 04             	add    $0x4,%eax
  102912:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  102919:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10291c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10291f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102922:	0f ab 10             	bts    %edx,(%eax)
	p->property = 0;
  102925:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102928:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	set_page_ref(p, 0);
  10292f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102936:	00 
  102937:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10293a:	89 04 24             	mov    %eax,(%esp)
  10293d:	e8 05 ff ff ff       	call   102847 <set_page_ref>
	list_add_before(&free_list, &(p->page_link));
  102942:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102945:	83 c0 0c             	add    $0xc,%eax
  102948:	c7 45 dc 50 89 11 00 	movl   $0x118950,-0x24(%ebp)
  10294f:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102952:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102955:	8b 00                	mov    (%eax),%eax
  102957:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10295a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10295d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102960:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102963:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102966:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102969:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10296c:	89 10                	mov    %edx,(%eax)
  10296e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102971:	8b 10                	mov    (%eax),%edx
  102973:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102976:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102979:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10297c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  10297f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102982:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102985:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102988:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page* p = base;
    for(; p != base + n; p ++)
  10298a:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  10298e:	8b 55 0c             	mov    0xc(%ebp),%edx
  102991:	89 d0                	mov    %edx,%eax
  102993:	c1 e0 02             	shl    $0x2,%eax
  102996:	01 d0                	add    %edx,%eax
  102998:	c1 e0 02             	shl    $0x2,%eax
  10299b:	89 c2                	mov    %eax,%edx
  10299d:	8b 45 08             	mov    0x8(%ebp),%eax
  1029a0:	01 d0                	add    %edx,%eax
  1029a2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1029a5:	0f 85 11 ff ff ff    	jne    1028bc <default_init_memmap+0x3b>
	SetPageProperty(p);
	p->property = 0;
	set_page_ref(p, 0);
	list_add_before(&free_list, &(p->page_link));
    }
    base->property = n;
  1029ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1029ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  1029b1:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free+=n;
  1029b4:	8b 15 58 89 11 00    	mov    0x118958,%edx
  1029ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  1029bd:	01 d0                	add    %edx,%eax
  1029bf:	a3 58 89 11 00       	mov    %eax,0x118958
}
  1029c4:	c9                   	leave  
  1029c5:	c3                   	ret    

001029c6 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  1029c6:	55                   	push   %ebp
  1029c7:	89 e5                	mov    %esp,%ebp
  1029c9:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  1029cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1029d0:	75 24                	jne    1029f6 <default_alloc_pages+0x30>
  1029d2:	c7 44 24 0c 90 65 10 	movl   $0x106590,0xc(%esp)
  1029d9:	00 
  1029da:	c7 44 24 08 96 65 10 	movl   $0x106596,0x8(%esp)
  1029e1:	00 
  1029e2:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
  1029e9:	00 
  1029ea:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  1029f1:	e8 cf e2 ff ff       	call   100cc5 <__panic>
    if(n > nr_free){
  1029f6:	a1 58 89 11 00       	mov    0x118958,%eax
  1029fb:	3b 45 08             	cmp    0x8(%ebp),%eax
  1029fe:	73 0a                	jae    102a0a <default_alloc_pages+0x44>
	return NULL;
  102a00:	b8 00 00 00 00       	mov    $0x0,%eax
  102a05:	e9 45 01 00 00       	jmp    102b4f <default_alloc_pages+0x189>
    }
    struct Page *page = NULL;
  102a0a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  102a11:	c7 45 f0 50 89 11 00 	movl   $0x118950,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  102a18:	eb 1c                	jmp    102a36 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
  102a1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102a1d:	83 e8 0c             	sub    $0xc,%eax
  102a20:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if (p->property >= n) {
  102a23:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102a26:	8b 40 08             	mov    0x8(%eax),%eax
  102a29:	3b 45 08             	cmp    0x8(%ebp),%eax
  102a2c:	72 08                	jb     102a36 <default_alloc_pages+0x70>
            page = p;
  102a2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102a31:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  102a34:	eb 18                	jmp    102a4e <default_alloc_pages+0x88>
  102a36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102a39:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102a3c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102a3f:	8b 40 04             	mov    0x4(%eax),%eax
    if(n > nr_free){
	return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  102a42:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102a45:	81 7d f0 50 89 11 00 	cmpl   $0x118950,-0x10(%ebp)
  102a4c:	75 cc                	jne    102a1a <default_alloc_pages+0x54>
            page = p;
            break;
        }
    }
    list_entry_t *tle;
    if (page != NULL) {
  102a4e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102a52:	0f 84 f2 00 00 00    	je     102b4a <default_alloc_pages+0x184>
	int i = n;
  102a58:	8b 45 08             	mov    0x8(%ebp),%eax
  102a5b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	while(i--)
  102a5e:	eb 78                	jmp    102ad8 <default_alloc_pages+0x112>
  102a60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102a63:	89 45 d8             	mov    %eax,-0x28(%ebp)
  102a66:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102a69:	8b 40 04             	mov    0x4(%eax),%eax
	{
	    tle = list_next(le);
  102a6c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    struct Page *tp = le2page(le, page_link);
  102a6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102a72:	83 e8 0c             	sub    $0xc,%eax
  102a75:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    SetPageReserved(tp);
  102a78:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102a7b:	83 c0 04             	add    $0x4,%eax
  102a7e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  102a85:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102a88:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102a8b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102a8e:	0f ab 10             	bts    %edx,(%eax)
	    ClearPageProperty(tp);
  102a91:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102a94:	83 c0 04             	add    $0x4,%eax
  102a97:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  102a9e:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102aa1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102aa4:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102aa7:	0f b3 10             	btr    %edx,(%eax)
  102aaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102aad:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102ab0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102ab3:	8b 40 04             	mov    0x4(%eax),%eax
  102ab6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102ab9:	8b 12                	mov    (%edx),%edx
  102abb:	89 55 c0             	mov    %edx,-0x40(%ebp)
  102abe:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102ac1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102ac4:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102ac7:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102aca:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102acd:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102ad0:	89 10                	mov    %edx,(%eax)
	    list_del(le);
	    le = tle;
  102ad2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102ad5:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
    }
    list_entry_t *tle;
    if (page != NULL) {
	int i = n;
	while(i--)
  102ad8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102adb:	8d 50 ff             	lea    -0x1(%eax),%edx
  102ade:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102ae1:	85 c0                	test   %eax,%eax
  102ae3:	0f 85 77 ff ff ff    	jne    102a60 <default_alloc_pages+0x9a>
	    SetPageReserved(tp);
	    ClearPageProperty(tp);
	    list_del(le);
	    le = tle;
	}
	if(page->property > n)
  102ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102aec:	8b 40 08             	mov    0x8(%eax),%eax
  102aef:	3b 45 08             	cmp    0x8(%ebp),%eax
  102af2:	76 12                	jbe    102b06 <default_alloc_pages+0x140>
	{
	    (le2page(le,page_link))->property = page->property - n;
  102af4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102af7:	8d 50 f4             	lea    -0xc(%eax),%edx
  102afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102afd:	8b 40 08             	mov    0x8(%eax),%eax
  102b00:	2b 45 08             	sub    0x8(%ebp),%eax
  102b03:	89 42 08             	mov    %eax,0x8(%edx)
	}
	ClearPageProperty(page);
  102b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b09:	83 c0 04             	add    $0x4,%eax
  102b0c:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  102b13:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  102b16:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102b19:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102b1c:	0f b3 10             	btr    %edx,(%eax)
	SetPageReserved(page);
  102b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b22:	83 c0 04             	add    $0x4,%eax
  102b25:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  102b2c:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102b2f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102b32:	8b 55 b0             	mov    -0x50(%ebp),%edx
  102b35:	0f ab 10             	bts    %edx,(%eax)
	nr_free -= n;
  102b38:	a1 58 89 11 00       	mov    0x118958,%eax
  102b3d:	2b 45 08             	sub    0x8(%ebp),%eax
  102b40:	a3 58 89 11 00       	mov    %eax,0x118958
	return page;
  102b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b48:	eb 05                	jmp    102b4f <default_alloc_pages+0x189>
    }
    return NULL;
  102b4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102b4f:	c9                   	leave  
  102b50:	c3                   	ret    

00102b51 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  102b51:	55                   	push   %ebp
  102b52:	89 e5                	mov    %esp,%ebp
  102b54:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
  102b57:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102b5b:	75 24                	jne    102b81 <default_free_pages+0x30>
  102b5d:	c7 44 24 0c 90 65 10 	movl   $0x106590,0xc(%esp)
  102b64:	00 
  102b65:	c7 44 24 08 96 65 10 	movl   $0x106596,0x8(%esp)
  102b6c:	00 
  102b6d:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  102b74:	00 
  102b75:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  102b7c:	e8 44 e1 ff ff       	call   100cc5 <__panic>
    struct Page *p = base;
  102b81:	8b 45 08             	mov    0x8(%ebp),%eax
  102b84:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *le = &free_list;
  102b87:	c7 45 f0 50 89 11 00 	movl   $0x118950,-0x10(%ebp)
    while((le = list_next(le)) != &free_list)
  102b8e:	eb 13                	jmp    102ba3 <default_free_pages+0x52>
    {
	p = le2page(le, page_link);
  102b90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b93:	83 e8 0c             	sub    $0xc,%eax
  102b96:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(p > base) 
  102b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b9c:	3b 45 08             	cmp    0x8(%ebp),%eax
  102b9f:	76 02                	jbe    102ba3 <default_free_pages+0x52>
	    break;
  102ba1:	eb 18                	jmp    102bbb <default_free_pages+0x6a>
  102ba3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ba6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102ba9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102bac:	8b 40 04             	mov    0x4(%eax),%eax
static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    list_entry_t *le = &free_list;
    while((le = list_next(le)) != &free_list)
  102baf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102bb2:	81 7d f0 50 89 11 00 	cmpl   $0x118950,-0x10(%ebp)
  102bb9:	75 d5                	jne    102b90 <default_free_pages+0x3f>
    {
	p = le2page(le, page_link);
	if(p > base) 
	    break;
    }
    for(p=base;p<base+n;p++){
  102bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  102bbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102bc1:	eb 4b                	jmp    102c0e <default_free_pages+0xbd>
	list_add_before(le, &(p->page_link));
  102bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bc6:	8d 50 0c             	lea    0xc(%eax),%edx
  102bc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102bcc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102bcf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102bd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102bd5:	8b 00                	mov    (%eax),%eax
  102bd7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102bda:	89 55 e0             	mov    %edx,-0x20(%ebp)
  102bdd:	89 45 dc             	mov    %eax,-0x24(%ebp)
  102be0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102be3:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102be6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102be9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102bec:	89 10                	mov    %edx,(%eax)
  102bee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102bf1:	8b 10                	mov    (%eax),%edx
  102bf3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102bf6:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102bf9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102bfc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102bff:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102c02:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102c05:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102c08:	89 10                	mov    %edx,(%eax)
    {
	p = le2page(le, page_link);
	if(p > base) 
	    break;
    }
    for(p=base;p<base+n;p++){
  102c0a:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102c0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c11:	89 d0                	mov    %edx,%eax
  102c13:	c1 e0 02             	shl    $0x2,%eax
  102c16:	01 d0                	add    %edx,%eax
  102c18:	c1 e0 02             	shl    $0x2,%eax
  102c1b:	89 c2                	mov    %eax,%edx
  102c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  102c20:	01 d0                	add    %edx,%eax
  102c22:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102c25:	77 9c                	ja     102bc3 <default_free_pages+0x72>
	list_add_before(le, &(p->page_link));
    }
    base->flags = 0;
  102c27:	8b 45 08             	mov    0x8(%ebp),%eax
  102c2a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    set_page_ref(base, 0);
  102c31:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102c38:	00 
  102c39:	8b 45 08             	mov    0x8(%ebp),%eax
  102c3c:	89 04 24             	mov    %eax,(%esp)
  102c3f:	e8 03 fc ff ff       	call   102847 <set_page_ref>
    SetPageProperty(base);
  102c44:	8b 45 08             	mov    0x8(%ebp),%eax
  102c47:	83 c0 04             	add    $0x4,%eax
  102c4a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  102c51:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102c54:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102c57:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102c5a:	0f ab 10             	bts    %edx,(%eax)
    base->property = n;
  102c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  102c60:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c63:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free += n;
  102c66:	8b 15 58 89 11 00    	mov    0x118958,%edx
  102c6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c6f:	01 d0                	add    %edx,%eax
  102c71:	a3 58 89 11 00       	mov    %eax,0x118958
    p = le2page(le,page_link) ;
  102c76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c79:	83 e8 0c             	sub    $0xc,%eax
  102c7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if( base + n == p ){
  102c7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c82:	89 d0                	mov    %edx,%eax
  102c84:	c1 e0 02             	shl    $0x2,%eax
  102c87:	01 d0                	add    %edx,%eax
  102c89:	c1 e0 02             	shl    $0x2,%eax
  102c8c:	89 c2                	mov    %eax,%edx
  102c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  102c91:	01 d0                	add    %edx,%eax
  102c93:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102c96:	75 1e                	jne    102cb6 <default_free_pages+0x165>
	base->property += p->property;
  102c98:	8b 45 08             	mov    0x8(%ebp),%eax
  102c9b:	8b 50 08             	mov    0x8(%eax),%edx
  102c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ca1:	8b 40 08             	mov    0x8(%eax),%eax
  102ca4:	01 c2                	add    %eax,%edx
  102ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  102ca9:	89 50 08             	mov    %edx,0x8(%eax)
	p->property = 0;
  102cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102caf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    }
    le =  list_prev(&(base->page_link));
  102cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  102cb9:	83 c0 0c             	add    $0xc,%eax
  102cbc:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
  102cbf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102cc2:	8b 00                	mov    (%eax),%eax
  102cc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    p = le2page(le,page_link);
  102cc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102cca:	83 e8 0c             	sub    $0xc,%eax
  102ccd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(le!=&free_list && p == base - 1)
  102cd0:	81 7d f0 50 89 11 00 	cmpl   $0x118950,-0x10(%ebp)
  102cd7:	74 52                	je     102d2b <default_free_pages+0x1da>
  102cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  102cdc:	83 e8 14             	sub    $0x14,%eax
  102cdf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102ce2:	75 47                	jne    102d2b <default_free_pages+0x1da>
    {
	while(le != &free_list)
  102ce4:	eb 3c                	jmp    102d22 <default_free_pages+0x1d1>
	{
	    if(p -> property > 0)
  102ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ce9:	8b 40 08             	mov    0x8(%eax),%eax
  102cec:	85 c0                	test   %eax,%eax
  102cee:	74 20                	je     102d10 <default_free_pages+0x1bf>
	    {
		p->property += base->property;
  102cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cf3:	8b 50 08             	mov    0x8(%eax),%edx
  102cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  102cf9:	8b 40 08             	mov    0x8(%eax),%eax
  102cfc:	01 c2                	add    %eax,%edx
  102cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d01:	89 50 08             	mov    %edx,0x8(%eax)
		base->property = 0;
  102d04:	8b 45 08             	mov    0x8(%ebp),%eax
  102d07:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		break;
  102d0e:	eb 1b                	jmp    102d2b <default_free_pages+0x1da>
  102d10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d13:	89 45 c8             	mov    %eax,-0x38(%ebp)
  102d16:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102d19:	8b 00                	mov    (%eax),%eax
	    }
	    le = list_prev(le);
  102d1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    p--;
  102d1e:	83 6d f4 14          	subl   $0x14,-0xc(%ebp)
    }
    le =  list_prev(&(base->page_link));
    p = le2page(le,page_link);
    if(le!=&free_list && p == base - 1)
    {
	while(le != &free_list)
  102d22:	81 7d f0 50 89 11 00 	cmpl   $0x118950,-0x10(%ebp)
  102d29:	75 bb                	jne    102ce6 <default_free_pages+0x195>
	    }
	    le = list_prev(le);
	    p--;
    	}
    }
}
  102d2b:	c9                   	leave  
  102d2c:	c3                   	ret    

00102d2d <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  102d2d:	55                   	push   %ebp
  102d2e:	89 e5                	mov    %esp,%ebp
    return nr_free;
  102d30:	a1 58 89 11 00       	mov    0x118958,%eax
}
  102d35:	5d                   	pop    %ebp
  102d36:	c3                   	ret    

00102d37 <basic_check>:

static void
basic_check(void) {
  102d37:	55                   	push   %ebp
  102d38:	89 e5                	mov    %esp,%ebp
  102d3a:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  102d3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  102d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d47:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  102d50:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102d57:	e8 85 0e 00 00       	call   103be1 <alloc_pages>
  102d5c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102d5f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  102d63:	75 24                	jne    102d89 <basic_check+0x52>
  102d65:	c7 44 24 0c d1 65 10 	movl   $0x1065d1,0xc(%esp)
  102d6c:	00 
  102d6d:	c7 44 24 08 96 65 10 	movl   $0x106596,0x8(%esp)
  102d74:	00 
  102d75:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
  102d7c:	00 
  102d7d:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  102d84:	e8 3c df ff ff       	call   100cc5 <__panic>
    assert((p1 = alloc_page()) != NULL);
  102d89:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102d90:	e8 4c 0e 00 00       	call   103be1 <alloc_pages>
  102d95:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d98:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102d9c:	75 24                	jne    102dc2 <basic_check+0x8b>
  102d9e:	c7 44 24 0c ed 65 10 	movl   $0x1065ed,0xc(%esp)
  102da5:	00 
  102da6:	c7 44 24 08 96 65 10 	movl   $0x106596,0x8(%esp)
  102dad:	00 
  102dae:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
  102db5:	00 
  102db6:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  102dbd:	e8 03 df ff ff       	call   100cc5 <__panic>
    assert((p2 = alloc_page()) != NULL);
  102dc2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102dc9:	e8 13 0e 00 00       	call   103be1 <alloc_pages>
  102dce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102dd1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102dd5:	75 24                	jne    102dfb <basic_check+0xc4>
  102dd7:	c7 44 24 0c 09 66 10 	movl   $0x106609,0xc(%esp)
  102dde:	00 
  102ddf:	c7 44 24 08 96 65 10 	movl   $0x106596,0x8(%esp)
  102de6:	00 
  102de7:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
  102dee:	00 
  102def:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  102df6:	e8 ca de ff ff       	call   100cc5 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  102dfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102dfe:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102e01:	74 10                	je     102e13 <basic_check+0xdc>
  102e03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e06:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102e09:	74 08                	je     102e13 <basic_check+0xdc>
  102e0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e0e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102e11:	75 24                	jne    102e37 <basic_check+0x100>
  102e13:	c7 44 24 0c 28 66 10 	movl   $0x106628,0xc(%esp)
  102e1a:	00 
  102e1b:	c7 44 24 08 96 65 10 	movl   $0x106596,0x8(%esp)
  102e22:	00 
  102e23:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
  102e2a:	00 
  102e2b:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  102e32:	e8 8e de ff ff       	call   100cc5 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  102e37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e3a:	89 04 24             	mov    %eax,(%esp)
  102e3d:	e8 fb f9 ff ff       	call   10283d <page_ref>
  102e42:	85 c0                	test   %eax,%eax
  102e44:	75 1e                	jne    102e64 <basic_check+0x12d>
  102e46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e49:	89 04 24             	mov    %eax,(%esp)
  102e4c:	e8 ec f9 ff ff       	call   10283d <page_ref>
  102e51:	85 c0                	test   %eax,%eax
  102e53:	75 0f                	jne    102e64 <basic_check+0x12d>
  102e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e58:	89 04 24             	mov    %eax,(%esp)
  102e5b:	e8 dd f9 ff ff       	call   10283d <page_ref>
  102e60:	85 c0                	test   %eax,%eax
  102e62:	74 24                	je     102e88 <basic_check+0x151>
  102e64:	c7 44 24 0c 4c 66 10 	movl   $0x10664c,0xc(%esp)
  102e6b:	00 
  102e6c:	c7 44 24 08 96 65 10 	movl   $0x106596,0x8(%esp)
  102e73:	00 
  102e74:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
  102e7b:	00 
  102e7c:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  102e83:	e8 3d de ff ff       	call   100cc5 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  102e88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e8b:	89 04 24             	mov    %eax,(%esp)
  102e8e:	e8 94 f9 ff ff       	call   102827 <page2pa>
  102e93:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102e99:	c1 e2 0c             	shl    $0xc,%edx
  102e9c:	39 d0                	cmp    %edx,%eax
  102e9e:	72 24                	jb     102ec4 <basic_check+0x18d>
  102ea0:	c7 44 24 0c 88 66 10 	movl   $0x106688,0xc(%esp)
  102ea7:	00 
  102ea8:	c7 44 24 08 96 65 10 	movl   $0x106596,0x8(%esp)
  102eaf:	00 
  102eb0:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
  102eb7:	00 
  102eb8:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  102ebf:	e8 01 de ff ff       	call   100cc5 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  102ec4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ec7:	89 04 24             	mov    %eax,(%esp)
  102eca:	e8 58 f9 ff ff       	call   102827 <page2pa>
  102ecf:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102ed5:	c1 e2 0c             	shl    $0xc,%edx
  102ed8:	39 d0                	cmp    %edx,%eax
  102eda:	72 24                	jb     102f00 <basic_check+0x1c9>
  102edc:	c7 44 24 0c a5 66 10 	movl   $0x1066a5,0xc(%esp)
  102ee3:	00 
  102ee4:	c7 44 24 08 96 65 10 	movl   $0x106596,0x8(%esp)
  102eeb:	00 
  102eec:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
  102ef3:	00 
  102ef4:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  102efb:	e8 c5 dd ff ff       	call   100cc5 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  102f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f03:	89 04 24             	mov    %eax,(%esp)
  102f06:	e8 1c f9 ff ff       	call   102827 <page2pa>
  102f0b:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102f11:	c1 e2 0c             	shl    $0xc,%edx
  102f14:	39 d0                	cmp    %edx,%eax
  102f16:	72 24                	jb     102f3c <basic_check+0x205>
  102f18:	c7 44 24 0c c2 66 10 	movl   $0x1066c2,0xc(%esp)
  102f1f:	00 
  102f20:	c7 44 24 08 96 65 10 	movl   $0x106596,0x8(%esp)
  102f27:	00 
  102f28:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
  102f2f:	00 
  102f30:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  102f37:	e8 89 dd ff ff       	call   100cc5 <__panic>

    list_entry_t free_list_store = free_list;
  102f3c:	a1 50 89 11 00       	mov    0x118950,%eax
  102f41:	8b 15 54 89 11 00    	mov    0x118954,%edx
  102f47:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102f4a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102f4d:	c7 45 e0 50 89 11 00 	movl   $0x118950,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  102f54:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f57:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102f5a:	89 50 04             	mov    %edx,0x4(%eax)
  102f5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f60:	8b 50 04             	mov    0x4(%eax),%edx
  102f63:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f66:	89 10                	mov    %edx,(%eax)
  102f68:	c7 45 dc 50 89 11 00 	movl   $0x118950,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  102f6f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102f72:	8b 40 04             	mov    0x4(%eax),%eax
  102f75:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  102f78:	0f 94 c0             	sete   %al
  102f7b:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  102f7e:	85 c0                	test   %eax,%eax
  102f80:	75 24                	jne    102fa6 <basic_check+0x26f>
  102f82:	c7 44 24 0c df 66 10 	movl   $0x1066df,0xc(%esp)
  102f89:	00 
  102f8a:	c7 44 24 08 96 65 10 	movl   $0x106596,0x8(%esp)
  102f91:	00 
  102f92:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
  102f99:	00 
  102f9a:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  102fa1:	e8 1f dd ff ff       	call   100cc5 <__panic>

    unsigned int nr_free_store = nr_free;
  102fa6:	a1 58 89 11 00       	mov    0x118958,%eax
  102fab:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  102fae:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  102fb5:	00 00 00 

    assert(alloc_page() == NULL);
  102fb8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102fbf:	e8 1d 0c 00 00       	call   103be1 <alloc_pages>
  102fc4:	85 c0                	test   %eax,%eax
  102fc6:	74 24                	je     102fec <basic_check+0x2b5>
  102fc8:	c7 44 24 0c f6 66 10 	movl   $0x1066f6,0xc(%esp)
  102fcf:	00 
  102fd0:	c7 44 24 08 96 65 10 	movl   $0x106596,0x8(%esp)
  102fd7:	00 
  102fd8:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
  102fdf:	00 
  102fe0:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  102fe7:	e8 d9 dc ff ff       	call   100cc5 <__panic>

    free_page(p0);
  102fec:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  102ff3:	00 
  102ff4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ff7:	89 04 24             	mov    %eax,(%esp)
  102ffa:	e8 1a 0c 00 00       	call   103c19 <free_pages>
    free_page(p1);
  102fff:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103006:	00 
  103007:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10300a:	89 04 24             	mov    %eax,(%esp)
  10300d:	e8 07 0c 00 00       	call   103c19 <free_pages>
    free_page(p2);
  103012:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103019:	00 
  10301a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10301d:	89 04 24             	mov    %eax,(%esp)
  103020:	e8 f4 0b 00 00       	call   103c19 <free_pages>
    assert(nr_free == 3);
  103025:	a1 58 89 11 00       	mov    0x118958,%eax
  10302a:	83 f8 03             	cmp    $0x3,%eax
  10302d:	74 24                	je     103053 <basic_check+0x31c>
  10302f:	c7 44 24 0c 0b 67 10 	movl   $0x10670b,0xc(%esp)
  103036:	00 
  103037:	c7 44 24 08 96 65 10 	movl   $0x106596,0x8(%esp)
  10303e:	00 
  10303f:	c7 44 24 04 c5 00 00 	movl   $0xc5,0x4(%esp)
  103046:	00 
  103047:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  10304e:	e8 72 dc ff ff       	call   100cc5 <__panic>

    assert((p0 = alloc_page()) != NULL);
  103053:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10305a:	e8 82 0b 00 00       	call   103be1 <alloc_pages>
  10305f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103062:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  103066:	75 24                	jne    10308c <basic_check+0x355>
  103068:	c7 44 24 0c d1 65 10 	movl   $0x1065d1,0xc(%esp)
  10306f:	00 
  103070:	c7 44 24 08 96 65 10 	movl   $0x106596,0x8(%esp)
  103077:	00 
  103078:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
  10307f:	00 
  103080:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  103087:	e8 39 dc ff ff       	call   100cc5 <__panic>
    assert((p1 = alloc_page()) != NULL);
  10308c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103093:	e8 49 0b 00 00       	call   103be1 <alloc_pages>
  103098:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10309b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10309f:	75 24                	jne    1030c5 <basic_check+0x38e>
  1030a1:	c7 44 24 0c ed 65 10 	movl   $0x1065ed,0xc(%esp)
  1030a8:	00 
  1030a9:	c7 44 24 08 96 65 10 	movl   $0x106596,0x8(%esp)
  1030b0:	00 
  1030b1:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
  1030b8:	00 
  1030b9:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  1030c0:	e8 00 dc ff ff       	call   100cc5 <__panic>
    assert((p2 = alloc_page()) != NULL);
  1030c5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1030cc:	e8 10 0b 00 00       	call   103be1 <alloc_pages>
  1030d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1030d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1030d8:	75 24                	jne    1030fe <basic_check+0x3c7>
  1030da:	c7 44 24 0c 09 66 10 	movl   $0x106609,0xc(%esp)
  1030e1:	00 
  1030e2:	c7 44 24 08 96 65 10 	movl   $0x106596,0x8(%esp)
  1030e9:	00 
  1030ea:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
  1030f1:	00 
  1030f2:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  1030f9:	e8 c7 db ff ff       	call   100cc5 <__panic>

    assert(alloc_page() == NULL);
  1030fe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103105:	e8 d7 0a 00 00       	call   103be1 <alloc_pages>
  10310a:	85 c0                	test   %eax,%eax
  10310c:	74 24                	je     103132 <basic_check+0x3fb>
  10310e:	c7 44 24 0c f6 66 10 	movl   $0x1066f6,0xc(%esp)
  103115:	00 
  103116:	c7 44 24 08 96 65 10 	movl   $0x106596,0x8(%esp)
  10311d:	00 
  10311e:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
  103125:	00 
  103126:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  10312d:	e8 93 db ff ff       	call   100cc5 <__panic>

    free_page(p0);
  103132:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103139:	00 
  10313a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10313d:	89 04 24             	mov    %eax,(%esp)
  103140:	e8 d4 0a 00 00       	call   103c19 <free_pages>
  103145:	c7 45 d8 50 89 11 00 	movl   $0x118950,-0x28(%ebp)
  10314c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10314f:	8b 40 04             	mov    0x4(%eax),%eax
  103152:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  103155:	0f 94 c0             	sete   %al
  103158:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  10315b:	85 c0                	test   %eax,%eax
  10315d:	74 24                	je     103183 <basic_check+0x44c>
  10315f:	c7 44 24 0c 18 67 10 	movl   $0x106718,0xc(%esp)
  103166:	00 
  103167:	c7 44 24 08 96 65 10 	movl   $0x106596,0x8(%esp)
  10316e:	00 
  10316f:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
  103176:	00 
  103177:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  10317e:	e8 42 db ff ff       	call   100cc5 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  103183:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10318a:	e8 52 0a 00 00       	call   103be1 <alloc_pages>
  10318f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103192:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103195:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103198:	74 24                	je     1031be <basic_check+0x487>
  10319a:	c7 44 24 0c 30 67 10 	movl   $0x106730,0xc(%esp)
  1031a1:	00 
  1031a2:	c7 44 24 08 96 65 10 	movl   $0x106596,0x8(%esp)
  1031a9:	00 
  1031aa:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
  1031b1:	00 
  1031b2:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  1031b9:	e8 07 db ff ff       	call   100cc5 <__panic>
    assert(alloc_page() == NULL);
  1031be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1031c5:	e8 17 0a 00 00       	call   103be1 <alloc_pages>
  1031ca:	85 c0                	test   %eax,%eax
  1031cc:	74 24                	je     1031f2 <basic_check+0x4bb>
  1031ce:	c7 44 24 0c f6 66 10 	movl   $0x1066f6,0xc(%esp)
  1031d5:	00 
  1031d6:	c7 44 24 08 96 65 10 	movl   $0x106596,0x8(%esp)
  1031dd:	00 
  1031de:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
  1031e5:	00 
  1031e6:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  1031ed:	e8 d3 da ff ff       	call   100cc5 <__panic>

    assert(nr_free == 0);
  1031f2:	a1 58 89 11 00       	mov    0x118958,%eax
  1031f7:	85 c0                	test   %eax,%eax
  1031f9:	74 24                	je     10321f <basic_check+0x4e8>
  1031fb:	c7 44 24 0c 49 67 10 	movl   $0x106749,0xc(%esp)
  103202:	00 
  103203:	c7 44 24 08 96 65 10 	movl   $0x106596,0x8(%esp)
  10320a:	00 
  10320b:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
  103212:	00 
  103213:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  10321a:	e8 a6 da ff ff       	call   100cc5 <__panic>
    free_list = free_list_store;
  10321f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103222:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103225:	a3 50 89 11 00       	mov    %eax,0x118950
  10322a:	89 15 54 89 11 00    	mov    %edx,0x118954
    nr_free = nr_free_store;
  103230:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103233:	a3 58 89 11 00       	mov    %eax,0x118958

    free_page(p);
  103238:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10323f:	00 
  103240:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103243:	89 04 24             	mov    %eax,(%esp)
  103246:	e8 ce 09 00 00       	call   103c19 <free_pages>
    free_page(p1);
  10324b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103252:	00 
  103253:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103256:	89 04 24             	mov    %eax,(%esp)
  103259:	e8 bb 09 00 00       	call   103c19 <free_pages>
    free_page(p2);
  10325e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103265:	00 
  103266:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103269:	89 04 24             	mov    %eax,(%esp)
  10326c:	e8 a8 09 00 00       	call   103c19 <free_pages>
}
  103271:	c9                   	leave  
  103272:	c3                   	ret    

00103273 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  103273:	55                   	push   %ebp
  103274:	89 e5                	mov    %esp,%ebp
  103276:	53                   	push   %ebx
  103277:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
  10327d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103284:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  10328b:	c7 45 ec 50 89 11 00 	movl   $0x118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103292:	eb 6b                	jmp    1032ff <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
  103294:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103297:	83 e8 0c             	sub    $0xc,%eax
  10329a:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  10329d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1032a0:	83 c0 04             	add    $0x4,%eax
  1032a3:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  1032aa:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1032ad:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1032b0:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1032b3:	0f a3 10             	bt     %edx,(%eax)
  1032b6:	19 c0                	sbb    %eax,%eax
  1032b8:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  1032bb:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  1032bf:	0f 95 c0             	setne  %al
  1032c2:	0f b6 c0             	movzbl %al,%eax
  1032c5:	85 c0                	test   %eax,%eax
  1032c7:	75 24                	jne    1032ed <default_check+0x7a>
  1032c9:	c7 44 24 0c 56 67 10 	movl   $0x106756,0xc(%esp)
  1032d0:	00 
  1032d1:	c7 44 24 08 96 65 10 	movl   $0x106596,0x8(%esp)
  1032d8:	00 
  1032d9:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
  1032e0:	00 
  1032e1:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  1032e8:	e8 d8 d9 ff ff       	call   100cc5 <__panic>
        count ++, total += p->property;
  1032ed:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1032f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1032f4:	8b 50 08             	mov    0x8(%eax),%edx
  1032f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032fa:	01 d0                	add    %edx,%eax
  1032fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1032ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103302:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103305:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103308:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  10330b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10330e:	81 7d ec 50 89 11 00 	cmpl   $0x118950,-0x14(%ebp)
  103315:	0f 85 79 ff ff ff    	jne    103294 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  10331b:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  10331e:	e8 28 09 00 00       	call   103c4b <nr_free_pages>
  103323:	39 c3                	cmp    %eax,%ebx
  103325:	74 24                	je     10334b <default_check+0xd8>
  103327:	c7 44 24 0c 66 67 10 	movl   $0x106766,0xc(%esp)
  10332e:	00 
  10332f:	c7 44 24 08 96 65 10 	movl   $0x106596,0x8(%esp)
  103336:	00 
  103337:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
  10333e:	00 
  10333f:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  103346:	e8 7a d9 ff ff       	call   100cc5 <__panic>

    basic_check();
  10334b:	e8 e7 f9 ff ff       	call   102d37 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  103350:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103357:	e8 85 08 00 00       	call   103be1 <alloc_pages>
  10335c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  10335f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103363:	75 24                	jne    103389 <default_check+0x116>
  103365:	c7 44 24 0c 7f 67 10 	movl   $0x10677f,0xc(%esp)
  10336c:	00 
  10336d:	c7 44 24 08 96 65 10 	movl   $0x106596,0x8(%esp)
  103374:	00 
  103375:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
  10337c:	00 
  10337d:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  103384:	e8 3c d9 ff ff       	call   100cc5 <__panic>
    assert(!PageProperty(p0));
  103389:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10338c:	83 c0 04             	add    $0x4,%eax
  10338f:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  103396:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103399:	8b 45 bc             	mov    -0x44(%ebp),%eax
  10339c:	8b 55 c0             	mov    -0x40(%ebp),%edx
  10339f:	0f a3 10             	bt     %edx,(%eax)
  1033a2:	19 c0                	sbb    %eax,%eax
  1033a4:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  1033a7:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  1033ab:	0f 95 c0             	setne  %al
  1033ae:	0f b6 c0             	movzbl %al,%eax
  1033b1:	85 c0                	test   %eax,%eax
  1033b3:	74 24                	je     1033d9 <default_check+0x166>
  1033b5:	c7 44 24 0c 8a 67 10 	movl   $0x10678a,0xc(%esp)
  1033bc:	00 
  1033bd:	c7 44 24 08 96 65 10 	movl   $0x106596,0x8(%esp)
  1033c4:	00 
  1033c5:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
  1033cc:	00 
  1033cd:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  1033d4:	e8 ec d8 ff ff       	call   100cc5 <__panic>

    list_entry_t free_list_store = free_list;
  1033d9:	a1 50 89 11 00       	mov    0x118950,%eax
  1033de:	8b 15 54 89 11 00    	mov    0x118954,%edx
  1033e4:	89 45 80             	mov    %eax,-0x80(%ebp)
  1033e7:	89 55 84             	mov    %edx,-0x7c(%ebp)
  1033ea:	c7 45 b4 50 89 11 00 	movl   $0x118950,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1033f1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1033f4:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  1033f7:	89 50 04             	mov    %edx,0x4(%eax)
  1033fa:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1033fd:	8b 50 04             	mov    0x4(%eax),%edx
  103400:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103403:	89 10                	mov    %edx,(%eax)
  103405:	c7 45 b0 50 89 11 00 	movl   $0x118950,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  10340c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10340f:	8b 40 04             	mov    0x4(%eax),%eax
  103412:	39 45 b0             	cmp    %eax,-0x50(%ebp)
  103415:	0f 94 c0             	sete   %al
  103418:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10341b:	85 c0                	test   %eax,%eax
  10341d:	75 24                	jne    103443 <default_check+0x1d0>
  10341f:	c7 44 24 0c df 66 10 	movl   $0x1066df,0xc(%esp)
  103426:	00 
  103427:	c7 44 24 08 96 65 10 	movl   $0x106596,0x8(%esp)
  10342e:	00 
  10342f:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
  103436:	00 
  103437:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  10343e:	e8 82 d8 ff ff       	call   100cc5 <__panic>
    assert(alloc_page() == NULL);
  103443:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10344a:	e8 92 07 00 00       	call   103be1 <alloc_pages>
  10344f:	85 c0                	test   %eax,%eax
  103451:	74 24                	je     103477 <default_check+0x204>
  103453:	c7 44 24 0c f6 66 10 	movl   $0x1066f6,0xc(%esp)
  10345a:	00 
  10345b:	c7 44 24 08 96 65 10 	movl   $0x106596,0x8(%esp)
  103462:	00 
  103463:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
  10346a:	00 
  10346b:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  103472:	e8 4e d8 ff ff       	call   100cc5 <__panic>

    unsigned int nr_free_store = nr_free;
  103477:	a1 58 89 11 00       	mov    0x118958,%eax
  10347c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  10347f:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  103486:	00 00 00 

    free_pages(p0 + 2, 3);
  103489:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10348c:	83 c0 28             	add    $0x28,%eax
  10348f:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  103496:	00 
  103497:	89 04 24             	mov    %eax,(%esp)
  10349a:	e8 7a 07 00 00       	call   103c19 <free_pages>
    assert(alloc_pages(4) == NULL);
  10349f:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1034a6:	e8 36 07 00 00       	call   103be1 <alloc_pages>
  1034ab:	85 c0                	test   %eax,%eax
  1034ad:	74 24                	je     1034d3 <default_check+0x260>
  1034af:	c7 44 24 0c 9c 67 10 	movl   $0x10679c,0xc(%esp)
  1034b6:	00 
  1034b7:	c7 44 24 08 96 65 10 	movl   $0x106596,0x8(%esp)
  1034be:	00 
  1034bf:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
  1034c6:	00 
  1034c7:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  1034ce:	e8 f2 d7 ff ff       	call   100cc5 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  1034d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1034d6:	83 c0 28             	add    $0x28,%eax
  1034d9:	83 c0 04             	add    $0x4,%eax
  1034dc:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  1034e3:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1034e6:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1034e9:	8b 55 ac             	mov    -0x54(%ebp),%edx
  1034ec:	0f a3 10             	bt     %edx,(%eax)
  1034ef:	19 c0                	sbb    %eax,%eax
  1034f1:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  1034f4:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  1034f8:	0f 95 c0             	setne  %al
  1034fb:	0f b6 c0             	movzbl %al,%eax
  1034fe:	85 c0                	test   %eax,%eax
  103500:	74 0e                	je     103510 <default_check+0x29d>
  103502:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103505:	83 c0 28             	add    $0x28,%eax
  103508:	8b 40 08             	mov    0x8(%eax),%eax
  10350b:	83 f8 03             	cmp    $0x3,%eax
  10350e:	74 24                	je     103534 <default_check+0x2c1>
  103510:	c7 44 24 0c b4 67 10 	movl   $0x1067b4,0xc(%esp)
  103517:	00 
  103518:	c7 44 24 08 96 65 10 	movl   $0x106596,0x8(%esp)
  10351f:	00 
  103520:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  103527:	00 
  103528:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  10352f:	e8 91 d7 ff ff       	call   100cc5 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  103534:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  10353b:	e8 a1 06 00 00       	call   103be1 <alloc_pages>
  103540:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103543:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103547:	75 24                	jne    10356d <default_check+0x2fa>
  103549:	c7 44 24 0c e0 67 10 	movl   $0x1067e0,0xc(%esp)
  103550:	00 
  103551:	c7 44 24 08 96 65 10 	movl   $0x106596,0x8(%esp)
  103558:	00 
  103559:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
  103560:	00 
  103561:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  103568:	e8 58 d7 ff ff       	call   100cc5 <__panic>
    assert(alloc_page() == NULL);
  10356d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103574:	e8 68 06 00 00       	call   103be1 <alloc_pages>
  103579:	85 c0                	test   %eax,%eax
  10357b:	74 24                	je     1035a1 <default_check+0x32e>
  10357d:	c7 44 24 0c f6 66 10 	movl   $0x1066f6,0xc(%esp)
  103584:	00 
  103585:	c7 44 24 08 96 65 10 	movl   $0x106596,0x8(%esp)
  10358c:	00 
  10358d:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
  103594:	00 
  103595:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  10359c:	e8 24 d7 ff ff       	call   100cc5 <__panic>
    assert(p0 + 2 == p1);
  1035a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1035a4:	83 c0 28             	add    $0x28,%eax
  1035a7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  1035aa:	74 24                	je     1035d0 <default_check+0x35d>
  1035ac:	c7 44 24 0c fe 67 10 	movl   $0x1067fe,0xc(%esp)
  1035b3:	00 
  1035b4:	c7 44 24 08 96 65 10 	movl   $0x106596,0x8(%esp)
  1035bb:	00 
  1035bc:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
  1035c3:	00 
  1035c4:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  1035cb:	e8 f5 d6 ff ff       	call   100cc5 <__panic>

    p2 = p0 + 1;
  1035d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1035d3:	83 c0 14             	add    $0x14,%eax
  1035d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  1035d9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1035e0:	00 
  1035e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1035e4:	89 04 24             	mov    %eax,(%esp)
  1035e7:	e8 2d 06 00 00       	call   103c19 <free_pages>
    free_pages(p1, 3);
  1035ec:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1035f3:	00 
  1035f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1035f7:	89 04 24             	mov    %eax,(%esp)
  1035fa:	e8 1a 06 00 00       	call   103c19 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  1035ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103602:	83 c0 04             	add    $0x4,%eax
  103605:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  10360c:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10360f:	8b 45 9c             	mov    -0x64(%ebp),%eax
  103612:	8b 55 a0             	mov    -0x60(%ebp),%edx
  103615:	0f a3 10             	bt     %edx,(%eax)
  103618:	19 c0                	sbb    %eax,%eax
  10361a:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  10361d:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  103621:	0f 95 c0             	setne  %al
  103624:	0f b6 c0             	movzbl %al,%eax
  103627:	85 c0                	test   %eax,%eax
  103629:	74 0b                	je     103636 <default_check+0x3c3>
  10362b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10362e:	8b 40 08             	mov    0x8(%eax),%eax
  103631:	83 f8 01             	cmp    $0x1,%eax
  103634:	74 24                	je     10365a <default_check+0x3e7>
  103636:	c7 44 24 0c 0c 68 10 	movl   $0x10680c,0xc(%esp)
  10363d:	00 
  10363e:	c7 44 24 08 96 65 10 	movl   $0x106596,0x8(%esp)
  103645:	00 
  103646:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
  10364d:	00 
  10364e:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  103655:	e8 6b d6 ff ff       	call   100cc5 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  10365a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10365d:	83 c0 04             	add    $0x4,%eax
  103660:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  103667:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10366a:	8b 45 90             	mov    -0x70(%ebp),%eax
  10366d:	8b 55 94             	mov    -0x6c(%ebp),%edx
  103670:	0f a3 10             	bt     %edx,(%eax)
  103673:	19 c0                	sbb    %eax,%eax
  103675:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  103678:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  10367c:	0f 95 c0             	setne  %al
  10367f:	0f b6 c0             	movzbl %al,%eax
  103682:	85 c0                	test   %eax,%eax
  103684:	74 0b                	je     103691 <default_check+0x41e>
  103686:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103689:	8b 40 08             	mov    0x8(%eax),%eax
  10368c:	83 f8 03             	cmp    $0x3,%eax
  10368f:	74 24                	je     1036b5 <default_check+0x442>
  103691:	c7 44 24 0c 34 68 10 	movl   $0x106834,0xc(%esp)
  103698:	00 
  103699:	c7 44 24 08 96 65 10 	movl   $0x106596,0x8(%esp)
  1036a0:	00 
  1036a1:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  1036a8:	00 
  1036a9:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  1036b0:	e8 10 d6 ff ff       	call   100cc5 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  1036b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1036bc:	e8 20 05 00 00       	call   103be1 <alloc_pages>
  1036c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1036c4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1036c7:	83 e8 14             	sub    $0x14,%eax
  1036ca:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1036cd:	74 24                	je     1036f3 <default_check+0x480>
  1036cf:	c7 44 24 0c 5a 68 10 	movl   $0x10685a,0xc(%esp)
  1036d6:	00 
  1036d7:	c7 44 24 08 96 65 10 	movl   $0x106596,0x8(%esp)
  1036de:	00 
  1036df:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
  1036e6:	00 
  1036e7:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  1036ee:	e8 d2 d5 ff ff       	call   100cc5 <__panic>
    free_page(p0);
  1036f3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1036fa:	00 
  1036fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036fe:	89 04 24             	mov    %eax,(%esp)
  103701:	e8 13 05 00 00       	call   103c19 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  103706:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10370d:	e8 cf 04 00 00       	call   103be1 <alloc_pages>
  103712:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103715:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103718:	83 c0 14             	add    $0x14,%eax
  10371b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  10371e:	74 24                	je     103744 <default_check+0x4d1>
  103720:	c7 44 24 0c 78 68 10 	movl   $0x106878,0xc(%esp)
  103727:	00 
  103728:	c7 44 24 08 96 65 10 	movl   $0x106596,0x8(%esp)
  10372f:	00 
  103730:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
  103737:	00 
  103738:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  10373f:	e8 81 d5 ff ff       	call   100cc5 <__panic>

    free_pages(p0, 2);
  103744:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  10374b:	00 
  10374c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10374f:	89 04 24             	mov    %eax,(%esp)
  103752:	e8 c2 04 00 00       	call   103c19 <free_pages>
    free_page(p2);
  103757:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10375e:	00 
  10375f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103762:	89 04 24             	mov    %eax,(%esp)
  103765:	e8 af 04 00 00       	call   103c19 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  10376a:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103771:	e8 6b 04 00 00       	call   103be1 <alloc_pages>
  103776:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103779:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10377d:	75 24                	jne    1037a3 <default_check+0x530>
  10377f:	c7 44 24 0c 98 68 10 	movl   $0x106898,0xc(%esp)
  103786:	00 
  103787:	c7 44 24 08 96 65 10 	movl   $0x106596,0x8(%esp)
  10378e:	00 
  10378f:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  103796:	00 
  103797:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  10379e:	e8 22 d5 ff ff       	call   100cc5 <__panic>
    assert(alloc_page() == NULL);
  1037a3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1037aa:	e8 32 04 00 00       	call   103be1 <alloc_pages>
  1037af:	85 c0                	test   %eax,%eax
  1037b1:	74 24                	je     1037d7 <default_check+0x564>
  1037b3:	c7 44 24 0c f6 66 10 	movl   $0x1066f6,0xc(%esp)
  1037ba:	00 
  1037bb:	c7 44 24 08 96 65 10 	movl   $0x106596,0x8(%esp)
  1037c2:	00 
  1037c3:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
  1037ca:	00 
  1037cb:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  1037d2:	e8 ee d4 ff ff       	call   100cc5 <__panic>

    assert(nr_free == 0);
  1037d7:	a1 58 89 11 00       	mov    0x118958,%eax
  1037dc:	85 c0                	test   %eax,%eax
  1037de:	74 24                	je     103804 <default_check+0x591>
  1037e0:	c7 44 24 0c 49 67 10 	movl   $0x106749,0xc(%esp)
  1037e7:	00 
  1037e8:	c7 44 24 08 96 65 10 	movl   $0x106596,0x8(%esp)
  1037ef:	00 
  1037f0:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
  1037f7:	00 
  1037f8:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  1037ff:	e8 c1 d4 ff ff       	call   100cc5 <__panic>
    nr_free = nr_free_store;
  103804:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103807:	a3 58 89 11 00       	mov    %eax,0x118958

    free_list = free_list_store;
  10380c:	8b 45 80             	mov    -0x80(%ebp),%eax
  10380f:	8b 55 84             	mov    -0x7c(%ebp),%edx
  103812:	a3 50 89 11 00       	mov    %eax,0x118950
  103817:	89 15 54 89 11 00    	mov    %edx,0x118954
    free_pages(p0, 5);
  10381d:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  103824:	00 
  103825:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103828:	89 04 24             	mov    %eax,(%esp)
  10382b:	e8 e9 03 00 00       	call   103c19 <free_pages>

    le = &free_list;
  103830:	c7 45 ec 50 89 11 00 	movl   $0x118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103837:	eb 1d                	jmp    103856 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
  103839:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10383c:	83 e8 0c             	sub    $0xc,%eax
  10383f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  103842:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  103846:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103849:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10384c:	8b 40 08             	mov    0x8(%eax),%eax
  10384f:	29 c2                	sub    %eax,%edx
  103851:	89 d0                	mov    %edx,%eax
  103853:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103856:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103859:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  10385c:	8b 45 88             	mov    -0x78(%ebp),%eax
  10385f:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  103862:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103865:	81 7d ec 50 89 11 00 	cmpl   $0x118950,-0x14(%ebp)
  10386c:	75 cb                	jne    103839 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  10386e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103872:	74 24                	je     103898 <default_check+0x625>
  103874:	c7 44 24 0c b6 68 10 	movl   $0x1068b6,0xc(%esp)
  10387b:	00 
  10387c:	c7 44 24 08 96 65 10 	movl   $0x106596,0x8(%esp)
  103883:	00 
  103884:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
  10388b:	00 
  10388c:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  103893:	e8 2d d4 ff ff       	call   100cc5 <__panic>
    assert(total == 0);
  103898:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10389c:	74 24                	je     1038c2 <default_check+0x64f>
  10389e:	c7 44 24 0c c1 68 10 	movl   $0x1068c1,0xc(%esp)
  1038a5:	00 
  1038a6:	c7 44 24 08 96 65 10 	movl   $0x106596,0x8(%esp)
  1038ad:	00 
  1038ae:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
  1038b5:	00 
  1038b6:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  1038bd:	e8 03 d4 ff ff       	call   100cc5 <__panic>
}
  1038c2:	81 c4 94 00 00 00    	add    $0x94,%esp
  1038c8:	5b                   	pop    %ebx
  1038c9:	5d                   	pop    %ebp
  1038ca:	c3                   	ret    

001038cb <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  1038cb:	55                   	push   %ebp
  1038cc:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1038ce:	8b 55 08             	mov    0x8(%ebp),%edx
  1038d1:	a1 64 89 11 00       	mov    0x118964,%eax
  1038d6:	29 c2                	sub    %eax,%edx
  1038d8:	89 d0                	mov    %edx,%eax
  1038da:	c1 f8 02             	sar    $0x2,%eax
  1038dd:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1038e3:	5d                   	pop    %ebp
  1038e4:	c3                   	ret    

001038e5 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  1038e5:	55                   	push   %ebp
  1038e6:	89 e5                	mov    %esp,%ebp
  1038e8:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1038eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1038ee:	89 04 24             	mov    %eax,(%esp)
  1038f1:	e8 d5 ff ff ff       	call   1038cb <page2ppn>
  1038f6:	c1 e0 0c             	shl    $0xc,%eax
}
  1038f9:	c9                   	leave  
  1038fa:	c3                   	ret    

001038fb <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  1038fb:	55                   	push   %ebp
  1038fc:	89 e5                	mov    %esp,%ebp
  1038fe:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  103901:	8b 45 08             	mov    0x8(%ebp),%eax
  103904:	c1 e8 0c             	shr    $0xc,%eax
  103907:	89 c2                	mov    %eax,%edx
  103909:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  10390e:	39 c2                	cmp    %eax,%edx
  103910:	72 1c                	jb     10392e <pa2page+0x33>
        panic("pa2page called with invalid pa");
  103912:	c7 44 24 08 fc 68 10 	movl   $0x1068fc,0x8(%esp)
  103919:	00 
  10391a:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  103921:	00 
  103922:	c7 04 24 1b 69 10 00 	movl   $0x10691b,(%esp)
  103929:	e8 97 d3 ff ff       	call   100cc5 <__panic>
    }
    return &pages[PPN(pa)];
  10392e:	8b 0d 64 89 11 00    	mov    0x118964,%ecx
  103934:	8b 45 08             	mov    0x8(%ebp),%eax
  103937:	c1 e8 0c             	shr    $0xc,%eax
  10393a:	89 c2                	mov    %eax,%edx
  10393c:	89 d0                	mov    %edx,%eax
  10393e:	c1 e0 02             	shl    $0x2,%eax
  103941:	01 d0                	add    %edx,%eax
  103943:	c1 e0 02             	shl    $0x2,%eax
  103946:	01 c8                	add    %ecx,%eax
}
  103948:	c9                   	leave  
  103949:	c3                   	ret    

0010394a <page2kva>:

static inline void *
page2kva(struct Page *page) {
  10394a:	55                   	push   %ebp
  10394b:	89 e5                	mov    %esp,%ebp
  10394d:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  103950:	8b 45 08             	mov    0x8(%ebp),%eax
  103953:	89 04 24             	mov    %eax,(%esp)
  103956:	e8 8a ff ff ff       	call   1038e5 <page2pa>
  10395b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10395e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103961:	c1 e8 0c             	shr    $0xc,%eax
  103964:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103967:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  10396c:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  10396f:	72 23                	jb     103994 <page2kva+0x4a>
  103971:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103974:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103978:	c7 44 24 08 2c 69 10 	movl   $0x10692c,0x8(%esp)
  10397f:	00 
  103980:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  103987:	00 
  103988:	c7 04 24 1b 69 10 00 	movl   $0x10691b,(%esp)
  10398f:	e8 31 d3 ff ff       	call   100cc5 <__panic>
  103994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103997:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  10399c:	c9                   	leave  
  10399d:	c3                   	ret    

0010399e <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  10399e:	55                   	push   %ebp
  10399f:	89 e5                	mov    %esp,%ebp
  1039a1:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  1039a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1039a7:	83 e0 01             	and    $0x1,%eax
  1039aa:	85 c0                	test   %eax,%eax
  1039ac:	75 1c                	jne    1039ca <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  1039ae:	c7 44 24 08 50 69 10 	movl   $0x106950,0x8(%esp)
  1039b5:	00 
  1039b6:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  1039bd:	00 
  1039be:	c7 04 24 1b 69 10 00 	movl   $0x10691b,(%esp)
  1039c5:	e8 fb d2 ff ff       	call   100cc5 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  1039ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1039cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1039d2:	89 04 24             	mov    %eax,(%esp)
  1039d5:	e8 21 ff ff ff       	call   1038fb <pa2page>
}
  1039da:	c9                   	leave  
  1039db:	c3                   	ret    

001039dc <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  1039dc:	55                   	push   %ebp
  1039dd:	89 e5                	mov    %esp,%ebp
    return page->ref;
  1039df:	8b 45 08             	mov    0x8(%ebp),%eax
  1039e2:	8b 00                	mov    (%eax),%eax
}
  1039e4:	5d                   	pop    %ebp
  1039e5:	c3                   	ret    

001039e6 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  1039e6:	55                   	push   %ebp
  1039e7:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  1039e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1039ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  1039ef:	89 10                	mov    %edx,(%eax)
}
  1039f1:	5d                   	pop    %ebp
  1039f2:	c3                   	ret    

001039f3 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  1039f3:	55                   	push   %ebp
  1039f4:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  1039f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1039f9:	8b 00                	mov    (%eax),%eax
  1039fb:	8d 50 01             	lea    0x1(%eax),%edx
  1039fe:	8b 45 08             	mov    0x8(%ebp),%eax
  103a01:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103a03:	8b 45 08             	mov    0x8(%ebp),%eax
  103a06:	8b 00                	mov    (%eax),%eax
}
  103a08:	5d                   	pop    %ebp
  103a09:	c3                   	ret    

00103a0a <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  103a0a:	55                   	push   %ebp
  103a0b:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  103a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  103a10:	8b 00                	mov    (%eax),%eax
  103a12:	8d 50 ff             	lea    -0x1(%eax),%edx
  103a15:	8b 45 08             	mov    0x8(%ebp),%eax
  103a18:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  103a1d:	8b 00                	mov    (%eax),%eax
}
  103a1f:	5d                   	pop    %ebp
  103a20:	c3                   	ret    

00103a21 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  103a21:	55                   	push   %ebp
  103a22:	89 e5                	mov    %esp,%ebp
  103a24:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  103a27:	9c                   	pushf  
  103a28:	58                   	pop    %eax
  103a29:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  103a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  103a2f:	25 00 02 00 00       	and    $0x200,%eax
  103a34:	85 c0                	test   %eax,%eax
  103a36:	74 0c                	je     103a44 <__intr_save+0x23>
        intr_disable();
  103a38:	e8 6b dc ff ff       	call   1016a8 <intr_disable>
        return 1;
  103a3d:	b8 01 00 00 00       	mov    $0x1,%eax
  103a42:	eb 05                	jmp    103a49 <__intr_save+0x28>
    }
    return 0;
  103a44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103a49:	c9                   	leave  
  103a4a:	c3                   	ret    

00103a4b <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  103a4b:	55                   	push   %ebp
  103a4c:	89 e5                	mov    %esp,%ebp
  103a4e:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  103a51:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103a55:	74 05                	je     103a5c <__intr_restore+0x11>
        intr_enable();
  103a57:	e8 46 dc ff ff       	call   1016a2 <intr_enable>
    }
}
  103a5c:	c9                   	leave  
  103a5d:	c3                   	ret    

00103a5e <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  103a5e:	55                   	push   %ebp
  103a5f:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  103a61:	8b 45 08             	mov    0x8(%ebp),%eax
  103a64:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  103a67:	b8 23 00 00 00       	mov    $0x23,%eax
  103a6c:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  103a6e:	b8 23 00 00 00       	mov    $0x23,%eax
  103a73:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  103a75:	b8 10 00 00 00       	mov    $0x10,%eax
  103a7a:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  103a7c:	b8 10 00 00 00       	mov    $0x10,%eax
  103a81:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  103a83:	b8 10 00 00 00       	mov    $0x10,%eax
  103a88:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  103a8a:	ea 91 3a 10 00 08 00 	ljmp   $0x8,$0x103a91
}
  103a91:	5d                   	pop    %ebp
  103a92:	c3                   	ret    

00103a93 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  103a93:	55                   	push   %ebp
  103a94:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  103a96:	8b 45 08             	mov    0x8(%ebp),%eax
  103a99:	a3 e4 88 11 00       	mov    %eax,0x1188e4
}
  103a9e:	5d                   	pop    %ebp
  103a9f:	c3                   	ret    

00103aa0 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  103aa0:	55                   	push   %ebp
  103aa1:	89 e5                	mov    %esp,%ebp
  103aa3:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  103aa6:	b8 00 70 11 00       	mov    $0x117000,%eax
  103aab:	89 04 24             	mov    %eax,(%esp)
  103aae:	e8 e0 ff ff ff       	call   103a93 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  103ab3:	66 c7 05 e8 88 11 00 	movw   $0x10,0x1188e8
  103aba:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  103abc:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  103ac3:	68 00 
  103ac5:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103aca:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  103ad0:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103ad5:	c1 e8 10             	shr    $0x10,%eax
  103ad8:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  103add:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103ae4:	83 e0 f0             	and    $0xfffffff0,%eax
  103ae7:	83 c8 09             	or     $0x9,%eax
  103aea:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103aef:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103af6:	83 e0 ef             	and    $0xffffffef,%eax
  103af9:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103afe:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103b05:	83 e0 9f             	and    $0xffffff9f,%eax
  103b08:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103b0d:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103b14:	83 c8 80             	or     $0xffffff80,%eax
  103b17:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103b1c:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103b23:	83 e0 f0             	and    $0xfffffff0,%eax
  103b26:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103b2b:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103b32:	83 e0 ef             	and    $0xffffffef,%eax
  103b35:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103b3a:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103b41:	83 e0 df             	and    $0xffffffdf,%eax
  103b44:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103b49:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103b50:	83 c8 40             	or     $0x40,%eax
  103b53:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103b58:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103b5f:	83 e0 7f             	and    $0x7f,%eax
  103b62:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103b67:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103b6c:	c1 e8 18             	shr    $0x18,%eax
  103b6f:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  103b74:	c7 04 24 30 7a 11 00 	movl   $0x117a30,(%esp)
  103b7b:	e8 de fe ff ff       	call   103a5e <lgdt>
  103b80:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  103b86:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  103b8a:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  103b8d:	c9                   	leave  
  103b8e:	c3                   	ret    

00103b8f <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  103b8f:	55                   	push   %ebp
  103b90:	89 e5                	mov    %esp,%ebp
  103b92:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  103b95:	c7 05 5c 89 11 00 e0 	movl   $0x1068e0,0x11895c
  103b9c:	68 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  103b9f:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103ba4:	8b 00                	mov    (%eax),%eax
  103ba6:	89 44 24 04          	mov    %eax,0x4(%esp)
  103baa:	c7 04 24 7c 69 10 00 	movl   $0x10697c,(%esp)
  103bb1:	e8 86 c7 ff ff       	call   10033c <cprintf>
    pmm_manager->init();
  103bb6:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103bbb:	8b 40 04             	mov    0x4(%eax),%eax
  103bbe:	ff d0                	call   *%eax
}
  103bc0:	c9                   	leave  
  103bc1:	c3                   	ret    

00103bc2 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  103bc2:	55                   	push   %ebp
  103bc3:	89 e5                	mov    %esp,%ebp
  103bc5:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  103bc8:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103bcd:	8b 40 08             	mov    0x8(%eax),%eax
  103bd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  103bd3:	89 54 24 04          	mov    %edx,0x4(%esp)
  103bd7:	8b 55 08             	mov    0x8(%ebp),%edx
  103bda:	89 14 24             	mov    %edx,(%esp)
  103bdd:	ff d0                	call   *%eax
}
  103bdf:	c9                   	leave  
  103be0:	c3                   	ret    

00103be1 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  103be1:	55                   	push   %ebp
  103be2:	89 e5                	mov    %esp,%ebp
  103be4:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  103be7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  103bee:	e8 2e fe ff ff       	call   103a21 <__intr_save>
  103bf3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103bf6:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103bfb:	8b 40 0c             	mov    0xc(%eax),%eax
  103bfe:	8b 55 08             	mov    0x8(%ebp),%edx
  103c01:	89 14 24             	mov    %edx,(%esp)
  103c04:	ff d0                	call   *%eax
  103c06:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  103c09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c0c:	89 04 24             	mov    %eax,(%esp)
  103c0f:	e8 37 fe ff ff       	call   103a4b <__intr_restore>
    return page;
  103c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103c17:	c9                   	leave  
  103c18:	c3                   	ret    

00103c19 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103c19:	55                   	push   %ebp
  103c1a:	89 e5                	mov    %esp,%ebp
  103c1c:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  103c1f:	e8 fd fd ff ff       	call   103a21 <__intr_save>
  103c24:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  103c27:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103c2c:	8b 40 10             	mov    0x10(%eax),%eax
  103c2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  103c32:	89 54 24 04          	mov    %edx,0x4(%esp)
  103c36:	8b 55 08             	mov    0x8(%ebp),%edx
  103c39:	89 14 24             	mov    %edx,(%esp)
  103c3c:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  103c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c41:	89 04 24             	mov    %eax,(%esp)
  103c44:	e8 02 fe ff ff       	call   103a4b <__intr_restore>
}
  103c49:	c9                   	leave  
  103c4a:	c3                   	ret    

00103c4b <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  103c4b:	55                   	push   %ebp
  103c4c:	89 e5                	mov    %esp,%ebp
  103c4e:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  103c51:	e8 cb fd ff ff       	call   103a21 <__intr_save>
  103c56:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  103c59:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103c5e:	8b 40 14             	mov    0x14(%eax),%eax
  103c61:	ff d0                	call   *%eax
  103c63:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  103c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c69:	89 04 24             	mov    %eax,(%esp)
  103c6c:	e8 da fd ff ff       	call   103a4b <__intr_restore>
    return ret;
  103c71:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103c74:	c9                   	leave  
  103c75:	c3                   	ret    

00103c76 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  103c76:	55                   	push   %ebp
  103c77:	89 e5                	mov    %esp,%ebp
  103c79:	57                   	push   %edi
  103c7a:	56                   	push   %esi
  103c7b:	53                   	push   %ebx
  103c7c:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  103c82:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  103c89:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  103c90:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  103c97:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  103c9e:	e8 99 c6 ff ff       	call   10033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103ca3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103caa:	e9 15 01 00 00       	jmp    103dc4 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103caf:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103cb2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103cb5:	89 d0                	mov    %edx,%eax
  103cb7:	c1 e0 02             	shl    $0x2,%eax
  103cba:	01 d0                	add    %edx,%eax
  103cbc:	c1 e0 02             	shl    $0x2,%eax
  103cbf:	01 c8                	add    %ecx,%eax
  103cc1:	8b 50 08             	mov    0x8(%eax),%edx
  103cc4:	8b 40 04             	mov    0x4(%eax),%eax
  103cc7:	89 45 b8             	mov    %eax,-0x48(%ebp)
  103cca:	89 55 bc             	mov    %edx,-0x44(%ebp)
  103ccd:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103cd0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103cd3:	89 d0                	mov    %edx,%eax
  103cd5:	c1 e0 02             	shl    $0x2,%eax
  103cd8:	01 d0                	add    %edx,%eax
  103cda:	c1 e0 02             	shl    $0x2,%eax
  103cdd:	01 c8                	add    %ecx,%eax
  103cdf:	8b 48 0c             	mov    0xc(%eax),%ecx
  103ce2:	8b 58 10             	mov    0x10(%eax),%ebx
  103ce5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103ce8:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103ceb:	01 c8                	add    %ecx,%eax
  103ced:	11 da                	adc    %ebx,%edx
  103cef:	89 45 b0             	mov    %eax,-0x50(%ebp)
  103cf2:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  103cf5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103cf8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103cfb:	89 d0                	mov    %edx,%eax
  103cfd:	c1 e0 02             	shl    $0x2,%eax
  103d00:	01 d0                	add    %edx,%eax
  103d02:	c1 e0 02             	shl    $0x2,%eax
  103d05:	01 c8                	add    %ecx,%eax
  103d07:	83 c0 14             	add    $0x14,%eax
  103d0a:	8b 00                	mov    (%eax),%eax
  103d0c:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  103d12:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103d15:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103d18:	83 c0 ff             	add    $0xffffffff,%eax
  103d1b:	83 d2 ff             	adc    $0xffffffff,%edx
  103d1e:	89 c6                	mov    %eax,%esi
  103d20:	89 d7                	mov    %edx,%edi
  103d22:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103d25:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103d28:	89 d0                	mov    %edx,%eax
  103d2a:	c1 e0 02             	shl    $0x2,%eax
  103d2d:	01 d0                	add    %edx,%eax
  103d2f:	c1 e0 02             	shl    $0x2,%eax
  103d32:	01 c8                	add    %ecx,%eax
  103d34:	8b 48 0c             	mov    0xc(%eax),%ecx
  103d37:	8b 58 10             	mov    0x10(%eax),%ebx
  103d3a:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  103d40:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  103d44:	89 74 24 14          	mov    %esi,0x14(%esp)
  103d48:	89 7c 24 18          	mov    %edi,0x18(%esp)
  103d4c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103d4f:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103d52:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103d56:	89 54 24 10          	mov    %edx,0x10(%esp)
  103d5a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  103d5e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  103d62:	c7 04 24 a0 69 10 00 	movl   $0x1069a0,(%esp)
  103d69:	e8 ce c5 ff ff       	call   10033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  103d6e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103d71:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103d74:	89 d0                	mov    %edx,%eax
  103d76:	c1 e0 02             	shl    $0x2,%eax
  103d79:	01 d0                	add    %edx,%eax
  103d7b:	c1 e0 02             	shl    $0x2,%eax
  103d7e:	01 c8                	add    %ecx,%eax
  103d80:	83 c0 14             	add    $0x14,%eax
  103d83:	8b 00                	mov    (%eax),%eax
  103d85:	83 f8 01             	cmp    $0x1,%eax
  103d88:	75 36                	jne    103dc0 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
  103d8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103d8d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103d90:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103d93:	77 2b                	ja     103dc0 <page_init+0x14a>
  103d95:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103d98:	72 05                	jb     103d9f <page_init+0x129>
  103d9a:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  103d9d:	73 21                	jae    103dc0 <page_init+0x14a>
  103d9f:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103da3:	77 1b                	ja     103dc0 <page_init+0x14a>
  103da5:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103da9:	72 09                	jb     103db4 <page_init+0x13e>
  103dab:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  103db2:	77 0c                	ja     103dc0 <page_init+0x14a>
                maxpa = end;
  103db4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103db7:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103dba:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103dbd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103dc0:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103dc4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103dc7:	8b 00                	mov    (%eax),%eax
  103dc9:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103dcc:	0f 8f dd fe ff ff    	jg     103caf <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  103dd2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103dd6:	72 1d                	jb     103df5 <page_init+0x17f>
  103dd8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103ddc:	77 09                	ja     103de7 <page_init+0x171>
  103dde:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  103de5:	76 0e                	jbe    103df5 <page_init+0x17f>
        maxpa = KMEMSIZE;
  103de7:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  103dee:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  103df5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103df8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103dfb:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  103dff:	c1 ea 0c             	shr    $0xc,%edx
  103e02:	a3 c0 88 11 00       	mov    %eax,0x1188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  103e07:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  103e0e:	b8 68 89 11 00       	mov    $0x118968,%eax
  103e13:	8d 50 ff             	lea    -0x1(%eax),%edx
  103e16:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103e19:	01 d0                	add    %edx,%eax
  103e1b:	89 45 a8             	mov    %eax,-0x58(%ebp)
  103e1e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103e21:	ba 00 00 00 00       	mov    $0x0,%edx
  103e26:	f7 75 ac             	divl   -0x54(%ebp)
  103e29:	89 d0                	mov    %edx,%eax
  103e2b:	8b 55 a8             	mov    -0x58(%ebp),%edx
  103e2e:	29 c2                	sub    %eax,%edx
  103e30:	89 d0                	mov    %edx,%eax
  103e32:	a3 64 89 11 00       	mov    %eax,0x118964

    for (i = 0; i < npage; i ++) {
  103e37:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103e3e:	eb 2f                	jmp    103e6f <page_init+0x1f9>
        SetPageReserved(pages + i);
  103e40:	8b 0d 64 89 11 00    	mov    0x118964,%ecx
  103e46:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e49:	89 d0                	mov    %edx,%eax
  103e4b:	c1 e0 02             	shl    $0x2,%eax
  103e4e:	01 d0                	add    %edx,%eax
  103e50:	c1 e0 02             	shl    $0x2,%eax
  103e53:	01 c8                	add    %ecx,%eax
  103e55:	83 c0 04             	add    $0x4,%eax
  103e58:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  103e5f:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  103e62:	8b 45 8c             	mov    -0x74(%ebp),%eax
  103e65:	8b 55 90             	mov    -0x70(%ebp),%edx
  103e68:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
  103e6b:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103e6f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e72:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103e77:	39 c2                	cmp    %eax,%edx
  103e79:	72 c5                	jb     103e40 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  103e7b:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  103e81:	89 d0                	mov    %edx,%eax
  103e83:	c1 e0 02             	shl    $0x2,%eax
  103e86:	01 d0                	add    %edx,%eax
  103e88:	c1 e0 02             	shl    $0x2,%eax
  103e8b:	89 c2                	mov    %eax,%edx
  103e8d:	a1 64 89 11 00       	mov    0x118964,%eax
  103e92:	01 d0                	add    %edx,%eax
  103e94:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  103e97:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  103e9e:	77 23                	ja     103ec3 <page_init+0x24d>
  103ea0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  103ea3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103ea7:	c7 44 24 08 d0 69 10 	movl   $0x1069d0,0x8(%esp)
  103eae:	00 
  103eaf:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  103eb6:	00 
  103eb7:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  103ebe:	e8 02 ce ff ff       	call   100cc5 <__panic>
  103ec3:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  103ec6:	05 00 00 00 40       	add    $0x40000000,%eax
  103ecb:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  103ece:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103ed5:	e9 74 01 00 00       	jmp    10404e <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103eda:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103edd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103ee0:	89 d0                	mov    %edx,%eax
  103ee2:	c1 e0 02             	shl    $0x2,%eax
  103ee5:	01 d0                	add    %edx,%eax
  103ee7:	c1 e0 02             	shl    $0x2,%eax
  103eea:	01 c8                	add    %ecx,%eax
  103eec:	8b 50 08             	mov    0x8(%eax),%edx
  103eef:	8b 40 04             	mov    0x4(%eax),%eax
  103ef2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103ef5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103ef8:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103efb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103efe:	89 d0                	mov    %edx,%eax
  103f00:	c1 e0 02             	shl    $0x2,%eax
  103f03:	01 d0                	add    %edx,%eax
  103f05:	c1 e0 02             	shl    $0x2,%eax
  103f08:	01 c8                	add    %ecx,%eax
  103f0a:	8b 48 0c             	mov    0xc(%eax),%ecx
  103f0d:	8b 58 10             	mov    0x10(%eax),%ebx
  103f10:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103f13:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103f16:	01 c8                	add    %ecx,%eax
  103f18:	11 da                	adc    %ebx,%edx
  103f1a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  103f1d:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  103f20:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103f23:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f26:	89 d0                	mov    %edx,%eax
  103f28:	c1 e0 02             	shl    $0x2,%eax
  103f2b:	01 d0                	add    %edx,%eax
  103f2d:	c1 e0 02             	shl    $0x2,%eax
  103f30:	01 c8                	add    %ecx,%eax
  103f32:	83 c0 14             	add    $0x14,%eax
  103f35:	8b 00                	mov    (%eax),%eax
  103f37:	83 f8 01             	cmp    $0x1,%eax
  103f3a:	0f 85 0a 01 00 00    	jne    10404a <page_init+0x3d4>
            if (begin < freemem) {
  103f40:	8b 45 a0             	mov    -0x60(%ebp),%eax
  103f43:	ba 00 00 00 00       	mov    $0x0,%edx
  103f48:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  103f4b:	72 17                	jb     103f64 <page_init+0x2ee>
  103f4d:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  103f50:	77 05                	ja     103f57 <page_init+0x2e1>
  103f52:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  103f55:	76 0d                	jbe    103f64 <page_init+0x2ee>
                begin = freemem;
  103f57:	8b 45 a0             	mov    -0x60(%ebp),%eax
  103f5a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103f5d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  103f64:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  103f68:	72 1d                	jb     103f87 <page_init+0x311>
  103f6a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  103f6e:	77 09                	ja     103f79 <page_init+0x303>
  103f70:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  103f77:	76 0e                	jbe    103f87 <page_init+0x311>
                end = KMEMSIZE;
  103f79:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  103f80:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  103f87:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103f8a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103f8d:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  103f90:	0f 87 b4 00 00 00    	ja     10404a <page_init+0x3d4>
  103f96:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  103f99:	72 09                	jb     103fa4 <page_init+0x32e>
  103f9b:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  103f9e:	0f 83 a6 00 00 00    	jae    10404a <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
  103fa4:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  103fab:	8b 55 d0             	mov    -0x30(%ebp),%edx
  103fae:	8b 45 9c             	mov    -0x64(%ebp),%eax
  103fb1:	01 d0                	add    %edx,%eax
  103fb3:	83 e8 01             	sub    $0x1,%eax
  103fb6:	89 45 98             	mov    %eax,-0x68(%ebp)
  103fb9:	8b 45 98             	mov    -0x68(%ebp),%eax
  103fbc:	ba 00 00 00 00       	mov    $0x0,%edx
  103fc1:	f7 75 9c             	divl   -0x64(%ebp)
  103fc4:	89 d0                	mov    %edx,%eax
  103fc6:	8b 55 98             	mov    -0x68(%ebp),%edx
  103fc9:	29 c2                	sub    %eax,%edx
  103fcb:	89 d0                	mov    %edx,%eax
  103fcd:	ba 00 00 00 00       	mov    $0x0,%edx
  103fd2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103fd5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  103fd8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  103fdb:	89 45 94             	mov    %eax,-0x6c(%ebp)
  103fde:	8b 45 94             	mov    -0x6c(%ebp),%eax
  103fe1:	ba 00 00 00 00       	mov    $0x0,%edx
  103fe6:	89 c7                	mov    %eax,%edi
  103fe8:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  103fee:	89 7d 80             	mov    %edi,-0x80(%ebp)
  103ff1:	89 d0                	mov    %edx,%eax
  103ff3:	83 e0 00             	and    $0x0,%eax
  103ff6:	89 45 84             	mov    %eax,-0x7c(%ebp)
  103ff9:	8b 45 80             	mov    -0x80(%ebp),%eax
  103ffc:	8b 55 84             	mov    -0x7c(%ebp),%edx
  103fff:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104002:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  104005:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104008:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10400b:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10400e:	77 3a                	ja     10404a <page_init+0x3d4>
  104010:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104013:	72 05                	jb     10401a <page_init+0x3a4>
  104015:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  104018:	73 30                	jae    10404a <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  10401a:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  10401d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  104020:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104023:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104026:	29 c8                	sub    %ecx,%eax
  104028:	19 da                	sbb    %ebx,%edx
  10402a:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  10402e:	c1 ea 0c             	shr    $0xc,%edx
  104031:	89 c3                	mov    %eax,%ebx
  104033:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104036:	89 04 24             	mov    %eax,(%esp)
  104039:	e8 bd f8 ff ff       	call   1038fb <pa2page>
  10403e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104042:	89 04 24             	mov    %eax,(%esp)
  104045:	e8 78 fb ff ff       	call   103bc2 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
  10404a:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  10404e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104051:	8b 00                	mov    (%eax),%eax
  104053:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  104056:	0f 8f 7e fe ff ff    	jg     103eda <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  10405c:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  104062:	5b                   	pop    %ebx
  104063:	5e                   	pop    %esi
  104064:	5f                   	pop    %edi
  104065:	5d                   	pop    %ebp
  104066:	c3                   	ret    

00104067 <enable_paging>:

static void
enable_paging(void) {
  104067:	55                   	push   %ebp
  104068:	89 e5                	mov    %esp,%ebp
  10406a:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
  10406d:	a1 60 89 11 00       	mov    0x118960,%eax
  104072:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
  104075:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104078:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
  10407b:	0f 20 c0             	mov    %cr0,%eax
  10407e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
  104081:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
  104084:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
  104087:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
  10408e:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
  104092:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104095:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
  104098:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10409b:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
  10409e:	c9                   	leave  
  10409f:	c3                   	ret    

001040a0 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  1040a0:	55                   	push   %ebp
  1040a1:	89 e5                	mov    %esp,%ebp
  1040a3:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  1040a6:	8b 45 14             	mov    0x14(%ebp),%eax
  1040a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  1040ac:	31 d0                	xor    %edx,%eax
  1040ae:	25 ff 0f 00 00       	and    $0xfff,%eax
  1040b3:	85 c0                	test   %eax,%eax
  1040b5:	74 24                	je     1040db <boot_map_segment+0x3b>
  1040b7:	c7 44 24 0c 02 6a 10 	movl   $0x106a02,0xc(%esp)
  1040be:	00 
  1040bf:	c7 44 24 08 19 6a 10 	movl   $0x106a19,0x8(%esp)
  1040c6:	00 
  1040c7:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  1040ce:	00 
  1040cf:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  1040d6:	e8 ea cb ff ff       	call   100cc5 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  1040db:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  1040e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1040e5:	25 ff 0f 00 00       	and    $0xfff,%eax
  1040ea:	89 c2                	mov    %eax,%edx
  1040ec:	8b 45 10             	mov    0x10(%ebp),%eax
  1040ef:	01 c2                	add    %eax,%edx
  1040f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1040f4:	01 d0                	add    %edx,%eax
  1040f6:	83 e8 01             	sub    $0x1,%eax
  1040f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1040fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1040ff:	ba 00 00 00 00       	mov    $0x0,%edx
  104104:	f7 75 f0             	divl   -0x10(%ebp)
  104107:	89 d0                	mov    %edx,%eax
  104109:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10410c:	29 c2                	sub    %eax,%edx
  10410e:	89 d0                	mov    %edx,%eax
  104110:	c1 e8 0c             	shr    $0xc,%eax
  104113:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  104116:	8b 45 0c             	mov    0xc(%ebp),%eax
  104119:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10411c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10411f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104124:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  104127:	8b 45 14             	mov    0x14(%ebp),%eax
  10412a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10412d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104130:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104135:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  104138:	eb 6b                	jmp    1041a5 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
  10413a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  104141:	00 
  104142:	8b 45 0c             	mov    0xc(%ebp),%eax
  104145:	89 44 24 04          	mov    %eax,0x4(%esp)
  104149:	8b 45 08             	mov    0x8(%ebp),%eax
  10414c:	89 04 24             	mov    %eax,(%esp)
  10414f:	e8 cc 01 00 00       	call   104320 <get_pte>
  104154:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  104157:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  10415b:	75 24                	jne    104181 <boot_map_segment+0xe1>
  10415d:	c7 44 24 0c 2e 6a 10 	movl   $0x106a2e,0xc(%esp)
  104164:	00 
  104165:	c7 44 24 08 19 6a 10 	movl   $0x106a19,0x8(%esp)
  10416c:	00 
  10416d:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  104174:	00 
  104175:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  10417c:	e8 44 cb ff ff       	call   100cc5 <__panic>
        *ptep = pa | PTE_P | perm;
  104181:	8b 45 18             	mov    0x18(%ebp),%eax
  104184:	8b 55 14             	mov    0x14(%ebp),%edx
  104187:	09 d0                	or     %edx,%eax
  104189:	83 c8 01             	or     $0x1,%eax
  10418c:	89 c2                	mov    %eax,%edx
  10418e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104191:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  104193:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  104197:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  10419e:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  1041a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1041a9:	75 8f                	jne    10413a <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  1041ab:	c9                   	leave  
  1041ac:	c3                   	ret    

001041ad <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  1041ad:	55                   	push   %ebp
  1041ae:	89 e5                	mov    %esp,%ebp
  1041b0:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  1041b3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1041ba:	e8 22 fa ff ff       	call   103be1 <alloc_pages>
  1041bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  1041c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1041c6:	75 1c                	jne    1041e4 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  1041c8:	c7 44 24 08 3b 6a 10 	movl   $0x106a3b,0x8(%esp)
  1041cf:	00 
  1041d0:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  1041d7:	00 
  1041d8:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  1041df:	e8 e1 ca ff ff       	call   100cc5 <__panic>
    }
    return page2kva(p);
  1041e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1041e7:	89 04 24             	mov    %eax,(%esp)
  1041ea:	e8 5b f7 ff ff       	call   10394a <page2kva>
}
  1041ef:	c9                   	leave  
  1041f0:	c3                   	ret    

001041f1 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  1041f1:	55                   	push   %ebp
  1041f2:	89 e5                	mov    %esp,%ebp
  1041f4:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  1041f7:	e8 93 f9 ff ff       	call   103b8f <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  1041fc:	e8 75 fa ff ff       	call   103c76 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  104201:	e8 79 04 00 00       	call   10467f <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
  104206:	e8 a2 ff ff ff       	call   1041ad <boot_alloc_page>
  10420b:	a3 c4 88 11 00       	mov    %eax,0x1188c4
    memset(boot_pgdir, 0, PGSIZE);
  104210:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104215:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  10421c:	00 
  10421d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104224:	00 
  104225:	89 04 24             	mov    %eax,(%esp)
  104228:	e8 bb 1a 00 00       	call   105ce8 <memset>
    boot_cr3 = PADDR(boot_pgdir);
  10422d:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104232:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104235:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  10423c:	77 23                	ja     104261 <pmm_init+0x70>
  10423e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104241:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104245:	c7 44 24 08 d0 69 10 	movl   $0x1069d0,0x8(%esp)
  10424c:	00 
  10424d:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
  104254:	00 
  104255:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  10425c:	e8 64 ca ff ff       	call   100cc5 <__panic>
  104261:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104264:	05 00 00 00 40       	add    $0x40000000,%eax
  104269:	a3 60 89 11 00       	mov    %eax,0x118960

    check_pgdir();
  10426e:	e8 2a 04 00 00       	call   10469d <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  104273:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104278:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  10427e:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104283:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104286:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  10428d:	77 23                	ja     1042b2 <pmm_init+0xc1>
  10428f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104292:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104296:	c7 44 24 08 d0 69 10 	movl   $0x1069d0,0x8(%esp)
  10429d:	00 
  10429e:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
  1042a5:	00 
  1042a6:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  1042ad:	e8 13 ca ff ff       	call   100cc5 <__panic>
  1042b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1042b5:	05 00 00 00 40       	add    $0x40000000,%eax
  1042ba:	83 c8 03             	or     $0x3,%eax
  1042bd:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  1042bf:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1042c4:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  1042cb:	00 
  1042cc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1042d3:	00 
  1042d4:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  1042db:	38 
  1042dc:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  1042e3:	c0 
  1042e4:	89 04 24             	mov    %eax,(%esp)
  1042e7:	e8 b4 fd ff ff       	call   1040a0 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
  1042ec:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1042f1:	8b 15 c4 88 11 00    	mov    0x1188c4,%edx
  1042f7:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
  1042fd:	89 10                	mov    %edx,(%eax)

    enable_paging();
  1042ff:	e8 63 fd ff ff       	call   104067 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  104304:	e8 97 f7 ff ff       	call   103aa0 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
  104309:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10430e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  104314:	e8 1f 0a 00 00       	call   104d38 <check_boot_pgdir>

    print_pgdir();
  104319:	e8 ac 0e 00 00       	call   1051ca <print_pgdir>

}
  10431e:	c9                   	leave  
  10431f:	c3                   	ret    

00104320 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  104320:	55                   	push   %ebp
  104321:	89 e5                	mov    %esp,%ebp
  104323:	83 ec 38             	sub    $0x38,%esp
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif

pde_t *pdep = &pgdir[PDX(la)];
  104326:	8b 45 0c             	mov    0xc(%ebp),%eax
  104329:	c1 e8 16             	shr    $0x16,%eax
  10432c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104333:	8b 45 08             	mov    0x8(%ebp),%eax
  104336:	01 d0                	add    %edx,%eax
  104338:	89 45 f4             	mov    %eax,-0xc(%ebp)
if(!(*pdep & PTE_P))
  10433b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10433e:	8b 00                	mov    (%eax),%eax
  104340:	83 e0 01             	and    $0x1,%eax
  104343:	85 c0                	test   %eax,%eax
  104345:	0f 85 bd 00 00 00    	jne    104408 <get_pte+0xe8>
{
    struct Page* p;
    if(create){
  10434b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10434f:	0f 84 ac 00 00 00    	je     104401 <get_pte+0xe1>
    	p = alloc_page();
  104355:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10435c:	e8 80 f8 ff ff       	call   103be1 <alloc_pages>
  104361:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(p != NULL)
  104364:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104368:	0f 84 8c 00 00 00    	je     1043fa <get_pte+0xda>
	{
	    set_page_ref(p,1);
  10436e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104375:	00 
  104376:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104379:	89 04 24             	mov    %eax,(%esp)
  10437c:	e8 65 f6 ff ff       	call   1039e6 <set_page_ref>
	    uintptr_t pa = page2pa(p);
  104381:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104384:	89 04 24             	mov    %eax,(%esp)
  104387:	e8 59 f5 ff ff       	call   1038e5 <page2pa>
  10438c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    memset(KADDR(pa),0,PGSIZE);
  10438f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104392:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104395:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104398:	c1 e8 0c             	shr    $0xc,%eax
  10439b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10439e:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1043a3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1043a6:	72 23                	jb     1043cb <get_pte+0xab>
  1043a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1043ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1043af:	c7 44 24 08 2c 69 10 	movl   $0x10692c,0x8(%esp)
  1043b6:	00 
  1043b7:	c7 44 24 04 8a 01 00 	movl   $0x18a,0x4(%esp)
  1043be:	00 
  1043bf:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  1043c6:	e8 fa c8 ff ff       	call   100cc5 <__panic>
  1043cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1043ce:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1043d3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1043da:	00 
  1043db:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1043e2:	00 
  1043e3:	89 04 24             	mov    %eax,(%esp)
  1043e6:	e8 fd 18 00 00       	call   105ce8 <memset>
	    *pdep = pa | PTE_P | PTE_W | PTE_U; //why?
  1043eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1043ee:	83 c8 07             	or     $0x7,%eax
  1043f1:	89 c2                	mov    %eax,%edx
  1043f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1043f6:	89 10                	mov    %edx,(%eax)
  1043f8:	eb 0e                	jmp    104408 <get_pte+0xe8>
	}
	else return NULL;
  1043fa:	b8 00 00 00 00       	mov    $0x0,%eax
  1043ff:	eb 63                	jmp    104464 <get_pte+0x144>
    }
    else return NULL;
  104401:	b8 00 00 00 00       	mov    $0x0,%eax
  104406:	eb 5c                	jmp    104464 <get_pte+0x144>
  }
  return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
  104408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10440b:	8b 00                	mov    (%eax),%eax
  10440d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104412:	89 45 e0             	mov    %eax,-0x20(%ebp)
  104415:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104418:	c1 e8 0c             	shr    $0xc,%eax
  10441b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10441e:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104423:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  104426:	72 23                	jb     10444b <get_pte+0x12b>
  104428:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10442b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10442f:	c7 44 24 08 2c 69 10 	movl   $0x10692c,0x8(%esp)
  104436:	00 
  104437:	c7 44 24 04 91 01 00 	movl   $0x191,0x4(%esp)
  10443e:	00 
  10443f:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  104446:	e8 7a c8 ff ff       	call   100cc5 <__panic>
  10444b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10444e:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104453:	8b 55 0c             	mov    0xc(%ebp),%edx
  104456:	c1 ea 0c             	shr    $0xc,%edx
  104459:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  10445f:	c1 e2 02             	shl    $0x2,%edx
  104462:	01 d0                	add    %edx,%eax
}
  104464:	c9                   	leave  
  104465:	c3                   	ret    

00104466 <get_page>:


//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  104466:	55                   	push   %ebp
  104467:	89 e5                	mov    %esp,%ebp
  104469:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  10446c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104473:	00 
  104474:	8b 45 0c             	mov    0xc(%ebp),%eax
  104477:	89 44 24 04          	mov    %eax,0x4(%esp)
  10447b:	8b 45 08             	mov    0x8(%ebp),%eax
  10447e:	89 04 24             	mov    %eax,(%esp)
  104481:	e8 9a fe ff ff       	call   104320 <get_pte>
  104486:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  104489:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10448d:	74 08                	je     104497 <get_page+0x31>
        *ptep_store = ptep;
  10448f:	8b 45 10             	mov    0x10(%ebp),%eax
  104492:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104495:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  104497:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10449b:	74 1b                	je     1044b8 <get_page+0x52>
  10449d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044a0:	8b 00                	mov    (%eax),%eax
  1044a2:	83 e0 01             	and    $0x1,%eax
  1044a5:	85 c0                	test   %eax,%eax
  1044a7:	74 0f                	je     1044b8 <get_page+0x52>
        return pa2page(*ptep);
  1044a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044ac:	8b 00                	mov    (%eax),%eax
  1044ae:	89 04 24             	mov    %eax,(%esp)
  1044b1:	e8 45 f4 ff ff       	call   1038fb <pa2page>
  1044b6:	eb 05                	jmp    1044bd <get_page+0x57>
    }
    return NULL;
  1044b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1044bd:	c9                   	leave  
  1044be:	c3                   	ret    

001044bf <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  1044bf:	55                   	push   %ebp
  1044c0:	89 e5                	mov    %esp,%ebp
  1044c2:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if(*ptep & PTE_P){
  1044c5:	8b 45 10             	mov    0x10(%ebp),%eax
  1044c8:	8b 00                	mov    (%eax),%eax
  1044ca:	83 e0 01             	and    $0x1,%eax
  1044cd:	85 c0                	test   %eax,%eax
  1044cf:	74 52                	je     104523 <page_remove_pte+0x64>
    struct Page *page = pte2page(*ptep);
  1044d1:	8b 45 10             	mov    0x10(%ebp),%eax
  1044d4:	8b 00                	mov    (%eax),%eax
  1044d6:	89 04 24             	mov    %eax,(%esp)
  1044d9:	e8 c0 f4 ff ff       	call   10399e <pte2page>
  1044de:	89 45 f4             	mov    %eax,-0xc(%ebp)
    page_ref_dec(page);
  1044e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044e4:	89 04 24             	mov    %eax,(%esp)
  1044e7:	e8 1e f5 ff ff       	call   103a0a <page_ref_dec>
    if(page->ref == 0)
  1044ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044ef:	8b 00                	mov    (%eax),%eax
  1044f1:	85 c0                	test   %eax,%eax
  1044f3:	75 13                	jne    104508 <page_remove_pte+0x49>
    {
	free_page(page);
  1044f5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1044fc:	00 
  1044fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104500:	89 04 24             	mov    %eax,(%esp)
  104503:	e8 11 f7 ff ff       	call   103c19 <free_pages>
    }
    *ptep = 0;
  104508:	8b 45 10             	mov    0x10(%ebp),%eax
  10450b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    tlb_invalidate(pgdir,la);
  104511:	8b 45 0c             	mov    0xc(%ebp),%eax
  104514:	89 44 24 04          	mov    %eax,0x4(%esp)
  104518:	8b 45 08             	mov    0x8(%ebp),%eax
  10451b:	89 04 24             	mov    %eax,(%esp)
  10451e:	e8 ff 00 00 00       	call   104622 <tlb_invalidate>
  }
}
  104523:	c9                   	leave  
  104524:	c3                   	ret    

00104525 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  104525:	55                   	push   %ebp
  104526:	89 e5                	mov    %esp,%ebp
  104528:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  10452b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104532:	00 
  104533:	8b 45 0c             	mov    0xc(%ebp),%eax
  104536:	89 44 24 04          	mov    %eax,0x4(%esp)
  10453a:	8b 45 08             	mov    0x8(%ebp),%eax
  10453d:	89 04 24             	mov    %eax,(%esp)
  104540:	e8 db fd ff ff       	call   104320 <get_pte>
  104545:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  104548:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10454c:	74 19                	je     104567 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  10454e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104551:	89 44 24 08          	mov    %eax,0x8(%esp)
  104555:	8b 45 0c             	mov    0xc(%ebp),%eax
  104558:	89 44 24 04          	mov    %eax,0x4(%esp)
  10455c:	8b 45 08             	mov    0x8(%ebp),%eax
  10455f:	89 04 24             	mov    %eax,(%esp)
  104562:	e8 58 ff ff ff       	call   1044bf <page_remove_pte>
    }
}
  104567:	c9                   	leave  
  104568:	c3                   	ret    

00104569 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  104569:	55                   	push   %ebp
  10456a:	89 e5                	mov    %esp,%ebp
  10456c:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  10456f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  104576:	00 
  104577:	8b 45 10             	mov    0x10(%ebp),%eax
  10457a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10457e:	8b 45 08             	mov    0x8(%ebp),%eax
  104581:	89 04 24             	mov    %eax,(%esp)
  104584:	e8 97 fd ff ff       	call   104320 <get_pte>
  104589:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  10458c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104590:	75 0a                	jne    10459c <page_insert+0x33>
        return -E_NO_MEM;
  104592:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  104597:	e9 84 00 00 00       	jmp    104620 <page_insert+0xb7>
    }
    page_ref_inc(page);
  10459c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10459f:	89 04 24             	mov    %eax,(%esp)
  1045a2:	e8 4c f4 ff ff       	call   1039f3 <page_ref_inc>
    if (*ptep & PTE_P) {
  1045a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045aa:	8b 00                	mov    (%eax),%eax
  1045ac:	83 e0 01             	and    $0x1,%eax
  1045af:	85 c0                	test   %eax,%eax
  1045b1:	74 3e                	je     1045f1 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  1045b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045b6:	8b 00                	mov    (%eax),%eax
  1045b8:	89 04 24             	mov    %eax,(%esp)
  1045bb:	e8 de f3 ff ff       	call   10399e <pte2page>
  1045c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  1045c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1045c6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1045c9:	75 0d                	jne    1045d8 <page_insert+0x6f>
            page_ref_dec(page);
  1045cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1045ce:	89 04 24             	mov    %eax,(%esp)
  1045d1:	e8 34 f4 ff ff       	call   103a0a <page_ref_dec>
  1045d6:	eb 19                	jmp    1045f1 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  1045d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045db:	89 44 24 08          	mov    %eax,0x8(%esp)
  1045df:	8b 45 10             	mov    0x10(%ebp),%eax
  1045e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1045e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1045e9:	89 04 24             	mov    %eax,(%esp)
  1045ec:	e8 ce fe ff ff       	call   1044bf <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  1045f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1045f4:	89 04 24             	mov    %eax,(%esp)
  1045f7:	e8 e9 f2 ff ff       	call   1038e5 <page2pa>
  1045fc:	0b 45 14             	or     0x14(%ebp),%eax
  1045ff:	83 c8 01             	or     $0x1,%eax
  104602:	89 c2                	mov    %eax,%edx
  104604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104607:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  104609:	8b 45 10             	mov    0x10(%ebp),%eax
  10460c:	89 44 24 04          	mov    %eax,0x4(%esp)
  104610:	8b 45 08             	mov    0x8(%ebp),%eax
  104613:	89 04 24             	mov    %eax,(%esp)
  104616:	e8 07 00 00 00       	call   104622 <tlb_invalidate>
    return 0;
  10461b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104620:	c9                   	leave  
  104621:	c3                   	ret    

00104622 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  104622:	55                   	push   %ebp
  104623:	89 e5                	mov    %esp,%ebp
  104625:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  104628:	0f 20 d8             	mov    %cr3,%eax
  10462b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  10462e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
  104631:	89 c2                	mov    %eax,%edx
  104633:	8b 45 08             	mov    0x8(%ebp),%eax
  104636:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104639:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  104640:	77 23                	ja     104665 <tlb_invalidate+0x43>
  104642:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104645:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104649:	c7 44 24 08 d0 69 10 	movl   $0x1069d0,0x8(%esp)
  104650:	00 
  104651:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
  104658:	00 
  104659:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  104660:	e8 60 c6 ff ff       	call   100cc5 <__panic>
  104665:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104668:	05 00 00 00 40       	add    $0x40000000,%eax
  10466d:	39 c2                	cmp    %eax,%edx
  10466f:	75 0c                	jne    10467d <tlb_invalidate+0x5b>
        invlpg((void *)la);
  104671:	8b 45 0c             	mov    0xc(%ebp),%eax
  104674:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  104677:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10467a:	0f 01 38             	invlpg (%eax)
    }
}
  10467d:	c9                   	leave  
  10467e:	c3                   	ret    

0010467f <check_alloc_page>:

static void
check_alloc_page(void) {
  10467f:	55                   	push   %ebp
  104680:	89 e5                	mov    %esp,%ebp
  104682:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  104685:	a1 5c 89 11 00       	mov    0x11895c,%eax
  10468a:	8b 40 18             	mov    0x18(%eax),%eax
  10468d:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  10468f:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104696:	e8 a1 bc ff ff       	call   10033c <cprintf>
}
  10469b:	c9                   	leave  
  10469c:	c3                   	ret    

0010469d <check_pgdir>:

static void
check_pgdir(void) {
  10469d:	55                   	push   %ebp
  10469e:	89 e5                	mov    %esp,%ebp
  1046a0:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  1046a3:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1046a8:	3d 00 80 03 00       	cmp    $0x38000,%eax
  1046ad:	76 24                	jbe    1046d3 <check_pgdir+0x36>
  1046af:	c7 44 24 0c 73 6a 10 	movl   $0x106a73,0xc(%esp)
  1046b6:	00 
  1046b7:	c7 44 24 08 19 6a 10 	movl   $0x106a19,0x8(%esp)
  1046be:	00 
  1046bf:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  1046c6:	00 
  1046c7:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  1046ce:	e8 f2 c5 ff ff       	call   100cc5 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  1046d3:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1046d8:	85 c0                	test   %eax,%eax
  1046da:	74 0e                	je     1046ea <check_pgdir+0x4d>
  1046dc:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1046e1:	25 ff 0f 00 00       	and    $0xfff,%eax
  1046e6:	85 c0                	test   %eax,%eax
  1046e8:	74 24                	je     10470e <check_pgdir+0x71>
  1046ea:	c7 44 24 0c 90 6a 10 	movl   $0x106a90,0xc(%esp)
  1046f1:	00 
  1046f2:	c7 44 24 08 19 6a 10 	movl   $0x106a19,0x8(%esp)
  1046f9:	00 
  1046fa:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
  104701:	00 
  104702:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  104709:	e8 b7 c5 ff ff       	call   100cc5 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  10470e:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104713:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10471a:	00 
  10471b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104722:	00 
  104723:	89 04 24             	mov    %eax,(%esp)
  104726:	e8 3b fd ff ff       	call   104466 <get_page>
  10472b:	85 c0                	test   %eax,%eax
  10472d:	74 24                	je     104753 <check_pgdir+0xb6>
  10472f:	c7 44 24 0c c8 6a 10 	movl   $0x106ac8,0xc(%esp)
  104736:	00 
  104737:	c7 44 24 08 19 6a 10 	movl   $0x106a19,0x8(%esp)
  10473e:	00 
  10473f:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
  104746:	00 
  104747:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  10474e:	e8 72 c5 ff ff       	call   100cc5 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  104753:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10475a:	e8 82 f4 ff ff       	call   103be1 <alloc_pages>
  10475f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  104762:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104767:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  10476e:	00 
  10476f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104776:	00 
  104777:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10477a:	89 54 24 04          	mov    %edx,0x4(%esp)
  10477e:	89 04 24             	mov    %eax,(%esp)
  104781:	e8 e3 fd ff ff       	call   104569 <page_insert>
  104786:	85 c0                	test   %eax,%eax
  104788:	74 24                	je     1047ae <check_pgdir+0x111>
  10478a:	c7 44 24 0c f0 6a 10 	movl   $0x106af0,0xc(%esp)
  104791:	00 
  104792:	c7 44 24 08 19 6a 10 	movl   $0x106a19,0x8(%esp)
  104799:	00 
  10479a:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  1047a1:	00 
  1047a2:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  1047a9:	e8 17 c5 ff ff       	call   100cc5 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  1047ae:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1047b3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1047ba:	00 
  1047bb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1047c2:	00 
  1047c3:	89 04 24             	mov    %eax,(%esp)
  1047c6:	e8 55 fb ff ff       	call   104320 <get_pte>
  1047cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1047ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1047d2:	75 24                	jne    1047f8 <check_pgdir+0x15b>
  1047d4:	c7 44 24 0c 1c 6b 10 	movl   $0x106b1c,0xc(%esp)
  1047db:	00 
  1047dc:	c7 44 24 08 19 6a 10 	movl   $0x106a19,0x8(%esp)
  1047e3:	00 
  1047e4:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
  1047eb:	00 
  1047ec:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  1047f3:	e8 cd c4 ff ff       	call   100cc5 <__panic>
    assert(pa2page(*ptep) == p1);
  1047f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1047fb:	8b 00                	mov    (%eax),%eax
  1047fd:	89 04 24             	mov    %eax,(%esp)
  104800:	e8 f6 f0 ff ff       	call   1038fb <pa2page>
  104805:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104808:	74 24                	je     10482e <check_pgdir+0x191>
  10480a:	c7 44 24 0c 49 6b 10 	movl   $0x106b49,0xc(%esp)
  104811:	00 
  104812:	c7 44 24 08 19 6a 10 	movl   $0x106a19,0x8(%esp)
  104819:	00 
  10481a:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
  104821:	00 
  104822:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  104829:	e8 97 c4 ff ff       	call   100cc5 <__panic>
    assert(page_ref(p1) == 1);
  10482e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104831:	89 04 24             	mov    %eax,(%esp)
  104834:	e8 a3 f1 ff ff       	call   1039dc <page_ref>
  104839:	83 f8 01             	cmp    $0x1,%eax
  10483c:	74 24                	je     104862 <check_pgdir+0x1c5>
  10483e:	c7 44 24 0c 5e 6b 10 	movl   $0x106b5e,0xc(%esp)
  104845:	00 
  104846:	c7 44 24 08 19 6a 10 	movl   $0x106a19,0x8(%esp)
  10484d:	00 
  10484e:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
  104855:	00 
  104856:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  10485d:	e8 63 c4 ff ff       	call   100cc5 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  104862:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104867:	8b 00                	mov    (%eax),%eax
  104869:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10486e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104871:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104874:	c1 e8 0c             	shr    $0xc,%eax
  104877:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10487a:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  10487f:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  104882:	72 23                	jb     1048a7 <check_pgdir+0x20a>
  104884:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104887:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10488b:	c7 44 24 08 2c 69 10 	movl   $0x10692c,0x8(%esp)
  104892:	00 
  104893:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
  10489a:	00 
  10489b:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  1048a2:	e8 1e c4 ff ff       	call   100cc5 <__panic>
  1048a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1048aa:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1048af:	83 c0 04             	add    $0x4,%eax
  1048b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  1048b5:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1048ba:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1048c1:	00 
  1048c2:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1048c9:	00 
  1048ca:	89 04 24             	mov    %eax,(%esp)
  1048cd:	e8 4e fa ff ff       	call   104320 <get_pte>
  1048d2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  1048d5:	74 24                	je     1048fb <check_pgdir+0x25e>
  1048d7:	c7 44 24 0c 70 6b 10 	movl   $0x106b70,0xc(%esp)
  1048de:	00 
  1048df:	c7 44 24 08 19 6a 10 	movl   $0x106a19,0x8(%esp)
  1048e6:	00 
  1048e7:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
  1048ee:	00 
  1048ef:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  1048f6:	e8 ca c3 ff ff       	call   100cc5 <__panic>

    p2 = alloc_page();
  1048fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104902:	e8 da f2 ff ff       	call   103be1 <alloc_pages>
  104907:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  10490a:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10490f:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  104916:	00 
  104917:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  10491e:	00 
  10491f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104922:	89 54 24 04          	mov    %edx,0x4(%esp)
  104926:	89 04 24             	mov    %eax,(%esp)
  104929:	e8 3b fc ff ff       	call   104569 <page_insert>
  10492e:	85 c0                	test   %eax,%eax
  104930:	74 24                	je     104956 <check_pgdir+0x2b9>
  104932:	c7 44 24 0c 98 6b 10 	movl   $0x106b98,0xc(%esp)
  104939:	00 
  10493a:	c7 44 24 08 19 6a 10 	movl   $0x106a19,0x8(%esp)
  104941:	00 
  104942:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
  104949:	00 
  10494a:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  104951:	e8 6f c3 ff ff       	call   100cc5 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104956:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10495b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104962:	00 
  104963:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  10496a:	00 
  10496b:	89 04 24             	mov    %eax,(%esp)
  10496e:	e8 ad f9 ff ff       	call   104320 <get_pte>
  104973:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104976:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10497a:	75 24                	jne    1049a0 <check_pgdir+0x303>
  10497c:	c7 44 24 0c d0 6b 10 	movl   $0x106bd0,0xc(%esp)
  104983:	00 
  104984:	c7 44 24 08 19 6a 10 	movl   $0x106a19,0x8(%esp)
  10498b:	00 
  10498c:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
  104993:	00 
  104994:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  10499b:	e8 25 c3 ff ff       	call   100cc5 <__panic>
    assert(*ptep & PTE_U);
  1049a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1049a3:	8b 00                	mov    (%eax),%eax
  1049a5:	83 e0 04             	and    $0x4,%eax
  1049a8:	85 c0                	test   %eax,%eax
  1049aa:	75 24                	jne    1049d0 <check_pgdir+0x333>
  1049ac:	c7 44 24 0c 00 6c 10 	movl   $0x106c00,0xc(%esp)
  1049b3:	00 
  1049b4:	c7 44 24 08 19 6a 10 	movl   $0x106a19,0x8(%esp)
  1049bb:	00 
  1049bc:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
  1049c3:	00 
  1049c4:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  1049cb:	e8 f5 c2 ff ff       	call   100cc5 <__panic>
    assert(*ptep & PTE_W);
  1049d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1049d3:	8b 00                	mov    (%eax),%eax
  1049d5:	83 e0 02             	and    $0x2,%eax
  1049d8:	85 c0                	test   %eax,%eax
  1049da:	75 24                	jne    104a00 <check_pgdir+0x363>
  1049dc:	c7 44 24 0c 0e 6c 10 	movl   $0x106c0e,0xc(%esp)
  1049e3:	00 
  1049e4:	c7 44 24 08 19 6a 10 	movl   $0x106a19,0x8(%esp)
  1049eb:	00 
  1049ec:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  1049f3:	00 
  1049f4:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  1049fb:	e8 c5 c2 ff ff       	call   100cc5 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  104a00:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104a05:	8b 00                	mov    (%eax),%eax
  104a07:	83 e0 04             	and    $0x4,%eax
  104a0a:	85 c0                	test   %eax,%eax
  104a0c:	75 24                	jne    104a32 <check_pgdir+0x395>
  104a0e:	c7 44 24 0c 1c 6c 10 	movl   $0x106c1c,0xc(%esp)
  104a15:	00 
  104a16:	c7 44 24 08 19 6a 10 	movl   $0x106a19,0x8(%esp)
  104a1d:	00 
  104a1e:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  104a25:	00 
  104a26:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  104a2d:	e8 93 c2 ff ff       	call   100cc5 <__panic>
    assert(page_ref(p2) == 1);
  104a32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104a35:	89 04 24             	mov    %eax,(%esp)
  104a38:	e8 9f ef ff ff       	call   1039dc <page_ref>
  104a3d:	83 f8 01             	cmp    $0x1,%eax
  104a40:	74 24                	je     104a66 <check_pgdir+0x3c9>
  104a42:	c7 44 24 0c 32 6c 10 	movl   $0x106c32,0xc(%esp)
  104a49:	00 
  104a4a:	c7 44 24 08 19 6a 10 	movl   $0x106a19,0x8(%esp)
  104a51:	00 
  104a52:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
  104a59:	00 
  104a5a:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  104a61:	e8 5f c2 ff ff       	call   100cc5 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  104a66:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104a6b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104a72:	00 
  104a73:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104a7a:	00 
  104a7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104a7e:	89 54 24 04          	mov    %edx,0x4(%esp)
  104a82:	89 04 24             	mov    %eax,(%esp)
  104a85:	e8 df fa ff ff       	call   104569 <page_insert>
  104a8a:	85 c0                	test   %eax,%eax
  104a8c:	74 24                	je     104ab2 <check_pgdir+0x415>
  104a8e:	c7 44 24 0c 44 6c 10 	movl   $0x106c44,0xc(%esp)
  104a95:	00 
  104a96:	c7 44 24 08 19 6a 10 	movl   $0x106a19,0x8(%esp)
  104a9d:	00 
  104a9e:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
  104aa5:	00 
  104aa6:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  104aad:	e8 13 c2 ff ff       	call   100cc5 <__panic>
    assert(page_ref(p1) == 2);
  104ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ab5:	89 04 24             	mov    %eax,(%esp)
  104ab8:	e8 1f ef ff ff       	call   1039dc <page_ref>
  104abd:	83 f8 02             	cmp    $0x2,%eax
  104ac0:	74 24                	je     104ae6 <check_pgdir+0x449>
  104ac2:	c7 44 24 0c 70 6c 10 	movl   $0x106c70,0xc(%esp)
  104ac9:	00 
  104aca:	c7 44 24 08 19 6a 10 	movl   $0x106a19,0x8(%esp)
  104ad1:	00 
  104ad2:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
  104ad9:	00 
  104ada:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  104ae1:	e8 df c1 ff ff       	call   100cc5 <__panic>
    assert(page_ref(p2) == 0);
  104ae6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104ae9:	89 04 24             	mov    %eax,(%esp)
  104aec:	e8 eb ee ff ff       	call   1039dc <page_ref>
  104af1:	85 c0                	test   %eax,%eax
  104af3:	74 24                	je     104b19 <check_pgdir+0x47c>
  104af5:	c7 44 24 0c 82 6c 10 	movl   $0x106c82,0xc(%esp)
  104afc:	00 
  104afd:	c7 44 24 08 19 6a 10 	movl   $0x106a19,0x8(%esp)
  104b04:	00 
  104b05:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
  104b0c:	00 
  104b0d:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  104b14:	e8 ac c1 ff ff       	call   100cc5 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104b19:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104b1e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104b25:	00 
  104b26:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104b2d:	00 
  104b2e:	89 04 24             	mov    %eax,(%esp)
  104b31:	e8 ea f7 ff ff       	call   104320 <get_pte>
  104b36:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104b39:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104b3d:	75 24                	jne    104b63 <check_pgdir+0x4c6>
  104b3f:	c7 44 24 0c d0 6b 10 	movl   $0x106bd0,0xc(%esp)
  104b46:	00 
  104b47:	c7 44 24 08 19 6a 10 	movl   $0x106a19,0x8(%esp)
  104b4e:	00 
  104b4f:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
  104b56:	00 
  104b57:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  104b5e:	e8 62 c1 ff ff       	call   100cc5 <__panic>
    assert(pa2page(*ptep) == p1);
  104b63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b66:	8b 00                	mov    (%eax),%eax
  104b68:	89 04 24             	mov    %eax,(%esp)
  104b6b:	e8 8b ed ff ff       	call   1038fb <pa2page>
  104b70:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104b73:	74 24                	je     104b99 <check_pgdir+0x4fc>
  104b75:	c7 44 24 0c 49 6b 10 	movl   $0x106b49,0xc(%esp)
  104b7c:	00 
  104b7d:	c7 44 24 08 19 6a 10 	movl   $0x106a19,0x8(%esp)
  104b84:	00 
  104b85:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
  104b8c:	00 
  104b8d:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  104b94:	e8 2c c1 ff ff       	call   100cc5 <__panic>
    assert((*ptep & PTE_U) == 0);
  104b99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b9c:	8b 00                	mov    (%eax),%eax
  104b9e:	83 e0 04             	and    $0x4,%eax
  104ba1:	85 c0                	test   %eax,%eax
  104ba3:	74 24                	je     104bc9 <check_pgdir+0x52c>
  104ba5:	c7 44 24 0c 94 6c 10 	movl   $0x106c94,0xc(%esp)
  104bac:	00 
  104bad:	c7 44 24 08 19 6a 10 	movl   $0x106a19,0x8(%esp)
  104bb4:	00 
  104bb5:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
  104bbc:	00 
  104bbd:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  104bc4:	e8 fc c0 ff ff       	call   100cc5 <__panic>

    page_remove(boot_pgdir, 0x0);
  104bc9:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104bce:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104bd5:	00 
  104bd6:	89 04 24             	mov    %eax,(%esp)
  104bd9:	e8 47 f9 ff ff       	call   104525 <page_remove>
    assert(page_ref(p1) == 1);
  104bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104be1:	89 04 24             	mov    %eax,(%esp)
  104be4:	e8 f3 ed ff ff       	call   1039dc <page_ref>
  104be9:	83 f8 01             	cmp    $0x1,%eax
  104bec:	74 24                	je     104c12 <check_pgdir+0x575>
  104bee:	c7 44 24 0c 5e 6b 10 	movl   $0x106b5e,0xc(%esp)
  104bf5:	00 
  104bf6:	c7 44 24 08 19 6a 10 	movl   $0x106a19,0x8(%esp)
  104bfd:	00 
  104bfe:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
  104c05:	00 
  104c06:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  104c0d:	e8 b3 c0 ff ff       	call   100cc5 <__panic>
    assert(page_ref(p2) == 0);
  104c12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c15:	89 04 24             	mov    %eax,(%esp)
  104c18:	e8 bf ed ff ff       	call   1039dc <page_ref>
  104c1d:	85 c0                	test   %eax,%eax
  104c1f:	74 24                	je     104c45 <check_pgdir+0x5a8>
  104c21:	c7 44 24 0c 82 6c 10 	movl   $0x106c82,0xc(%esp)
  104c28:	00 
  104c29:	c7 44 24 08 19 6a 10 	movl   $0x106a19,0x8(%esp)
  104c30:	00 
  104c31:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
  104c38:	00 
  104c39:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  104c40:	e8 80 c0 ff ff       	call   100cc5 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  104c45:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104c4a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104c51:	00 
  104c52:	89 04 24             	mov    %eax,(%esp)
  104c55:	e8 cb f8 ff ff       	call   104525 <page_remove>
    assert(page_ref(p1) == 0);
  104c5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c5d:	89 04 24             	mov    %eax,(%esp)
  104c60:	e8 77 ed ff ff       	call   1039dc <page_ref>
  104c65:	85 c0                	test   %eax,%eax
  104c67:	74 24                	je     104c8d <check_pgdir+0x5f0>
  104c69:	c7 44 24 0c a9 6c 10 	movl   $0x106ca9,0xc(%esp)
  104c70:	00 
  104c71:	c7 44 24 08 19 6a 10 	movl   $0x106a19,0x8(%esp)
  104c78:	00 
  104c79:	c7 44 24 04 27 02 00 	movl   $0x227,0x4(%esp)
  104c80:	00 
  104c81:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  104c88:	e8 38 c0 ff ff       	call   100cc5 <__panic>
    assert(page_ref(p2) == 0);
  104c8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c90:	89 04 24             	mov    %eax,(%esp)
  104c93:	e8 44 ed ff ff       	call   1039dc <page_ref>
  104c98:	85 c0                	test   %eax,%eax
  104c9a:	74 24                	je     104cc0 <check_pgdir+0x623>
  104c9c:	c7 44 24 0c 82 6c 10 	movl   $0x106c82,0xc(%esp)
  104ca3:	00 
  104ca4:	c7 44 24 08 19 6a 10 	movl   $0x106a19,0x8(%esp)
  104cab:	00 
  104cac:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
  104cb3:	00 
  104cb4:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  104cbb:	e8 05 c0 ff ff       	call   100cc5 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
  104cc0:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104cc5:	8b 00                	mov    (%eax),%eax
  104cc7:	89 04 24             	mov    %eax,(%esp)
  104cca:	e8 2c ec ff ff       	call   1038fb <pa2page>
  104ccf:	89 04 24             	mov    %eax,(%esp)
  104cd2:	e8 05 ed ff ff       	call   1039dc <page_ref>
  104cd7:	83 f8 01             	cmp    $0x1,%eax
  104cda:	74 24                	je     104d00 <check_pgdir+0x663>
  104cdc:	c7 44 24 0c bc 6c 10 	movl   $0x106cbc,0xc(%esp)
  104ce3:	00 
  104ce4:	c7 44 24 08 19 6a 10 	movl   $0x106a19,0x8(%esp)
  104ceb:	00 
  104cec:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
  104cf3:	00 
  104cf4:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  104cfb:	e8 c5 bf ff ff       	call   100cc5 <__panic>
    free_page(pa2page(boot_pgdir[0]));
  104d00:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104d05:	8b 00                	mov    (%eax),%eax
  104d07:	89 04 24             	mov    %eax,(%esp)
  104d0a:	e8 ec eb ff ff       	call   1038fb <pa2page>
  104d0f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104d16:	00 
  104d17:	89 04 24             	mov    %eax,(%esp)
  104d1a:	e8 fa ee ff ff       	call   103c19 <free_pages>
    boot_pgdir[0] = 0;
  104d1f:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104d24:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  104d2a:	c7 04 24 e2 6c 10 00 	movl   $0x106ce2,(%esp)
  104d31:	e8 06 b6 ff ff       	call   10033c <cprintf>
}
  104d36:	c9                   	leave  
  104d37:	c3                   	ret    

00104d38 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  104d38:	55                   	push   %ebp
  104d39:	89 e5                	mov    %esp,%ebp
  104d3b:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104d3e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104d45:	e9 ca 00 00 00       	jmp    104e14 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  104d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104d50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d53:	c1 e8 0c             	shr    $0xc,%eax
  104d56:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104d59:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104d5e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  104d61:	72 23                	jb     104d86 <check_boot_pgdir+0x4e>
  104d63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d66:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104d6a:	c7 44 24 08 2c 69 10 	movl   $0x10692c,0x8(%esp)
  104d71:	00 
  104d72:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
  104d79:	00 
  104d7a:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  104d81:	e8 3f bf ff ff       	call   100cc5 <__panic>
  104d86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d89:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104d8e:	89 c2                	mov    %eax,%edx
  104d90:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104d95:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104d9c:	00 
  104d9d:	89 54 24 04          	mov    %edx,0x4(%esp)
  104da1:	89 04 24             	mov    %eax,(%esp)
  104da4:	e8 77 f5 ff ff       	call   104320 <get_pte>
  104da9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104dac:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104db0:	75 24                	jne    104dd6 <check_boot_pgdir+0x9e>
  104db2:	c7 44 24 0c fc 6c 10 	movl   $0x106cfc,0xc(%esp)
  104db9:	00 
  104dba:	c7 44 24 08 19 6a 10 	movl   $0x106a19,0x8(%esp)
  104dc1:	00 
  104dc2:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
  104dc9:	00 
  104dca:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  104dd1:	e8 ef be ff ff       	call   100cc5 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  104dd6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104dd9:	8b 00                	mov    (%eax),%eax
  104ddb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104de0:	89 c2                	mov    %eax,%edx
  104de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104de5:	39 c2                	cmp    %eax,%edx
  104de7:	74 24                	je     104e0d <check_boot_pgdir+0xd5>
  104de9:	c7 44 24 0c 39 6d 10 	movl   $0x106d39,0xc(%esp)
  104df0:	00 
  104df1:	c7 44 24 08 19 6a 10 	movl   $0x106a19,0x8(%esp)
  104df8:	00 
  104df9:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
  104e00:	00 
  104e01:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  104e08:	e8 b8 be ff ff       	call   100cc5 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104e0d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  104e14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104e17:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104e1c:	39 c2                	cmp    %eax,%edx
  104e1e:	0f 82 26 ff ff ff    	jb     104d4a <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  104e24:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104e29:	05 ac 0f 00 00       	add    $0xfac,%eax
  104e2e:	8b 00                	mov    (%eax),%eax
  104e30:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104e35:	89 c2                	mov    %eax,%edx
  104e37:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104e3c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104e3f:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  104e46:	77 23                	ja     104e6b <check_boot_pgdir+0x133>
  104e48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104e4b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104e4f:	c7 44 24 08 d0 69 10 	movl   $0x1069d0,0x8(%esp)
  104e56:	00 
  104e57:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
  104e5e:	00 
  104e5f:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  104e66:	e8 5a be ff ff       	call   100cc5 <__panic>
  104e6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104e6e:	05 00 00 00 40       	add    $0x40000000,%eax
  104e73:	39 c2                	cmp    %eax,%edx
  104e75:	74 24                	je     104e9b <check_boot_pgdir+0x163>
  104e77:	c7 44 24 0c 50 6d 10 	movl   $0x106d50,0xc(%esp)
  104e7e:	00 
  104e7f:	c7 44 24 08 19 6a 10 	movl   $0x106a19,0x8(%esp)
  104e86:	00 
  104e87:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
  104e8e:	00 
  104e8f:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  104e96:	e8 2a be ff ff       	call   100cc5 <__panic>

    assert(boot_pgdir[0] == 0);
  104e9b:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104ea0:	8b 00                	mov    (%eax),%eax
  104ea2:	85 c0                	test   %eax,%eax
  104ea4:	74 24                	je     104eca <check_boot_pgdir+0x192>
  104ea6:	c7 44 24 0c 84 6d 10 	movl   $0x106d84,0xc(%esp)
  104ead:	00 
  104eae:	c7 44 24 08 19 6a 10 	movl   $0x106a19,0x8(%esp)
  104eb5:	00 
  104eb6:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
  104ebd:	00 
  104ebe:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  104ec5:	e8 fb bd ff ff       	call   100cc5 <__panic>

    struct Page *p;
    p = alloc_page();
  104eca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104ed1:	e8 0b ed ff ff       	call   103be1 <alloc_pages>
  104ed6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  104ed9:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104ede:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  104ee5:	00 
  104ee6:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  104eed:	00 
  104eee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104ef1:	89 54 24 04          	mov    %edx,0x4(%esp)
  104ef5:	89 04 24             	mov    %eax,(%esp)
  104ef8:	e8 6c f6 ff ff       	call   104569 <page_insert>
  104efd:	85 c0                	test   %eax,%eax
  104eff:	74 24                	je     104f25 <check_boot_pgdir+0x1ed>
  104f01:	c7 44 24 0c 98 6d 10 	movl   $0x106d98,0xc(%esp)
  104f08:	00 
  104f09:	c7 44 24 08 19 6a 10 	movl   $0x106a19,0x8(%esp)
  104f10:	00 
  104f11:	c7 44 24 04 40 02 00 	movl   $0x240,0x4(%esp)
  104f18:	00 
  104f19:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  104f20:	e8 a0 bd ff ff       	call   100cc5 <__panic>
    assert(page_ref(p) == 1);
  104f25:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104f28:	89 04 24             	mov    %eax,(%esp)
  104f2b:	e8 ac ea ff ff       	call   1039dc <page_ref>
  104f30:	83 f8 01             	cmp    $0x1,%eax
  104f33:	74 24                	je     104f59 <check_boot_pgdir+0x221>
  104f35:	c7 44 24 0c c6 6d 10 	movl   $0x106dc6,0xc(%esp)
  104f3c:	00 
  104f3d:	c7 44 24 08 19 6a 10 	movl   $0x106a19,0x8(%esp)
  104f44:	00 
  104f45:	c7 44 24 04 41 02 00 	movl   $0x241,0x4(%esp)
  104f4c:	00 
  104f4d:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  104f54:	e8 6c bd ff ff       	call   100cc5 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  104f59:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104f5e:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  104f65:	00 
  104f66:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  104f6d:	00 
  104f6e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104f71:	89 54 24 04          	mov    %edx,0x4(%esp)
  104f75:	89 04 24             	mov    %eax,(%esp)
  104f78:	e8 ec f5 ff ff       	call   104569 <page_insert>
  104f7d:	85 c0                	test   %eax,%eax
  104f7f:	74 24                	je     104fa5 <check_boot_pgdir+0x26d>
  104f81:	c7 44 24 0c d8 6d 10 	movl   $0x106dd8,0xc(%esp)
  104f88:	00 
  104f89:	c7 44 24 08 19 6a 10 	movl   $0x106a19,0x8(%esp)
  104f90:	00 
  104f91:	c7 44 24 04 42 02 00 	movl   $0x242,0x4(%esp)
  104f98:	00 
  104f99:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  104fa0:	e8 20 bd ff ff       	call   100cc5 <__panic>
    assert(page_ref(p) == 2);
  104fa5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104fa8:	89 04 24             	mov    %eax,(%esp)
  104fab:	e8 2c ea ff ff       	call   1039dc <page_ref>
  104fb0:	83 f8 02             	cmp    $0x2,%eax
  104fb3:	74 24                	je     104fd9 <check_boot_pgdir+0x2a1>
  104fb5:	c7 44 24 0c 0f 6e 10 	movl   $0x106e0f,0xc(%esp)
  104fbc:	00 
  104fbd:	c7 44 24 08 19 6a 10 	movl   $0x106a19,0x8(%esp)
  104fc4:	00 
  104fc5:	c7 44 24 04 43 02 00 	movl   $0x243,0x4(%esp)
  104fcc:	00 
  104fcd:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  104fd4:	e8 ec bc ff ff       	call   100cc5 <__panic>

    const char *str = "ucore: Hello world!!";
  104fd9:	c7 45 dc 20 6e 10 00 	movl   $0x106e20,-0x24(%ebp)
    strcpy((void *)0x100, str);
  104fe0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104fe3:	89 44 24 04          	mov    %eax,0x4(%esp)
  104fe7:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104fee:	e8 1e 0a 00 00       	call   105a11 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  104ff3:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  104ffa:	00 
  104ffb:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105002:	e8 83 0a 00 00       	call   105a8a <strcmp>
  105007:	85 c0                	test   %eax,%eax
  105009:	74 24                	je     10502f <check_boot_pgdir+0x2f7>
  10500b:	c7 44 24 0c 38 6e 10 	movl   $0x106e38,0xc(%esp)
  105012:	00 
  105013:	c7 44 24 08 19 6a 10 	movl   $0x106a19,0x8(%esp)
  10501a:	00 
  10501b:	c7 44 24 04 47 02 00 	movl   $0x247,0x4(%esp)
  105022:	00 
  105023:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  10502a:	e8 96 bc ff ff       	call   100cc5 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  10502f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105032:	89 04 24             	mov    %eax,(%esp)
  105035:	e8 10 e9 ff ff       	call   10394a <page2kva>
  10503a:	05 00 01 00 00       	add    $0x100,%eax
  10503f:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  105042:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105049:	e8 6b 09 00 00       	call   1059b9 <strlen>
  10504e:	85 c0                	test   %eax,%eax
  105050:	74 24                	je     105076 <check_boot_pgdir+0x33e>
  105052:	c7 44 24 0c 70 6e 10 	movl   $0x106e70,0xc(%esp)
  105059:	00 
  10505a:	c7 44 24 08 19 6a 10 	movl   $0x106a19,0x8(%esp)
  105061:	00 
  105062:	c7 44 24 04 4a 02 00 	movl   $0x24a,0x4(%esp)
  105069:	00 
  10506a:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  105071:	e8 4f bc ff ff       	call   100cc5 <__panic>

    free_page(p);
  105076:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10507d:	00 
  10507e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105081:	89 04 24             	mov    %eax,(%esp)
  105084:	e8 90 eb ff ff       	call   103c19 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
  105089:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10508e:	8b 00                	mov    (%eax),%eax
  105090:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  105095:	89 04 24             	mov    %eax,(%esp)
  105098:	e8 5e e8 ff ff       	call   1038fb <pa2page>
  10509d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1050a4:	00 
  1050a5:	89 04 24             	mov    %eax,(%esp)
  1050a8:	e8 6c eb ff ff       	call   103c19 <free_pages>
    boot_pgdir[0] = 0;
  1050ad:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1050b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  1050b8:	c7 04 24 94 6e 10 00 	movl   $0x106e94,(%esp)
  1050bf:	e8 78 b2 ff ff       	call   10033c <cprintf>
}
  1050c4:	c9                   	leave  
  1050c5:	c3                   	ret    

001050c6 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  1050c6:	55                   	push   %ebp
  1050c7:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  1050c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1050cc:	83 e0 04             	and    $0x4,%eax
  1050cf:	85 c0                	test   %eax,%eax
  1050d1:	74 07                	je     1050da <perm2str+0x14>
  1050d3:	b8 75 00 00 00       	mov    $0x75,%eax
  1050d8:	eb 05                	jmp    1050df <perm2str+0x19>
  1050da:	b8 2d 00 00 00       	mov    $0x2d,%eax
  1050df:	a2 48 89 11 00       	mov    %al,0x118948
    str[1] = 'r';
  1050e4:	c6 05 49 89 11 00 72 	movb   $0x72,0x118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
  1050eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1050ee:	83 e0 02             	and    $0x2,%eax
  1050f1:	85 c0                	test   %eax,%eax
  1050f3:	74 07                	je     1050fc <perm2str+0x36>
  1050f5:	b8 77 00 00 00       	mov    $0x77,%eax
  1050fa:	eb 05                	jmp    105101 <perm2str+0x3b>
  1050fc:	b8 2d 00 00 00       	mov    $0x2d,%eax
  105101:	a2 4a 89 11 00       	mov    %al,0x11894a
    str[3] = '\0';
  105106:	c6 05 4b 89 11 00 00 	movb   $0x0,0x11894b
    return str;
  10510d:	b8 48 89 11 00       	mov    $0x118948,%eax
}
  105112:	5d                   	pop    %ebp
  105113:	c3                   	ret    

00105114 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  105114:	55                   	push   %ebp
  105115:	89 e5                	mov    %esp,%ebp
  105117:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  10511a:	8b 45 10             	mov    0x10(%ebp),%eax
  10511d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105120:	72 0a                	jb     10512c <get_pgtable_items+0x18>
        return 0;
  105122:	b8 00 00 00 00       	mov    $0x0,%eax
  105127:	e9 9c 00 00 00       	jmp    1051c8 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
  10512c:	eb 04                	jmp    105132 <get_pgtable_items+0x1e>
        start ++;
  10512e:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  105132:	8b 45 10             	mov    0x10(%ebp),%eax
  105135:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105138:	73 18                	jae    105152 <get_pgtable_items+0x3e>
  10513a:	8b 45 10             	mov    0x10(%ebp),%eax
  10513d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105144:	8b 45 14             	mov    0x14(%ebp),%eax
  105147:	01 d0                	add    %edx,%eax
  105149:	8b 00                	mov    (%eax),%eax
  10514b:	83 e0 01             	and    $0x1,%eax
  10514e:	85 c0                	test   %eax,%eax
  105150:	74 dc                	je     10512e <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
  105152:	8b 45 10             	mov    0x10(%ebp),%eax
  105155:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105158:	73 69                	jae    1051c3 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  10515a:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  10515e:	74 08                	je     105168 <get_pgtable_items+0x54>
            *left_store = start;
  105160:	8b 45 18             	mov    0x18(%ebp),%eax
  105163:	8b 55 10             	mov    0x10(%ebp),%edx
  105166:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  105168:	8b 45 10             	mov    0x10(%ebp),%eax
  10516b:	8d 50 01             	lea    0x1(%eax),%edx
  10516e:	89 55 10             	mov    %edx,0x10(%ebp)
  105171:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105178:	8b 45 14             	mov    0x14(%ebp),%eax
  10517b:	01 d0                	add    %edx,%eax
  10517d:	8b 00                	mov    (%eax),%eax
  10517f:	83 e0 07             	and    $0x7,%eax
  105182:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  105185:	eb 04                	jmp    10518b <get_pgtable_items+0x77>
            start ++;
  105187:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  10518b:	8b 45 10             	mov    0x10(%ebp),%eax
  10518e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105191:	73 1d                	jae    1051b0 <get_pgtable_items+0x9c>
  105193:	8b 45 10             	mov    0x10(%ebp),%eax
  105196:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10519d:	8b 45 14             	mov    0x14(%ebp),%eax
  1051a0:	01 d0                	add    %edx,%eax
  1051a2:	8b 00                	mov    (%eax),%eax
  1051a4:	83 e0 07             	and    $0x7,%eax
  1051a7:	89 c2                	mov    %eax,%edx
  1051a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1051ac:	39 c2                	cmp    %eax,%edx
  1051ae:	74 d7                	je     105187 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
  1051b0:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1051b4:	74 08                	je     1051be <get_pgtable_items+0xaa>
            *right_store = start;
  1051b6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1051b9:	8b 55 10             	mov    0x10(%ebp),%edx
  1051bc:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  1051be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1051c1:	eb 05                	jmp    1051c8 <get_pgtable_items+0xb4>
    }
    return 0;
  1051c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1051c8:	c9                   	leave  
  1051c9:	c3                   	ret    

001051ca <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  1051ca:	55                   	push   %ebp
  1051cb:	89 e5                	mov    %esp,%ebp
  1051cd:	57                   	push   %edi
  1051ce:	56                   	push   %esi
  1051cf:	53                   	push   %ebx
  1051d0:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  1051d3:	c7 04 24 b4 6e 10 00 	movl   $0x106eb4,(%esp)
  1051da:	e8 5d b1 ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
  1051df:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1051e6:	e9 fa 00 00 00       	jmp    1052e5 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1051eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1051ee:	89 04 24             	mov    %eax,(%esp)
  1051f1:	e8 d0 fe ff ff       	call   1050c6 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  1051f6:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1051f9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1051fc:	29 d1                	sub    %edx,%ecx
  1051fe:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  105200:	89 d6                	mov    %edx,%esi
  105202:	c1 e6 16             	shl    $0x16,%esi
  105205:	8b 55 dc             	mov    -0x24(%ebp),%edx
  105208:	89 d3                	mov    %edx,%ebx
  10520a:	c1 e3 16             	shl    $0x16,%ebx
  10520d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105210:	89 d1                	mov    %edx,%ecx
  105212:	c1 e1 16             	shl    $0x16,%ecx
  105215:	8b 7d dc             	mov    -0x24(%ebp),%edi
  105218:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10521b:	29 d7                	sub    %edx,%edi
  10521d:	89 fa                	mov    %edi,%edx
  10521f:	89 44 24 14          	mov    %eax,0x14(%esp)
  105223:	89 74 24 10          	mov    %esi,0x10(%esp)
  105227:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10522b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  10522f:	89 54 24 04          	mov    %edx,0x4(%esp)
  105233:	c7 04 24 e5 6e 10 00 	movl   $0x106ee5,(%esp)
  10523a:	e8 fd b0 ff ff       	call   10033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  10523f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105242:	c1 e0 0a             	shl    $0xa,%eax
  105245:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  105248:	eb 54                	jmp    10529e <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  10524a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10524d:	89 04 24             	mov    %eax,(%esp)
  105250:	e8 71 fe ff ff       	call   1050c6 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  105255:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  105258:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10525b:	29 d1                	sub    %edx,%ecx
  10525d:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  10525f:	89 d6                	mov    %edx,%esi
  105261:	c1 e6 0c             	shl    $0xc,%esi
  105264:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105267:	89 d3                	mov    %edx,%ebx
  105269:	c1 e3 0c             	shl    $0xc,%ebx
  10526c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10526f:	c1 e2 0c             	shl    $0xc,%edx
  105272:	89 d1                	mov    %edx,%ecx
  105274:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  105277:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10527a:	29 d7                	sub    %edx,%edi
  10527c:	89 fa                	mov    %edi,%edx
  10527e:	89 44 24 14          	mov    %eax,0x14(%esp)
  105282:	89 74 24 10          	mov    %esi,0x10(%esp)
  105286:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10528a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  10528e:	89 54 24 04          	mov    %edx,0x4(%esp)
  105292:	c7 04 24 04 6f 10 00 	movl   $0x106f04,(%esp)
  105299:	e8 9e b0 ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  10529e:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
  1052a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1052a6:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1052a9:	89 ce                	mov    %ecx,%esi
  1052ab:	c1 e6 0a             	shl    $0xa,%esi
  1052ae:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  1052b1:	89 cb                	mov    %ecx,%ebx
  1052b3:	c1 e3 0a             	shl    $0xa,%ebx
  1052b6:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
  1052b9:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  1052bd:	8d 4d d8             	lea    -0x28(%ebp),%ecx
  1052c0:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  1052c4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1052c8:	89 44 24 08          	mov    %eax,0x8(%esp)
  1052cc:	89 74 24 04          	mov    %esi,0x4(%esp)
  1052d0:	89 1c 24             	mov    %ebx,(%esp)
  1052d3:	e8 3c fe ff ff       	call   105114 <get_pgtable_items>
  1052d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1052db:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1052df:	0f 85 65 ff ff ff    	jne    10524a <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1052e5:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
  1052ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1052ed:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  1052f0:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  1052f4:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  1052f7:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  1052fb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1052ff:	89 44 24 08          	mov    %eax,0x8(%esp)
  105303:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  10530a:	00 
  10530b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105312:	e8 fd fd ff ff       	call   105114 <get_pgtable_items>
  105317:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10531a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10531e:	0f 85 c7 fe ff ff    	jne    1051eb <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  105324:	c7 04 24 28 6f 10 00 	movl   $0x106f28,(%esp)
  10532b:	e8 0c b0 ff ff       	call   10033c <cprintf>
}
  105330:	83 c4 4c             	add    $0x4c,%esp
  105333:	5b                   	pop    %ebx
  105334:	5e                   	pop    %esi
  105335:	5f                   	pop    %edi
  105336:	5d                   	pop    %ebp
  105337:	c3                   	ret    

00105338 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  105338:	55                   	push   %ebp
  105339:	89 e5                	mov    %esp,%ebp
  10533b:	83 ec 58             	sub    $0x58,%esp
  10533e:	8b 45 10             	mov    0x10(%ebp),%eax
  105341:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105344:	8b 45 14             	mov    0x14(%ebp),%eax
  105347:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  10534a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10534d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105350:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105353:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  105356:	8b 45 18             	mov    0x18(%ebp),%eax
  105359:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10535c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10535f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105362:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105365:	89 55 f0             	mov    %edx,-0x10(%ebp)
  105368:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10536b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10536e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105372:	74 1c                	je     105390 <printnum+0x58>
  105374:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105377:	ba 00 00 00 00       	mov    $0x0,%edx
  10537c:	f7 75 e4             	divl   -0x1c(%ebp)
  10537f:	89 55 f4             	mov    %edx,-0xc(%ebp)
  105382:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105385:	ba 00 00 00 00       	mov    $0x0,%edx
  10538a:	f7 75 e4             	divl   -0x1c(%ebp)
  10538d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105390:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105393:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105396:	f7 75 e4             	divl   -0x1c(%ebp)
  105399:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10539c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  10539f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1053a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1053a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1053a8:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1053ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1053ae:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1053b1:	8b 45 18             	mov    0x18(%ebp),%eax
  1053b4:	ba 00 00 00 00       	mov    $0x0,%edx
  1053b9:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1053bc:	77 56                	ja     105414 <printnum+0xdc>
  1053be:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1053c1:	72 05                	jb     1053c8 <printnum+0x90>
  1053c3:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1053c6:	77 4c                	ja     105414 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  1053c8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1053cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  1053ce:	8b 45 20             	mov    0x20(%ebp),%eax
  1053d1:	89 44 24 18          	mov    %eax,0x18(%esp)
  1053d5:	89 54 24 14          	mov    %edx,0x14(%esp)
  1053d9:	8b 45 18             	mov    0x18(%ebp),%eax
  1053dc:	89 44 24 10          	mov    %eax,0x10(%esp)
  1053e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1053e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1053e6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1053ea:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1053ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1053f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1053f5:	8b 45 08             	mov    0x8(%ebp),%eax
  1053f8:	89 04 24             	mov    %eax,(%esp)
  1053fb:	e8 38 ff ff ff       	call   105338 <printnum>
  105400:	eb 1c                	jmp    10541e <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  105402:	8b 45 0c             	mov    0xc(%ebp),%eax
  105405:	89 44 24 04          	mov    %eax,0x4(%esp)
  105409:	8b 45 20             	mov    0x20(%ebp),%eax
  10540c:	89 04 24             	mov    %eax,(%esp)
  10540f:	8b 45 08             	mov    0x8(%ebp),%eax
  105412:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  105414:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  105418:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10541c:	7f e4                	jg     105402 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  10541e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105421:	05 dc 6f 10 00       	add    $0x106fdc,%eax
  105426:	0f b6 00             	movzbl (%eax),%eax
  105429:	0f be c0             	movsbl %al,%eax
  10542c:	8b 55 0c             	mov    0xc(%ebp),%edx
  10542f:	89 54 24 04          	mov    %edx,0x4(%esp)
  105433:	89 04 24             	mov    %eax,(%esp)
  105436:	8b 45 08             	mov    0x8(%ebp),%eax
  105439:	ff d0                	call   *%eax
}
  10543b:	c9                   	leave  
  10543c:	c3                   	ret    

0010543d <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  10543d:	55                   	push   %ebp
  10543e:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105440:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105444:	7e 14                	jle    10545a <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  105446:	8b 45 08             	mov    0x8(%ebp),%eax
  105449:	8b 00                	mov    (%eax),%eax
  10544b:	8d 48 08             	lea    0x8(%eax),%ecx
  10544e:	8b 55 08             	mov    0x8(%ebp),%edx
  105451:	89 0a                	mov    %ecx,(%edx)
  105453:	8b 50 04             	mov    0x4(%eax),%edx
  105456:	8b 00                	mov    (%eax),%eax
  105458:	eb 30                	jmp    10548a <getuint+0x4d>
    }
    else if (lflag) {
  10545a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10545e:	74 16                	je     105476 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  105460:	8b 45 08             	mov    0x8(%ebp),%eax
  105463:	8b 00                	mov    (%eax),%eax
  105465:	8d 48 04             	lea    0x4(%eax),%ecx
  105468:	8b 55 08             	mov    0x8(%ebp),%edx
  10546b:	89 0a                	mov    %ecx,(%edx)
  10546d:	8b 00                	mov    (%eax),%eax
  10546f:	ba 00 00 00 00       	mov    $0x0,%edx
  105474:	eb 14                	jmp    10548a <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  105476:	8b 45 08             	mov    0x8(%ebp),%eax
  105479:	8b 00                	mov    (%eax),%eax
  10547b:	8d 48 04             	lea    0x4(%eax),%ecx
  10547e:	8b 55 08             	mov    0x8(%ebp),%edx
  105481:	89 0a                	mov    %ecx,(%edx)
  105483:	8b 00                	mov    (%eax),%eax
  105485:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  10548a:	5d                   	pop    %ebp
  10548b:	c3                   	ret    

0010548c <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  10548c:	55                   	push   %ebp
  10548d:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  10548f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105493:	7e 14                	jle    1054a9 <getint+0x1d>
        return va_arg(*ap, long long);
  105495:	8b 45 08             	mov    0x8(%ebp),%eax
  105498:	8b 00                	mov    (%eax),%eax
  10549a:	8d 48 08             	lea    0x8(%eax),%ecx
  10549d:	8b 55 08             	mov    0x8(%ebp),%edx
  1054a0:	89 0a                	mov    %ecx,(%edx)
  1054a2:	8b 50 04             	mov    0x4(%eax),%edx
  1054a5:	8b 00                	mov    (%eax),%eax
  1054a7:	eb 28                	jmp    1054d1 <getint+0x45>
    }
    else if (lflag) {
  1054a9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1054ad:	74 12                	je     1054c1 <getint+0x35>
        return va_arg(*ap, long);
  1054af:	8b 45 08             	mov    0x8(%ebp),%eax
  1054b2:	8b 00                	mov    (%eax),%eax
  1054b4:	8d 48 04             	lea    0x4(%eax),%ecx
  1054b7:	8b 55 08             	mov    0x8(%ebp),%edx
  1054ba:	89 0a                	mov    %ecx,(%edx)
  1054bc:	8b 00                	mov    (%eax),%eax
  1054be:	99                   	cltd   
  1054bf:	eb 10                	jmp    1054d1 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  1054c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1054c4:	8b 00                	mov    (%eax),%eax
  1054c6:	8d 48 04             	lea    0x4(%eax),%ecx
  1054c9:	8b 55 08             	mov    0x8(%ebp),%edx
  1054cc:	89 0a                	mov    %ecx,(%edx)
  1054ce:	8b 00                	mov    (%eax),%eax
  1054d0:	99                   	cltd   
    }
}
  1054d1:	5d                   	pop    %ebp
  1054d2:	c3                   	ret    

001054d3 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1054d3:	55                   	push   %ebp
  1054d4:	89 e5                	mov    %esp,%ebp
  1054d6:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  1054d9:	8d 45 14             	lea    0x14(%ebp),%eax
  1054dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  1054df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1054e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1054e6:	8b 45 10             	mov    0x10(%ebp),%eax
  1054e9:	89 44 24 08          	mov    %eax,0x8(%esp)
  1054ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  1054f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1054f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1054f7:	89 04 24             	mov    %eax,(%esp)
  1054fa:	e8 02 00 00 00       	call   105501 <vprintfmt>
    va_end(ap);
}
  1054ff:	c9                   	leave  
  105500:	c3                   	ret    

00105501 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  105501:	55                   	push   %ebp
  105502:	89 e5                	mov    %esp,%ebp
  105504:	56                   	push   %esi
  105505:	53                   	push   %ebx
  105506:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105509:	eb 18                	jmp    105523 <vprintfmt+0x22>
            if (ch == '\0') {
  10550b:	85 db                	test   %ebx,%ebx
  10550d:	75 05                	jne    105514 <vprintfmt+0x13>
                return;
  10550f:	e9 d1 03 00 00       	jmp    1058e5 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  105514:	8b 45 0c             	mov    0xc(%ebp),%eax
  105517:	89 44 24 04          	mov    %eax,0x4(%esp)
  10551b:	89 1c 24             	mov    %ebx,(%esp)
  10551e:	8b 45 08             	mov    0x8(%ebp),%eax
  105521:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105523:	8b 45 10             	mov    0x10(%ebp),%eax
  105526:	8d 50 01             	lea    0x1(%eax),%edx
  105529:	89 55 10             	mov    %edx,0x10(%ebp)
  10552c:	0f b6 00             	movzbl (%eax),%eax
  10552f:	0f b6 d8             	movzbl %al,%ebx
  105532:	83 fb 25             	cmp    $0x25,%ebx
  105535:	75 d4                	jne    10550b <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  105537:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  10553b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  105542:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105545:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  105548:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10554f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105552:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  105555:	8b 45 10             	mov    0x10(%ebp),%eax
  105558:	8d 50 01             	lea    0x1(%eax),%edx
  10555b:	89 55 10             	mov    %edx,0x10(%ebp)
  10555e:	0f b6 00             	movzbl (%eax),%eax
  105561:	0f b6 d8             	movzbl %al,%ebx
  105564:	8d 43 dd             	lea    -0x23(%ebx),%eax
  105567:	83 f8 55             	cmp    $0x55,%eax
  10556a:	0f 87 44 03 00 00    	ja     1058b4 <vprintfmt+0x3b3>
  105570:	8b 04 85 00 70 10 00 	mov    0x107000(,%eax,4),%eax
  105577:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  105579:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  10557d:	eb d6                	jmp    105555 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  10557f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  105583:	eb d0                	jmp    105555 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105585:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  10558c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10558f:	89 d0                	mov    %edx,%eax
  105591:	c1 e0 02             	shl    $0x2,%eax
  105594:	01 d0                	add    %edx,%eax
  105596:	01 c0                	add    %eax,%eax
  105598:	01 d8                	add    %ebx,%eax
  10559a:	83 e8 30             	sub    $0x30,%eax
  10559d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  1055a0:	8b 45 10             	mov    0x10(%ebp),%eax
  1055a3:	0f b6 00             	movzbl (%eax),%eax
  1055a6:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  1055a9:	83 fb 2f             	cmp    $0x2f,%ebx
  1055ac:	7e 0b                	jle    1055b9 <vprintfmt+0xb8>
  1055ae:	83 fb 39             	cmp    $0x39,%ebx
  1055b1:	7f 06                	jg     1055b9 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1055b3:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  1055b7:	eb d3                	jmp    10558c <vprintfmt+0x8b>
            goto process_precision;
  1055b9:	eb 33                	jmp    1055ee <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  1055bb:	8b 45 14             	mov    0x14(%ebp),%eax
  1055be:	8d 50 04             	lea    0x4(%eax),%edx
  1055c1:	89 55 14             	mov    %edx,0x14(%ebp)
  1055c4:	8b 00                	mov    (%eax),%eax
  1055c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1055c9:	eb 23                	jmp    1055ee <vprintfmt+0xed>

        case '.':
            if (width < 0)
  1055cb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1055cf:	79 0c                	jns    1055dd <vprintfmt+0xdc>
                width = 0;
  1055d1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1055d8:	e9 78 ff ff ff       	jmp    105555 <vprintfmt+0x54>
  1055dd:	e9 73 ff ff ff       	jmp    105555 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  1055e2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  1055e9:	e9 67 ff ff ff       	jmp    105555 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  1055ee:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1055f2:	79 12                	jns    105606 <vprintfmt+0x105>
                width = precision, precision = -1;
  1055f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1055f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1055fa:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  105601:	e9 4f ff ff ff       	jmp    105555 <vprintfmt+0x54>
  105606:	e9 4a ff ff ff       	jmp    105555 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  10560b:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  10560f:	e9 41 ff ff ff       	jmp    105555 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  105614:	8b 45 14             	mov    0x14(%ebp),%eax
  105617:	8d 50 04             	lea    0x4(%eax),%edx
  10561a:	89 55 14             	mov    %edx,0x14(%ebp)
  10561d:	8b 00                	mov    (%eax),%eax
  10561f:	8b 55 0c             	mov    0xc(%ebp),%edx
  105622:	89 54 24 04          	mov    %edx,0x4(%esp)
  105626:	89 04 24             	mov    %eax,(%esp)
  105629:	8b 45 08             	mov    0x8(%ebp),%eax
  10562c:	ff d0                	call   *%eax
            break;
  10562e:	e9 ac 02 00 00       	jmp    1058df <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  105633:	8b 45 14             	mov    0x14(%ebp),%eax
  105636:	8d 50 04             	lea    0x4(%eax),%edx
  105639:	89 55 14             	mov    %edx,0x14(%ebp)
  10563c:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  10563e:	85 db                	test   %ebx,%ebx
  105640:	79 02                	jns    105644 <vprintfmt+0x143>
                err = -err;
  105642:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  105644:	83 fb 06             	cmp    $0x6,%ebx
  105647:	7f 0b                	jg     105654 <vprintfmt+0x153>
  105649:	8b 34 9d c0 6f 10 00 	mov    0x106fc0(,%ebx,4),%esi
  105650:	85 f6                	test   %esi,%esi
  105652:	75 23                	jne    105677 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  105654:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105658:	c7 44 24 08 ed 6f 10 	movl   $0x106fed,0x8(%esp)
  10565f:	00 
  105660:	8b 45 0c             	mov    0xc(%ebp),%eax
  105663:	89 44 24 04          	mov    %eax,0x4(%esp)
  105667:	8b 45 08             	mov    0x8(%ebp),%eax
  10566a:	89 04 24             	mov    %eax,(%esp)
  10566d:	e8 61 fe ff ff       	call   1054d3 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  105672:	e9 68 02 00 00       	jmp    1058df <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  105677:	89 74 24 0c          	mov    %esi,0xc(%esp)
  10567b:	c7 44 24 08 f6 6f 10 	movl   $0x106ff6,0x8(%esp)
  105682:	00 
  105683:	8b 45 0c             	mov    0xc(%ebp),%eax
  105686:	89 44 24 04          	mov    %eax,0x4(%esp)
  10568a:	8b 45 08             	mov    0x8(%ebp),%eax
  10568d:	89 04 24             	mov    %eax,(%esp)
  105690:	e8 3e fe ff ff       	call   1054d3 <printfmt>
            }
            break;
  105695:	e9 45 02 00 00       	jmp    1058df <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  10569a:	8b 45 14             	mov    0x14(%ebp),%eax
  10569d:	8d 50 04             	lea    0x4(%eax),%edx
  1056a0:	89 55 14             	mov    %edx,0x14(%ebp)
  1056a3:	8b 30                	mov    (%eax),%esi
  1056a5:	85 f6                	test   %esi,%esi
  1056a7:	75 05                	jne    1056ae <vprintfmt+0x1ad>
                p = "(null)";
  1056a9:	be f9 6f 10 00       	mov    $0x106ff9,%esi
            }
            if (width > 0 && padc != '-') {
  1056ae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1056b2:	7e 3e                	jle    1056f2 <vprintfmt+0x1f1>
  1056b4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1056b8:	74 38                	je     1056f2 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1056ba:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  1056bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1056c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056c4:	89 34 24             	mov    %esi,(%esp)
  1056c7:	e8 15 03 00 00       	call   1059e1 <strnlen>
  1056cc:	29 c3                	sub    %eax,%ebx
  1056ce:	89 d8                	mov    %ebx,%eax
  1056d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1056d3:	eb 17                	jmp    1056ec <vprintfmt+0x1eb>
                    putch(padc, putdat);
  1056d5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1056d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  1056dc:	89 54 24 04          	mov    %edx,0x4(%esp)
  1056e0:	89 04 24             	mov    %eax,(%esp)
  1056e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1056e6:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  1056e8:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1056ec:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1056f0:	7f e3                	jg     1056d5 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1056f2:	eb 38                	jmp    10572c <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  1056f4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1056f8:	74 1f                	je     105719 <vprintfmt+0x218>
  1056fa:	83 fb 1f             	cmp    $0x1f,%ebx
  1056fd:	7e 05                	jle    105704 <vprintfmt+0x203>
  1056ff:	83 fb 7e             	cmp    $0x7e,%ebx
  105702:	7e 15                	jle    105719 <vprintfmt+0x218>
                    putch('?', putdat);
  105704:	8b 45 0c             	mov    0xc(%ebp),%eax
  105707:	89 44 24 04          	mov    %eax,0x4(%esp)
  10570b:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  105712:	8b 45 08             	mov    0x8(%ebp),%eax
  105715:	ff d0                	call   *%eax
  105717:	eb 0f                	jmp    105728 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  105719:	8b 45 0c             	mov    0xc(%ebp),%eax
  10571c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105720:	89 1c 24             	mov    %ebx,(%esp)
  105723:	8b 45 08             	mov    0x8(%ebp),%eax
  105726:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105728:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10572c:	89 f0                	mov    %esi,%eax
  10572e:	8d 70 01             	lea    0x1(%eax),%esi
  105731:	0f b6 00             	movzbl (%eax),%eax
  105734:	0f be d8             	movsbl %al,%ebx
  105737:	85 db                	test   %ebx,%ebx
  105739:	74 10                	je     10574b <vprintfmt+0x24a>
  10573b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10573f:	78 b3                	js     1056f4 <vprintfmt+0x1f3>
  105741:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  105745:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105749:	79 a9                	jns    1056f4 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  10574b:	eb 17                	jmp    105764 <vprintfmt+0x263>
                putch(' ', putdat);
  10574d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105750:	89 44 24 04          	mov    %eax,0x4(%esp)
  105754:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10575b:	8b 45 08             	mov    0x8(%ebp),%eax
  10575e:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  105760:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105764:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105768:	7f e3                	jg     10574d <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  10576a:	e9 70 01 00 00       	jmp    1058df <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  10576f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105772:	89 44 24 04          	mov    %eax,0x4(%esp)
  105776:	8d 45 14             	lea    0x14(%ebp),%eax
  105779:	89 04 24             	mov    %eax,(%esp)
  10577c:	e8 0b fd ff ff       	call   10548c <getint>
  105781:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105784:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  105787:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10578a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10578d:	85 d2                	test   %edx,%edx
  10578f:	79 26                	jns    1057b7 <vprintfmt+0x2b6>
                putch('-', putdat);
  105791:	8b 45 0c             	mov    0xc(%ebp),%eax
  105794:	89 44 24 04          	mov    %eax,0x4(%esp)
  105798:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  10579f:	8b 45 08             	mov    0x8(%ebp),%eax
  1057a2:	ff d0                	call   *%eax
                num = -(long long)num;
  1057a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1057a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1057aa:	f7 d8                	neg    %eax
  1057ac:	83 d2 00             	adc    $0x0,%edx
  1057af:	f7 da                	neg    %edx
  1057b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1057b4:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1057b7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1057be:	e9 a8 00 00 00       	jmp    10586b <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1057c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1057c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057ca:	8d 45 14             	lea    0x14(%ebp),%eax
  1057cd:	89 04 24             	mov    %eax,(%esp)
  1057d0:	e8 68 fc ff ff       	call   10543d <getuint>
  1057d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1057d8:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1057db:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1057e2:	e9 84 00 00 00       	jmp    10586b <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  1057e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1057ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057ee:	8d 45 14             	lea    0x14(%ebp),%eax
  1057f1:	89 04 24             	mov    %eax,(%esp)
  1057f4:	e8 44 fc ff ff       	call   10543d <getuint>
  1057f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1057fc:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  1057ff:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  105806:	eb 63                	jmp    10586b <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  105808:	8b 45 0c             	mov    0xc(%ebp),%eax
  10580b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10580f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  105816:	8b 45 08             	mov    0x8(%ebp),%eax
  105819:	ff d0                	call   *%eax
            putch('x', putdat);
  10581b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10581e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105822:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  105829:	8b 45 08             	mov    0x8(%ebp),%eax
  10582c:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  10582e:	8b 45 14             	mov    0x14(%ebp),%eax
  105831:	8d 50 04             	lea    0x4(%eax),%edx
  105834:	89 55 14             	mov    %edx,0x14(%ebp)
  105837:	8b 00                	mov    (%eax),%eax
  105839:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10583c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105843:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  10584a:	eb 1f                	jmp    10586b <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  10584c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10584f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105853:	8d 45 14             	lea    0x14(%ebp),%eax
  105856:	89 04 24             	mov    %eax,(%esp)
  105859:	e8 df fb ff ff       	call   10543d <getuint>
  10585e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105861:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  105864:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  10586b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  10586f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105872:	89 54 24 18          	mov    %edx,0x18(%esp)
  105876:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105879:	89 54 24 14          	mov    %edx,0x14(%esp)
  10587d:	89 44 24 10          	mov    %eax,0x10(%esp)
  105881:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105884:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105887:	89 44 24 08          	mov    %eax,0x8(%esp)
  10588b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10588f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105892:	89 44 24 04          	mov    %eax,0x4(%esp)
  105896:	8b 45 08             	mov    0x8(%ebp),%eax
  105899:	89 04 24             	mov    %eax,(%esp)
  10589c:	e8 97 fa ff ff       	call   105338 <printnum>
            break;
  1058a1:	eb 3c                	jmp    1058df <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1058a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058aa:	89 1c 24             	mov    %ebx,(%esp)
  1058ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1058b0:	ff d0                	call   *%eax
            break;
  1058b2:	eb 2b                	jmp    1058df <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1058b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058bb:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  1058c2:	8b 45 08             	mov    0x8(%ebp),%eax
  1058c5:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  1058c7:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1058cb:	eb 04                	jmp    1058d1 <vprintfmt+0x3d0>
  1058cd:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1058d1:	8b 45 10             	mov    0x10(%ebp),%eax
  1058d4:	83 e8 01             	sub    $0x1,%eax
  1058d7:	0f b6 00             	movzbl (%eax),%eax
  1058da:	3c 25                	cmp    $0x25,%al
  1058dc:	75 ef                	jne    1058cd <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  1058de:	90                   	nop
        }
    }
  1058df:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1058e0:	e9 3e fc ff ff       	jmp    105523 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  1058e5:	83 c4 40             	add    $0x40,%esp
  1058e8:	5b                   	pop    %ebx
  1058e9:	5e                   	pop    %esi
  1058ea:	5d                   	pop    %ebp
  1058eb:	c3                   	ret    

001058ec <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  1058ec:	55                   	push   %ebp
  1058ed:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1058ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058f2:	8b 40 08             	mov    0x8(%eax),%eax
  1058f5:	8d 50 01             	lea    0x1(%eax),%edx
  1058f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058fb:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1058fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  105901:	8b 10                	mov    (%eax),%edx
  105903:	8b 45 0c             	mov    0xc(%ebp),%eax
  105906:	8b 40 04             	mov    0x4(%eax),%eax
  105909:	39 c2                	cmp    %eax,%edx
  10590b:	73 12                	jae    10591f <sprintputch+0x33>
        *b->buf ++ = ch;
  10590d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105910:	8b 00                	mov    (%eax),%eax
  105912:	8d 48 01             	lea    0x1(%eax),%ecx
  105915:	8b 55 0c             	mov    0xc(%ebp),%edx
  105918:	89 0a                	mov    %ecx,(%edx)
  10591a:	8b 55 08             	mov    0x8(%ebp),%edx
  10591d:	88 10                	mov    %dl,(%eax)
    }
}
  10591f:	5d                   	pop    %ebp
  105920:	c3                   	ret    

00105921 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105921:	55                   	push   %ebp
  105922:	89 e5                	mov    %esp,%ebp
  105924:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105927:	8d 45 14             	lea    0x14(%ebp),%eax
  10592a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  10592d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105930:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105934:	8b 45 10             	mov    0x10(%ebp),%eax
  105937:	89 44 24 08          	mov    %eax,0x8(%esp)
  10593b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10593e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105942:	8b 45 08             	mov    0x8(%ebp),%eax
  105945:	89 04 24             	mov    %eax,(%esp)
  105948:	e8 08 00 00 00       	call   105955 <vsnprintf>
  10594d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105950:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105953:	c9                   	leave  
  105954:	c3                   	ret    

00105955 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105955:	55                   	push   %ebp
  105956:	89 e5                	mov    %esp,%ebp
  105958:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  10595b:	8b 45 08             	mov    0x8(%ebp),%eax
  10595e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105961:	8b 45 0c             	mov    0xc(%ebp),%eax
  105964:	8d 50 ff             	lea    -0x1(%eax),%edx
  105967:	8b 45 08             	mov    0x8(%ebp),%eax
  10596a:	01 d0                	add    %edx,%eax
  10596c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10596f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105976:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10597a:	74 0a                	je     105986 <vsnprintf+0x31>
  10597c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10597f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105982:	39 c2                	cmp    %eax,%edx
  105984:	76 07                	jbe    10598d <vsnprintf+0x38>
        return -E_INVAL;
  105986:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  10598b:	eb 2a                	jmp    1059b7 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  10598d:	8b 45 14             	mov    0x14(%ebp),%eax
  105990:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105994:	8b 45 10             	mov    0x10(%ebp),%eax
  105997:	89 44 24 08          	mov    %eax,0x8(%esp)
  10599b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  10599e:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059a2:	c7 04 24 ec 58 10 00 	movl   $0x1058ec,(%esp)
  1059a9:	e8 53 fb ff ff       	call   105501 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  1059ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1059b1:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1059b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1059b7:	c9                   	leave  
  1059b8:	c3                   	ret    

001059b9 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  1059b9:	55                   	push   %ebp
  1059ba:	89 e5                	mov    %esp,%ebp
  1059bc:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1059bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  1059c6:	eb 04                	jmp    1059cc <strlen+0x13>
        cnt ++;
  1059c8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  1059cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1059cf:	8d 50 01             	lea    0x1(%eax),%edx
  1059d2:	89 55 08             	mov    %edx,0x8(%ebp)
  1059d5:	0f b6 00             	movzbl (%eax),%eax
  1059d8:	84 c0                	test   %al,%al
  1059da:	75 ec                	jne    1059c8 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  1059dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1059df:	c9                   	leave  
  1059e0:	c3                   	ret    

001059e1 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  1059e1:	55                   	push   %ebp
  1059e2:	89 e5                	mov    %esp,%ebp
  1059e4:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1059e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1059ee:	eb 04                	jmp    1059f4 <strnlen+0x13>
        cnt ++;
  1059f0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  1059f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1059f7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1059fa:	73 10                	jae    105a0c <strnlen+0x2b>
  1059fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1059ff:	8d 50 01             	lea    0x1(%eax),%edx
  105a02:	89 55 08             	mov    %edx,0x8(%ebp)
  105a05:	0f b6 00             	movzbl (%eax),%eax
  105a08:	84 c0                	test   %al,%al
  105a0a:	75 e4                	jne    1059f0 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  105a0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105a0f:	c9                   	leave  
  105a10:	c3                   	ret    

00105a11 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105a11:	55                   	push   %ebp
  105a12:	89 e5                	mov    %esp,%ebp
  105a14:	57                   	push   %edi
  105a15:	56                   	push   %esi
  105a16:	83 ec 20             	sub    $0x20,%esp
  105a19:	8b 45 08             	mov    0x8(%ebp),%eax
  105a1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105a1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a22:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105a25:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105a2b:	89 d1                	mov    %edx,%ecx
  105a2d:	89 c2                	mov    %eax,%edx
  105a2f:	89 ce                	mov    %ecx,%esi
  105a31:	89 d7                	mov    %edx,%edi
  105a33:	ac                   	lods   %ds:(%esi),%al
  105a34:	aa                   	stos   %al,%es:(%edi)
  105a35:	84 c0                	test   %al,%al
  105a37:	75 fa                	jne    105a33 <strcpy+0x22>
  105a39:	89 fa                	mov    %edi,%edx
  105a3b:	89 f1                	mov    %esi,%ecx
  105a3d:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105a40:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105a43:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105a49:	83 c4 20             	add    $0x20,%esp
  105a4c:	5e                   	pop    %esi
  105a4d:	5f                   	pop    %edi
  105a4e:	5d                   	pop    %ebp
  105a4f:	c3                   	ret    

00105a50 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105a50:	55                   	push   %ebp
  105a51:	89 e5                	mov    %esp,%ebp
  105a53:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105a56:	8b 45 08             	mov    0x8(%ebp),%eax
  105a59:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105a5c:	eb 21                	jmp    105a7f <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  105a5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a61:	0f b6 10             	movzbl (%eax),%edx
  105a64:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105a67:	88 10                	mov    %dl,(%eax)
  105a69:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105a6c:	0f b6 00             	movzbl (%eax),%eax
  105a6f:	84 c0                	test   %al,%al
  105a71:	74 04                	je     105a77 <strncpy+0x27>
            src ++;
  105a73:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  105a77:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105a7b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  105a7f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105a83:	75 d9                	jne    105a5e <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  105a85:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105a88:	c9                   	leave  
  105a89:	c3                   	ret    

00105a8a <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105a8a:	55                   	push   %ebp
  105a8b:	89 e5                	mov    %esp,%ebp
  105a8d:	57                   	push   %edi
  105a8e:	56                   	push   %esi
  105a8f:	83 ec 20             	sub    $0x20,%esp
  105a92:	8b 45 08             	mov    0x8(%ebp),%eax
  105a95:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105a98:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  105a9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105aa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105aa4:	89 d1                	mov    %edx,%ecx
  105aa6:	89 c2                	mov    %eax,%edx
  105aa8:	89 ce                	mov    %ecx,%esi
  105aaa:	89 d7                	mov    %edx,%edi
  105aac:	ac                   	lods   %ds:(%esi),%al
  105aad:	ae                   	scas   %es:(%edi),%al
  105aae:	75 08                	jne    105ab8 <strcmp+0x2e>
  105ab0:	84 c0                	test   %al,%al
  105ab2:	75 f8                	jne    105aac <strcmp+0x22>
  105ab4:	31 c0                	xor    %eax,%eax
  105ab6:	eb 04                	jmp    105abc <strcmp+0x32>
  105ab8:	19 c0                	sbb    %eax,%eax
  105aba:	0c 01                	or     $0x1,%al
  105abc:	89 fa                	mov    %edi,%edx
  105abe:	89 f1                	mov    %esi,%ecx
  105ac0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105ac3:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105ac6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  105ac9:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105acc:	83 c4 20             	add    $0x20,%esp
  105acf:	5e                   	pop    %esi
  105ad0:	5f                   	pop    %edi
  105ad1:	5d                   	pop    %ebp
  105ad2:	c3                   	ret    

00105ad3 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105ad3:	55                   	push   %ebp
  105ad4:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105ad6:	eb 0c                	jmp    105ae4 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  105ad8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105adc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105ae0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105ae4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105ae8:	74 1a                	je     105b04 <strncmp+0x31>
  105aea:	8b 45 08             	mov    0x8(%ebp),%eax
  105aed:	0f b6 00             	movzbl (%eax),%eax
  105af0:	84 c0                	test   %al,%al
  105af2:	74 10                	je     105b04 <strncmp+0x31>
  105af4:	8b 45 08             	mov    0x8(%ebp),%eax
  105af7:	0f b6 10             	movzbl (%eax),%edx
  105afa:	8b 45 0c             	mov    0xc(%ebp),%eax
  105afd:	0f b6 00             	movzbl (%eax),%eax
  105b00:	38 c2                	cmp    %al,%dl
  105b02:	74 d4                	je     105ad8 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105b04:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105b08:	74 18                	je     105b22 <strncmp+0x4f>
  105b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  105b0d:	0f b6 00             	movzbl (%eax),%eax
  105b10:	0f b6 d0             	movzbl %al,%edx
  105b13:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b16:	0f b6 00             	movzbl (%eax),%eax
  105b19:	0f b6 c0             	movzbl %al,%eax
  105b1c:	29 c2                	sub    %eax,%edx
  105b1e:	89 d0                	mov    %edx,%eax
  105b20:	eb 05                	jmp    105b27 <strncmp+0x54>
  105b22:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105b27:	5d                   	pop    %ebp
  105b28:	c3                   	ret    

00105b29 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105b29:	55                   	push   %ebp
  105b2a:	89 e5                	mov    %esp,%ebp
  105b2c:	83 ec 04             	sub    $0x4,%esp
  105b2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b32:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105b35:	eb 14                	jmp    105b4b <strchr+0x22>
        if (*s == c) {
  105b37:	8b 45 08             	mov    0x8(%ebp),%eax
  105b3a:	0f b6 00             	movzbl (%eax),%eax
  105b3d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105b40:	75 05                	jne    105b47 <strchr+0x1e>
            return (char *)s;
  105b42:	8b 45 08             	mov    0x8(%ebp),%eax
  105b45:	eb 13                	jmp    105b5a <strchr+0x31>
        }
        s ++;
  105b47:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  105b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  105b4e:	0f b6 00             	movzbl (%eax),%eax
  105b51:	84 c0                	test   %al,%al
  105b53:	75 e2                	jne    105b37 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  105b55:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105b5a:	c9                   	leave  
  105b5b:	c3                   	ret    

00105b5c <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105b5c:	55                   	push   %ebp
  105b5d:	89 e5                	mov    %esp,%ebp
  105b5f:	83 ec 04             	sub    $0x4,%esp
  105b62:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b65:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105b68:	eb 11                	jmp    105b7b <strfind+0x1f>
        if (*s == c) {
  105b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  105b6d:	0f b6 00             	movzbl (%eax),%eax
  105b70:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105b73:	75 02                	jne    105b77 <strfind+0x1b>
            break;
  105b75:	eb 0e                	jmp    105b85 <strfind+0x29>
        }
        s ++;
  105b77:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  105b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  105b7e:	0f b6 00             	movzbl (%eax),%eax
  105b81:	84 c0                	test   %al,%al
  105b83:	75 e5                	jne    105b6a <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  105b85:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105b88:	c9                   	leave  
  105b89:	c3                   	ret    

00105b8a <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105b8a:	55                   	push   %ebp
  105b8b:	89 e5                	mov    %esp,%ebp
  105b8d:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105b90:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105b97:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105b9e:	eb 04                	jmp    105ba4 <strtol+0x1a>
        s ++;
  105ba0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  105ba7:	0f b6 00             	movzbl (%eax),%eax
  105baa:	3c 20                	cmp    $0x20,%al
  105bac:	74 f2                	je     105ba0 <strtol+0x16>
  105bae:	8b 45 08             	mov    0x8(%ebp),%eax
  105bb1:	0f b6 00             	movzbl (%eax),%eax
  105bb4:	3c 09                	cmp    $0x9,%al
  105bb6:	74 e8                	je     105ba0 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  105bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  105bbb:	0f b6 00             	movzbl (%eax),%eax
  105bbe:	3c 2b                	cmp    $0x2b,%al
  105bc0:	75 06                	jne    105bc8 <strtol+0x3e>
        s ++;
  105bc2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105bc6:	eb 15                	jmp    105bdd <strtol+0x53>
    }
    else if (*s == '-') {
  105bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  105bcb:	0f b6 00             	movzbl (%eax),%eax
  105bce:	3c 2d                	cmp    $0x2d,%al
  105bd0:	75 0b                	jne    105bdd <strtol+0x53>
        s ++, neg = 1;
  105bd2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105bd6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105bdd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105be1:	74 06                	je     105be9 <strtol+0x5f>
  105be3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105be7:	75 24                	jne    105c0d <strtol+0x83>
  105be9:	8b 45 08             	mov    0x8(%ebp),%eax
  105bec:	0f b6 00             	movzbl (%eax),%eax
  105bef:	3c 30                	cmp    $0x30,%al
  105bf1:	75 1a                	jne    105c0d <strtol+0x83>
  105bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  105bf6:	83 c0 01             	add    $0x1,%eax
  105bf9:	0f b6 00             	movzbl (%eax),%eax
  105bfc:	3c 78                	cmp    $0x78,%al
  105bfe:	75 0d                	jne    105c0d <strtol+0x83>
        s += 2, base = 16;
  105c00:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105c04:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105c0b:	eb 2a                	jmp    105c37 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  105c0d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105c11:	75 17                	jne    105c2a <strtol+0xa0>
  105c13:	8b 45 08             	mov    0x8(%ebp),%eax
  105c16:	0f b6 00             	movzbl (%eax),%eax
  105c19:	3c 30                	cmp    $0x30,%al
  105c1b:	75 0d                	jne    105c2a <strtol+0xa0>
        s ++, base = 8;
  105c1d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105c21:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105c28:	eb 0d                	jmp    105c37 <strtol+0xad>
    }
    else if (base == 0) {
  105c2a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105c2e:	75 07                	jne    105c37 <strtol+0xad>
        base = 10;
  105c30:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105c37:	8b 45 08             	mov    0x8(%ebp),%eax
  105c3a:	0f b6 00             	movzbl (%eax),%eax
  105c3d:	3c 2f                	cmp    $0x2f,%al
  105c3f:	7e 1b                	jle    105c5c <strtol+0xd2>
  105c41:	8b 45 08             	mov    0x8(%ebp),%eax
  105c44:	0f b6 00             	movzbl (%eax),%eax
  105c47:	3c 39                	cmp    $0x39,%al
  105c49:	7f 11                	jg     105c5c <strtol+0xd2>
            dig = *s - '0';
  105c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  105c4e:	0f b6 00             	movzbl (%eax),%eax
  105c51:	0f be c0             	movsbl %al,%eax
  105c54:	83 e8 30             	sub    $0x30,%eax
  105c57:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105c5a:	eb 48                	jmp    105ca4 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  105c5f:	0f b6 00             	movzbl (%eax),%eax
  105c62:	3c 60                	cmp    $0x60,%al
  105c64:	7e 1b                	jle    105c81 <strtol+0xf7>
  105c66:	8b 45 08             	mov    0x8(%ebp),%eax
  105c69:	0f b6 00             	movzbl (%eax),%eax
  105c6c:	3c 7a                	cmp    $0x7a,%al
  105c6e:	7f 11                	jg     105c81 <strtol+0xf7>
            dig = *s - 'a' + 10;
  105c70:	8b 45 08             	mov    0x8(%ebp),%eax
  105c73:	0f b6 00             	movzbl (%eax),%eax
  105c76:	0f be c0             	movsbl %al,%eax
  105c79:	83 e8 57             	sub    $0x57,%eax
  105c7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105c7f:	eb 23                	jmp    105ca4 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105c81:	8b 45 08             	mov    0x8(%ebp),%eax
  105c84:	0f b6 00             	movzbl (%eax),%eax
  105c87:	3c 40                	cmp    $0x40,%al
  105c89:	7e 3d                	jle    105cc8 <strtol+0x13e>
  105c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  105c8e:	0f b6 00             	movzbl (%eax),%eax
  105c91:	3c 5a                	cmp    $0x5a,%al
  105c93:	7f 33                	jg     105cc8 <strtol+0x13e>
            dig = *s - 'A' + 10;
  105c95:	8b 45 08             	mov    0x8(%ebp),%eax
  105c98:	0f b6 00             	movzbl (%eax),%eax
  105c9b:	0f be c0             	movsbl %al,%eax
  105c9e:	83 e8 37             	sub    $0x37,%eax
  105ca1:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105ca7:	3b 45 10             	cmp    0x10(%ebp),%eax
  105caa:	7c 02                	jl     105cae <strtol+0x124>
            break;
  105cac:	eb 1a                	jmp    105cc8 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  105cae:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105cb2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105cb5:	0f af 45 10          	imul   0x10(%ebp),%eax
  105cb9:	89 c2                	mov    %eax,%edx
  105cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105cbe:	01 d0                	add    %edx,%eax
  105cc0:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  105cc3:	e9 6f ff ff ff       	jmp    105c37 <strtol+0xad>

    if (endptr) {
  105cc8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105ccc:	74 08                	je     105cd6 <strtol+0x14c>
        *endptr = (char *) s;
  105cce:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cd1:	8b 55 08             	mov    0x8(%ebp),%edx
  105cd4:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105cd6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105cda:	74 07                	je     105ce3 <strtol+0x159>
  105cdc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105cdf:	f7 d8                	neg    %eax
  105ce1:	eb 03                	jmp    105ce6 <strtol+0x15c>
  105ce3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105ce6:	c9                   	leave  
  105ce7:	c3                   	ret    

00105ce8 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105ce8:	55                   	push   %ebp
  105ce9:	89 e5                	mov    %esp,%ebp
  105ceb:	57                   	push   %edi
  105cec:	83 ec 24             	sub    $0x24,%esp
  105cef:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cf2:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105cf5:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  105cf9:	8b 55 08             	mov    0x8(%ebp),%edx
  105cfc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  105cff:	88 45 f7             	mov    %al,-0x9(%ebp)
  105d02:	8b 45 10             	mov    0x10(%ebp),%eax
  105d05:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105d08:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105d0b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105d0f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105d12:	89 d7                	mov    %edx,%edi
  105d14:	f3 aa                	rep stos %al,%es:(%edi)
  105d16:	89 fa                	mov    %edi,%edx
  105d18:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105d1b:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105d1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105d21:	83 c4 24             	add    $0x24,%esp
  105d24:	5f                   	pop    %edi
  105d25:	5d                   	pop    %ebp
  105d26:	c3                   	ret    

00105d27 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105d27:	55                   	push   %ebp
  105d28:	89 e5                	mov    %esp,%ebp
  105d2a:	57                   	push   %edi
  105d2b:	56                   	push   %esi
  105d2c:	53                   	push   %ebx
  105d2d:	83 ec 30             	sub    $0x30,%esp
  105d30:	8b 45 08             	mov    0x8(%ebp),%eax
  105d33:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105d36:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d39:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105d3c:	8b 45 10             	mov    0x10(%ebp),%eax
  105d3f:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105d42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d45:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105d48:	73 42                	jae    105d8c <memmove+0x65>
  105d4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d4d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105d50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105d53:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105d56:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105d59:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105d5c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105d5f:	c1 e8 02             	shr    $0x2,%eax
  105d62:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105d64:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105d67:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105d6a:	89 d7                	mov    %edx,%edi
  105d6c:	89 c6                	mov    %eax,%esi
  105d6e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105d70:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105d73:	83 e1 03             	and    $0x3,%ecx
  105d76:	74 02                	je     105d7a <memmove+0x53>
  105d78:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105d7a:	89 f0                	mov    %esi,%eax
  105d7c:	89 fa                	mov    %edi,%edx
  105d7e:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105d81:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105d84:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105d87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105d8a:	eb 36                	jmp    105dc2 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  105d8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105d8f:	8d 50 ff             	lea    -0x1(%eax),%edx
  105d92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105d95:	01 c2                	add    %eax,%edx
  105d97:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105d9a:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105d9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105da0:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  105da3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105da6:	89 c1                	mov    %eax,%ecx
  105da8:	89 d8                	mov    %ebx,%eax
  105daa:	89 d6                	mov    %edx,%esi
  105dac:	89 c7                	mov    %eax,%edi
  105dae:	fd                   	std    
  105daf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105db1:	fc                   	cld    
  105db2:	89 f8                	mov    %edi,%eax
  105db4:	89 f2                	mov    %esi,%edx
  105db6:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105db9:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105dbc:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  105dbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105dc2:	83 c4 30             	add    $0x30,%esp
  105dc5:	5b                   	pop    %ebx
  105dc6:	5e                   	pop    %esi
  105dc7:	5f                   	pop    %edi
  105dc8:	5d                   	pop    %ebp
  105dc9:	c3                   	ret    

00105dca <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105dca:	55                   	push   %ebp
  105dcb:	89 e5                	mov    %esp,%ebp
  105dcd:	57                   	push   %edi
  105dce:	56                   	push   %esi
  105dcf:	83 ec 20             	sub    $0x20,%esp
  105dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  105dd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105dd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ddb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105dde:	8b 45 10             	mov    0x10(%ebp),%eax
  105de1:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105de4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105de7:	c1 e8 02             	shr    $0x2,%eax
  105dea:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105dec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105def:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105df2:	89 d7                	mov    %edx,%edi
  105df4:	89 c6                	mov    %eax,%esi
  105df6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105df8:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105dfb:	83 e1 03             	and    $0x3,%ecx
  105dfe:	74 02                	je     105e02 <memcpy+0x38>
  105e00:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105e02:	89 f0                	mov    %esi,%eax
  105e04:	89 fa                	mov    %edi,%edx
  105e06:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105e09:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105e0c:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105e0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105e12:	83 c4 20             	add    $0x20,%esp
  105e15:	5e                   	pop    %esi
  105e16:	5f                   	pop    %edi
  105e17:	5d                   	pop    %ebp
  105e18:	c3                   	ret    

00105e19 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105e19:	55                   	push   %ebp
  105e1a:	89 e5                	mov    %esp,%ebp
  105e1c:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  105e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  105e22:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105e25:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e28:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105e2b:	eb 30                	jmp    105e5d <memcmp+0x44>
        if (*s1 != *s2) {
  105e2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105e30:	0f b6 10             	movzbl (%eax),%edx
  105e33:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105e36:	0f b6 00             	movzbl (%eax),%eax
  105e39:	38 c2                	cmp    %al,%dl
  105e3b:	74 18                	je     105e55 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105e3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105e40:	0f b6 00             	movzbl (%eax),%eax
  105e43:	0f b6 d0             	movzbl %al,%edx
  105e46:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105e49:	0f b6 00             	movzbl (%eax),%eax
  105e4c:	0f b6 c0             	movzbl %al,%eax
  105e4f:	29 c2                	sub    %eax,%edx
  105e51:	89 d0                	mov    %edx,%eax
  105e53:	eb 1a                	jmp    105e6f <memcmp+0x56>
        }
        s1 ++, s2 ++;
  105e55:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105e59:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  105e5d:	8b 45 10             	mov    0x10(%ebp),%eax
  105e60:	8d 50 ff             	lea    -0x1(%eax),%edx
  105e63:	89 55 10             	mov    %edx,0x10(%ebp)
  105e66:	85 c0                	test   %eax,%eax
  105e68:	75 c3                	jne    105e2d <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  105e6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105e6f:	c9                   	leave  
  105e70:	c3                   	ret    
