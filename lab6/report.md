# Lab6
计32 程凯 2013011303
## [练习0] 填写已有实验

> 已完成

## [练习1] 使用 Round Robin 调度算法

###练习1.1 
请理解并分析sched_calss中各个函数指针的用法，并接合Round Robin 调度算法描ucore的调度执行过程

init：初始化队列，将队列置为空<br>
enqueue：将进程加入队列<br>
        dequeue：将进程从队列中移除<br>
        pick_next：从队列中选出下一个执行的进程，即调度过程的实现<br>
        proc_tick：控制时间，设置是否需要调度

        当发生时钟事件时，调用run_timmer_list()，其中会调用到proc_tick()更新时间片，还会唤醒需要唤醒的进程，用en

###练习1.2 请在实验报告中简要说明如何设计实现”多级反馈队列调度算法“，给出概要设计，鼓励给出详细设计

> 概要设计：有一个队列的列表，它是队列的总调度器，由它决定从哪个队列里pick_next作为切换到的进程。可以有多个队列，它的功能可能就是实现一个“Round Robin调度算法”或“Stride Scheduling调度算法”。“总调度器”把一个进程绑定在哪个队列上，那么对这个进程的`enqueue`、`dequeue`都由相应的队列执行。发生`proc_tick`时，应该调用上一次选出切换进程的队列的`proc_tick`。

## [练习2] 实现 Stride Scheduling 调度算法

###练习2.0 请在实验报告中简要说明你的设计实现过程

实现过程：<br>
    1、BIG_STRIDE:设为最大int值0x7FFFFFFF<br>
    2、init:将队列置空，计数置为0<br>
    3、enqueue:将proc加入队列，检查并设置它的time_slice，rq，最后将proc_num加1<br>
    4、dequeue:将proc移除队列，并将proc_num减1<br>
    5、pick_next:用le2proc从rq->lab6_run_pool中选出合适的进程，并设置增加其lab6_stride BIG_STRIDE/p->lab6_priority，如果进程优先级是0，则将其视为1<br>
    6、proc_tick:减少其time_slice，若归零则重新调度

## 与参考答案的区别：

思路一致，细节有区别
## 重要的知识点

> - Round Robin调度算法；

> - Stride Scheduling调度算法；

> - 多级反馈队列调度算法；


