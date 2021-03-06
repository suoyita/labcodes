# Lab7

###计32 程凯 2013011303

## [练习0] 填写已有实验

> 已完成

## [练习1] 理解内核级信号量的实现和基于内核级信号量的哲学家就餐问题

###练习1.1 请在实验报告中给出内核级信号量的设计描述，并说其大致执行流流程。

> 内核级信号量的定义：

```
typedef struct {
    int value;
    wait_queue_t wait_queue;
} semaphore_t;
```

> value就是信号量的值，wait_queue是等待队列，当P操作后，如果等待队列非空，那么会唤醒其中一个。它有四个方法，分别是初始化（sem_init）、P操作（up）、V操作（down）和非阻塞的V操作（try_down）：

```
void sem_init(semaphore_t *sem, int value);
void up(semaphore_t *sem);
void down(semaphore_t *sem);
bool try_down(semaphore_t *sem);
```

> 初始化、P操作、V操作与理论课上讲的是一样的，不再赘述。实验里主要增加了一个非阻塞的V操作（try_down），如果信号量大于0，那么减一，返回true；如果信号量小于或等于0，那么返回false，表示V操作失败。这个功能也是很有用的。

###练习1.2 请在实验报告中给出给用户态进程/线程提供信号量机制的设计方案，并比较说明给内核级提供信号量机制的异同。

> 可以借鉴内核态的信号量机制<br>
用户态的信号量托管在内核态中，但对用户不可见，即用户使用过程体验与在用户态中一样<br>
需要使用信号量时，通过中断从用户态跳转到内核态，维护信号量，再反馈到用户态<br><br>

> 不同：为用户态提供信号量需要用系统调用来实现，需要在用户态和内核态之间切换，可能造成效率比较低下。

> 相同：都提供了完整的信号量机制，对用户的接口可以封装成相同的。

## [练习2] 完成内核级条件变量和基于内核级条件变量的哲学家就餐问题

[练习2.1] 请在实验报告中给出内核级条件变量的设计描述，并说其大致执行流流程。

> * moniter.c的cond_signal
		* 按照提示填写即可，下同
		* 父monitor可通过cvp->owner获得
		* 先up自身，再down下一进程即可
	 * moniter.c的cond_wait
		* 根据等待数量next_count确定up哪个信号量
		* 再down自身即可
	 * check_sync.c的phi_take_forks_condvar
		* 先设自己为hungry
		* 再调用phi_test_condvar来确定自己是否可以变为eating
		* 如果还不能就餐，则cond_wait进入等待
	* check_sync.c的phi_put_forks_condvar
		* 先设自己吃完了，为thinking
		* 这时候左右刀叉可以释放，调用phi_test_condvar处理左右邻居即可


###练习2.2 请在实验报告中给出给用户态进程/线程提供条件变量机制的设计方案，并比较说明给内核级提供条件变量机制的异同。

> 增加一个系统调用SYS_COND。SYS_COND有两个参数，第一个参数是要做的操作（例如signal为0，wait为1），第二个变量是信号量的地址。遇到这个系统调用的时候，根据第一个参数来选择调用cond_signal还是cond_wait。

> 不同：为用户态提供条件变量需要用系统调用来实现，需要在用户态和内核态之间切换，可能造成效率比较低下。

> 相同：都提供了完整的条件变量机制，对用户的接口可以封装成相同的。

## 与参考答案的区别：

> 哲学家就餐部分，思路一致，具体实现不一样

## 重要的知识点

* 信号量的具体数据结构
* 同步互斥架构
* 哲学家问题的具体解决细节

> 区别： 管程具体实现
