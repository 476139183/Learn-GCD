//
//  ViewController.m
//  多线程
//
//  Created by Yutian Duan on 2019/8/16.
//  Copyright © 2019年 Wanwin. All rights reserved.
//

/*
 开辟新线程：
 主线程 1M
 子线程 512kb
 线程多了 线程之间的调度会消耗 cpu资源，  建议3-8条
 
 */
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  
  
  [self asyncSerial];
  
}


///! 串行队列 同步操作
- (void)syncSerial {
  
  dispatch_queue_t queue = dispatch_queue_create("com.syncSerial", DISPATCH_QUEUE_SERIAL);
  
  dispatch_sync(queue, ^{
    NSLog(@"1%@",[NSThread currentThread]);
  });
  
  dispatch_sync(queue, ^{
    NSLog(@"2%@",[NSThread currentThread]);
  });
  
  dispatch_sync(queue, ^{
    NSLog(@"3%@",[NSThread currentThread]);
  });
  
  NSLog(@"end%@",[NSThread currentThread]);

  /*
   同步操作，会阻塞当前线程， 首先 同步是不会创建线程的，所以会在当前线程执行，而当前线程为主线程。
   所以打印的顺序 是 "1" -> "2" -> "3" -> "end"
  
   */
  
}


///! 串行队列异步操作
- (void)asyncSerial {
  
  dispatch_queue_t queue = dispatch_queue_create("com.asyncSerial", DISPATCH_QUEUE_SERIAL);
  
  dispatch_async(queue, ^{
    NSLog(@"1%@",[NSThread currentThread]);
  });
  
  dispatch_async(queue, ^{
    NSLog(@"2%@",[NSThread currentThread]);
  });

  dispatch_async(queue, ^{
    NSLog(@"3%@",[NSThread currentThread]);
    [self performSelector:@selector(showLog) withObject:nil afterDelay:1];
  });

  NSLog(@"end%@",[NSThread currentThread]);
  
  /*
   异步操作，不会阻塞当前线程，将3个任务异步添加到 同一个串行队列时。其队列任务必须按序执行，所以只会开辟一条线程。  在队列的任务按次序在子线程中执行。
   所以理论上打印是 "end" - > "1" - > "2" - > "3"。
   而我们发现，showlog 的任务并没有执行，这个和 performSelector 的方法实现有关，暂表不提。
   
   ps:如果我们三个任务分别加入到三个不同串行队列，那么就会开辟三个线程对任务进行异步处理，无序打印
   
   */
  
  
}


#pragma private methods

- (void)showLog {
  NSLog(@"showLogo%@",[NSThread currentThread]);
}

@end
