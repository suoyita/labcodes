# Lab5

### 计32 程凯 2013011303
<br>
## 练习1 加载应用程序并执行
<br>

###请在实验报告中简要说明你的设计实现过程

> 加载应用程序需要正确地设置栈帧：

```
     * NOTICE: If we set trapframe correctly, then the user level process can return to USER MODE from kernel. So
     *          tf_cs should be USER_CS segment (see memlayout.h)
     *          tf_ds=tf_es=tf_ss should be USER_DS segment
     *          tf_esp should be the top addr of user stack (USTACKTOP)
     *          tf_eip should be the entry point of this binary program (elf->e_entry)
     *          tf_eflags should be set to enable computer to produce Interrupt
```

练习1.1 当创建一个用户态进程并加载了应用程序后，CPU是如何让这个应用程序最终在用户态执行起来的。即这个用户态进程被ucore选择占用CPU执行（RUNNING态）到具体执行应用程序第一条指令的整个经过。

> * init_main调用kernel_thread，再do_fork复制一个内核线程user_main
> * user_main调用kernel_execve产生SYS_exec系统调用
> * 系统调用经由trap，调用sys_exec，并调用do_execve
> * do_execve释放页表、内存空间，调用load_icode加载ELF格式程序
> * load_icode读取ELF文件、建立页表及堆栈，构造trap_frame的用户态
> * 内核线程对应的用户进程被唤醒吼，用户进程运行，context的eip指向forkret，调用trapentry.S中>的__trapret，并调用iret进入用户态
> * 此时trap_frame的eip对应程序第一条指令


## 练习2 父进程复制自己的内存空间给子进程

练习2.0 请补充copy_range的实现，确保能够正确执行

> * void *src_kvaddr = page2kva(page);
> * void *dst_kvaddr = page2kva(npage);
> * memcpy(dst_kvaddr, src_kvaddr, PGSIZE);
> * ret = page_insert(to, npage, start, perm);

练习2.1 请在实验报告中简要说明如何设计实现”Copy on Write 机制“，给出概要设计，鼓励给出详细设计。

> 在dup_mmap中复制mm_struct的时候，直接复制vma的指针，并将对应页的引用计数加一，把页设为只读。两个mm_struct共享同一份vma列表，没有发生真实的内存复制。发生缺页的时候，如果引用计数大于1，说明有多个进程共享同一个只读页。此时复制物理页（新构建的物理页引用计数为1，可写），让当前进程的页表指向新的页。原来的页的引用计数减一，如果减到了1，那么将那一页设为可写。

## 练习3 阅读分析源代码，理解进程执行 fork/exec/wait/exit 的实现，以及系统调用的实现

练习3.1 请分析fork/exec/wait/exit在实现中是如何影响进程的执行状态的？

> * fork:fork函数实现的是进程的创建过程，它从父进程进行赋值生成了一个子进程
> * exec:exe函数实现的是函数是把进程进行运行的函数，它通过load_icode等可以进行把进程设置为运行的过程
> * wait:wait函数可以把进程设置为等待状态
> * exit:进程退出或者被杀死

练习3.2 请给出ucore中一个用户态进程的执行状态生命周期图（包执行状态，执行状态之间的变换关系，以及产生变换的事件或函数调用）。（字符方式画即可）

```
PROC_UNINIT(创建)                       PROC_ZOMBIE(结束)
      |                                        ^
      | do_fork                                | do_exit
      v                schedule                |
PROC_RUNNABLE(就绪)-------------------> PROC_RUNNING(运行)
      ^                                        |
      |                                        | do_wait
      |              wakeup_proc               v
      --------------------------------- PROC_SLEEPING(等待)
```

## 与参考答案的区别：

> LAB1中我T_SYSCALL是在用户态访问的中断，将其设置为特权级3。


## 重要的知识点

> fork

> 对应知识点：fork

> 含义：复制一个几乎一样的进程，它们各自拥有独立的用户内存空间。在父进程中返回子进程ID，在子进程中返回0。如果出现错误，返回负值。

> 关系：从多个角度理解同一个函数

> 差异：OS原理中，主要讲fork产生的行为、结果。实验中，主要需要知道fork怎么实现，具体需要复制哪些成员，需要修改哪些成员。
