# Lab 1 Report

2013011303	计32  程凯

## 练习1：理解通过make生成执行文件的过程

### 1. 操作系统镜像文件ucore.img是如何一步一步生成的？

*(需要比较详细地解释Makefile中每一条相关命令和命令参数的含义，以及说明命令导致的结果)*

首先使用`make "V="`命令，观察make到底执行了哪些指令。

<br>

答：
	
		gcc各参数意义
		-I<dir>  添加搜索头文件的路径
		-m32  生成适用于32位环境的代码
		-ggdb 生成gdb调试信息
		-gstabs 生成stabs调试信息
		-fno-builtin  除非用__builtin_前缀，否则不进行builtin函数的优化
		-nostdinc 不使用标准库
		-fno-stack-protector 不检测缓冲区溢出
		-Os 控制代码大小
	ld各参数意义
		-m elf_i385 模拟i386连接器
		-nostdlib 不使用标准库
		-N 代码段和数据段均可读写
		-e 指定入口
		-Ttext 指定代码段开始位置
	objdump各参数意义
		-S 输出C源代码和反汇编出来的指令对照的格式
	objcopy各参数意义
		-S  移除所有符号和重定位信息
		-O <bfdname>  指定输出格式
	
+ 首先，我们要生成bootblck:
<br>

    	$(bootblock): $(call toobj,$(bootfiles)) | $(call totarget,sign)
        @echo + ld $@
        $(V)$(LD) $(LDFLAGS) -N -e start -Ttext 0x7C00 $^ -o $(call toobj,bootblock)
        @$(OBJDUMP) -S $(call objfile,bootblock) > $(call asmfile,bootblock)
        @$(OBJCOPY) -S -O binary $(call objfile,bootblock) $(call outfile,bootblock)
        @$(call totarget,sign) $(call outfile,bootblock) $(bootblock)
	
	然后生成obj/boot/bootasm.o和obj/boot/bootmain.o<br>

	
		bootfiles = $(call listf_cc,boot)
        $(foreach f,$(bootfiles),$(call cc_compile,$(f),$(CC),$(CFLAGS) -Os -nostdinc))
   生成bootasm.o
   
    	gcc -Iboot/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Os -nostdinc -c boot/bootasm.S -o obj/boot/bootasm.o
   
   生成bootmain.o
   
    	gcc -Iboot/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Os -nostdinc -c boot/bootmain.c -o obj/boot/bootmain.o
    	
   连接生成bootblock.o。
		
		ld -m    elf_i386 -nostdlib -N -e start -Ttext 0x7C00 obj/boot/bootasm.o obj/boot/bootmain.o -o obj/bootblock.o
<br>		
   
+ 然后我们要生成kernel：<br>
	
		$(call add_files_cc,$(call listf_cc,$(KSRCDIR)),kernel,$(KCFLAGS))
    	$(call add_files_cc,$(call listf_cc,$(LIBDIR)),libs,)
    	KOBJS   = $(call read_packet,kernel libs)
    	$(kernel): tools/kernel.ld
    	$(kernel): $(KOBJS)
        @echo + ld $@
        $(V)$(LD) $(LDFLAGS) -T tools/kernel.ld -o $@ $(KOBJS)
        @$(OBJDUMP) -S $@ > $(call asmfile,kernel)
        @$(OBJDUMP) -t $@ | $(SED) '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $(call symfile,kernel)
再通过ld连接各文件得到kernel.o

    	ld -m elf_i386 -nostdlib -T tools/kernel.ld -o bin/kernel $(obj_files_list)
    
+ 最后得到ucore.img:<br>

		$(UCOREIMG): $(kernel) $(bootblock)
    	$(V)dd if=/dev/zero of=$@ count=10000
    	$(V)dd if=$(bootblock) of=$@ conv=notrunc
    	$(V)dd if=$(kernel) of=$@ seek=1 conv=notrunc
	
### 2. 一个被系统认为是符合规范的硬盘主引导扇区的特征是什么？

+ 一个符合规范的硬盘主引导扇区大小为512字节，且以`0x55`和`0xAA`作为结束。



## 练习2：使用qemu执行并调试lab1中的软件

<br>1、从CPU加电后执行的第一条指令开始，单步跟踪BIOS的执行<br>

> * 把tools/gdbinit改成
```
    file bin/kerne
	target remote :1234
	set architecture i8086
```
> * 然后执行`make debug`，显示`PC: 0xfff0`即CPU加电后第一条指令。
	
<br>2、在初始化位置0x7c00设置实地址断点，测试断点正常<br>
>  * 把tools/gdbinit改成
```
	file bin/kernel
	target remote :1234
	set architecture i8086
	b *0x7c00
	continue
	x /i $pc
```
> * 此时显示`Breakpoint 1, 0x00007c00 in ?? ()`

> * 此时PC值为PC: 0x7c00，即证明断点正常。

<br>3、从0x7c00开始跟踪代码运行,将单步跟踪反汇编得到的代码与bootasm.S和 bootblock.asm进行比较。
> * 输入`x /10i $pc`,显示结果可知bootasm.S和bootblock.asm结果是一样的。

<br>4、自己找一个bootloader或内核中的代码位置，设置断点并进行测试。
> * 更改tools/gdbinit为
```
    set architecture i8086
    target remote :1234
    b *0x7c80
    continue
    x /i $pc
```
> * 在0x7c80位置设置断点输出的语句为` 0x7c80: and $0xffc0,%ax`。

## 练习3：分析bootloader进入保护模式的过程

+ 在bootasm.S中，由start开始
<br>
+ 首先初始化寄存器为0
```
    cli                            # Disable interrupts
    cld                            # String operations increment

    # Set up the important data segment registers (DS, ES, SS).
    xorw %ax, %ax                   # Segment number zero
    movw %ax, %ds                   # -> Data Segment
    movw %ax, %es                   # -> Extra Segment
    movw %ax, %ss                   # -> Stack Segment
```

+ 然后使能A20，使32位地址线可用。当8042键盘控制器输入缓存为空时，写入0x64即向P2端口写入数据。继续当输入缓存为空时，将0x60端口赋值为0xdf，此时A20位就赋值为1。
```
    # Enable A20:
    #  For backwards compatibility with the earliest PCs, physical
    #  address line 20 is tied low, so that addresses higher than
    #  1MB wrap around to zero by default. This code undoes this.

seta20.1:
    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    testb $0x2, %al
    jnz seta20.1

    movb $0xd1, %al                                 # 0xd1 -> port 0x64
    outb %al, $0x64                                 # 0xd1 means: write data to 8042's P2 port

seta20.2:
    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    testb $0x2, %al
    jnz seta20.2

    movb $0xdf, %al                                 # 0xdf -> port 0x60
    outb %al, $0x60                                 # 0xdf = 11011111, means set P2's A20 bit(the 1 bit) to 1
```
+ 初始化gdt表，使能cr0寄存器的PE位，此时从实模式进入保护模式，并长跳转更新cs基地址
```
    lgdt gdtdesc
    movl %cr0, %eax
    orl $CR0_PE_ON, %eax
    movl %eax, %cr0
    
    ljmp $PROT_MODE_CSEG, $protcseg
```
+ 设置段寄存器，并建立堆栈
```
    movw $PROT_MODE_DSEG, %ax                       # Our data segment selector
    movw %ax, %ds                                   # -> DS: Data Segment
    movw %ax, %es                                   # -> ES: Extra Segment
    movw %ax, %fs                                   # -> FS
    movw %ax, %gs                                   # -> GS
    movw %ax, %ss                                   # -> SS: Stack Segment

    # Set up the stack pointer and call into C. The stack region is from 0--start(0x7c00)
    movl $0x0, %ebp
    movl $start, %esp
```
+ 进入保护模式完成，进入bootmain
```
    call bootmain
```
<br>

## 练习4：分析bootloader加载ELF格式的OS的过程
1、bootloader是如何读取磁盘扇区的？
> * 用readsect函数读取磁盘扇区。readsect函数调用了waitdisk、outb、insl这三个基本磁盘操作。

```
static void
readsect(void *dst, uint32_t secno) {
    // wait for disk to be ready
    waitdisk();

    outb(0x1F2, 1);                         // count = 1
    outb(0x1F3, secno & 0xFF);
    outb(0x1F4, (secno >> 8) & 0xFF);
    outb(0x1F5, (secno >> 16) & 0xFF);
    outb(0x1F6, ((secno >> 24) & 0xF) | 0xE0);
    outb(0x1F7, 0x20);                      // cmd 0x20 - read sectors

    // wait for disk to be ready
    waitdisk();

    // read a sector
    insl(0x1F0, dst, SECTSIZE / 4);
}


<br>2、bootloader是如何加载ELF格式的OS？
> * 在bootmain函数中加载ELF格式的OS。

```
    // read the 1st page off disk
    readseg((uintptr_t)ELFHDR, SECTSIZE * 8, 0);

    // is this a valid ELF?
    if (ELFHDR->e_magic != ELF_MAGIC) {
        goto bad;
    }

    struct proghdr *ph, *eph;

    // load each program segment (ignores ph flags)
    ph = (struct proghdr *)((uintptr_t)ELFHDR + ELFHDR->e_phoff);
    eph = ph + ELFHDR->e_phnum;
    for (; ph < eph; ph ++) {
        readseg(ph->p_va & 0xFFFFFF, ph->p_memsz, ph->p_offset);
    }

    // call the entry point from the ELF header
    // note: does not return
    ((void (*)(void))(ELFHDR->e_entry & 0xFFFFFF))();
```
> * 先读出磁盘第一个扇区上的ELF Header，验证Header的正确性，再利用header里面的信息加载OS。

```
    	struct elfhdr {
        uint32_t e_magic;     // must equal ELF_MAGIC
        uint8_t e_elf[12];
        uint16_t e_type;      // 1=relocatable, 2=executable, 3=shared object, 4=core image
        uint16_t e_machine;   // 3=x86, 4=68K, etc.
        uint32_t e_version;   // file version, always 1
        uint32_t e_entry;     // entry point if executable
        uint32_t e_phoff;     // file position of program header or 0
        uint32_t e_shoff;     // file position of section header or 0
        uint32_t e_flags;     // architecture-specific flags, usually 0
        uint16_t e_ehsize;    // size of this elf header
        uint16_t e_phentsize; // size of an entry in program header
        uint16_t e_phnum;     // number of entries in program header or 0
        uint16_t e_shentsize; // size of an entry in section header
        uint16_t e_shnum;     // number of entries in section header or 0
        uint16_t e_shstrndx;  // section number that contains section name strings
	};
```
<<<<<<< HEAD
=======

>>>>>>> be3b5b5ad9e4123110a991a23f9a81a8b4fece1e
<br>
## 练习5：实现函数调用堆栈跟踪函数
> * 输出是

```
    ebp:0x00007b08 eip:0x001009a6 args:0x00010094 0x00000000 0x00007b38 0x00100092 
    kern/debug/kdebug.c:306: print_stackframe+21
    ebp:0x00007b18 eip:0x00100c95 args:0x00000000 0x00000000
    0x00000000 0x00007b88 
    kern/debug/kmonitor.c:125: mon_backtrace+10
    ebp:0x00007b38 eip:0x00100092 args:0x00000000 0x00007b60 0xffff0000 0x00007b64 
    kern/init/init.c:48: grade_backtrace2+33
    ebp:0x00007b58 eip:0x001000bb args:0x00000000 0xffff0000 0x00007b84 0x00000029 
    kern/init/init.c:53: grade_backtrace1+38
    ebp:0x00007b78 eip:0x001000d9 args:0x00000000 0x00100000 0xffff0000 0x0000001d 
    kern/init/init.c:58: grade_backtrace0+23
    ebp:0x00007b98 eip:0x001000fe args:0x0010341c 0x00103400 0x0000130a 0x00000000 
    kern/init/init.c:63: grade_backtrace+34
    ebp:0x00007bc8 eip:0x00100055 args:0x00000000 0x00000000 0x00000000 0x00010094 
    kern/init/init.c:28: kern_init+84
    ebp:0x00007bf8 eip:0x00007d68 args:0xc031fcfa 0xc08ed88e 0x64e4d08e 0xfa7502a8 
    <unknow>: -- 0x00007d67 --
```
> * 最后一行，各数字意义

```
    ebp表示bootmain栈底，bootloader设置堆栈起始地址
    为0x7c00，callbootmain 后即为0x7bf8eip表示返回
    地址其后四个为传入bootmain的参数，也可能并没有
    传入如此多的参数
```

<br>
## 练习6：完善中断初始化和处理
1、中断描述符表（也可简称为保护模式下的中断向量表）中一个表项占多少字节？其中哪几位代表中断处理代码的入口？
> * 一个表项字符占8字节大小，16~31位表示段描述符，0~15以及48~63位拼接表示偏移量，二者共同描述代码入口。

2、与参考答案区别
> * 在6.3中，参考答案可能会溢出，而我的代码在每次输出ticks后归零重新计数避免了溢出的可能。

<br>
##重要的知识点

> 中断描述符表。对应知识点：中断描述符表。含义：将每个异常或中断向量分别与它们的处理过程联系起来，记录它们的入口地址、特权级等信息的表。
