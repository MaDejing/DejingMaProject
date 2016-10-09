//
//  GCDViewController.swift
//  DejingMaProject
//
//  Created by DejingMa on 16/10/8.
//  Copyright © 2016年 DejingMa. All rights reserved.
//

import UIKit
import Foundation

class GCDViewController: UIViewController {
	@IBOutlet weak var timeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		NSLog("start - %@", Thread.main)
		
		/// 1. main queue 
		// 它是由系统创建并全局可见的；它是一个serial queue；它的task都是在main thread运行的。
		// 在main queue中，任务虽然会加到主线程中执行，但是如果主线程里也有任务就必须等主线程任务执行完才轮到主队列的，所以sync会死锁。
		
//		DispatchQueue.main.async {
//			NSLog("(async in main queue) %@", Thread.current)
//		}
//		NSLog("after (主队列中async不会新开启线程) - %@", Thread.current)

//		DispatchQueue.main.sync {
//			NSLog("(sync in main queue) %@", Thread.current)
//		}
//		NSLog("after sync - %@", Thread.current)
		////////////////////////////////////////////////////////////
		

		/// 2. 串行 并行 同步 异步
		// serial 和 concurrent 的区别，serial queue中的task是等上一个执行完了才执行下一个, 而concurrent queue中的task虽然也是FIFO的, 但不等上一个task执行下, 下一个task或许就执行了。
		// sync 和 async 的区别就是sync会（阻塞当前线程，并等待前一个任务完成才能继续下一个任务）。

		let myQueue1 = DispatchQueue.init(label: "myQueue1")
		let myQueue2 = DispatchQueue.init(label: "myQueue2", attributes: .concurrent)
		// 2.1. 串行中使用同步
//		myQueue1.sync {
//			NSLog("(sync in serial queue) %@", Thread.current)
//		}
//		NSLog("after sync in serial queue - %@", Thread.current)
		
		// 2.2. 串行中使用异步
//		for i in 0 ..< 10 {
//			myQueue1.async {
//				NSLog("(async %d in serial queue) %@", i, Thread.current)
//			}
//		}
//		Thread.sleep(forTimeInterval: 0.001)
//		NSLog("after async in serial queue - %@", Thread.current)
		
		// 2.3. 并行中使用同步  结果与2.1 相同
		// 因为同步任务的概念就是按顺序执行，后面都要等。言外之意就是不允许多开线程。
//		myQueue2.sync {
//			NSLog("(sync in concurrent queue) %@", Thread.current)
//		}
//		NSLog("after sync in concurrent queue - %@", Thread.current)
		
		// 2.4. 并行中使用异步
		// 与2.2的区别在于，串行队列中循环async但只开启了一条新线程，而并行队列中，每次async可能都开启一条新线程。并且2.4中是并发所以乱序。
//		for i in 0 ..< 10 {
//			myQueue2.async {
//				NSLog("(async %d in concurrent queue) %@", i, Thread.current)
//			}
//		}
//		Thread.sleep(forTimeInterval: 0.001)
//		NSLog("after async in concurrent queue - %@", Thread.current)
		
		// 2.5. 同步 异步 嵌套
		// sync后将通过async开启的线程被阻塞，block中任务前的任务被阻塞未完成。
		// 如果myQueue是串行队列，那么一次只能一个任务，sync又必须在前一个任务完成后才能进行block中的任务，但是那个任务被sync阻塞了，所以造成死锁。
		// 如果myQueue是并行队列，可以多任务进行，所以可以完成sync中的任务。
		
//		let myQueue = DispatchQueue.init(label: "myQueue", attributes: .concurrent)
//		NSLog("1.之前 - %@", Thread.current)
//		
//		myQueue.async {
//			NSLog("(2.or 3.此处开启一条新线程)sync之前 - %@", Thread.current)
//
//			myQueue.sync {
//				NSLog("4.sync - %@", Thread.current)
//			}
//			NSLog("5.sync之后 - %@", Thread.current)
//		}
//
//		NSLog("(2.or 3.此处有两条线程，打印先后顺序不定)之后 - %@", Thread.current)
		////////////////////////////////////////////////////////////
		
		
		/// 3. dispatch_after
		// 在x秒后把任务追加到队列中，并不是在x秒后执行。
		// 当后续操作时间 > 3s时，后续操作一结束就会立即执行block里的代码，反之则会在start后3s时执行。
//		let delay = DispatchTime.now() + 3.0
//		DispatchQueue.main.asyncAfter(deadline: delay) {
//			NSLog("waited at least three seconds.")
//		}
//		
//		Thread.sleep(forTimeInterval: 0)
		////////////////////////////////////////////////////////////
		
		
		/// 4. dispatch_group
//		let queue = DispatchQueue.global()
//		let group = DispatchGroup()
		
		// 4.1. dispatch_group_notify
//		queue.async(group: group) {
//			NSLog("block 1")
//		}
//		
//		queue.async(group: group) {
//			NSLog("block 2")
//		}
//		
//		queue.async(group: group) {
//			NSLog("block 3")
//		}
//		
//		group.notify(queue: DispatchQueue.main) { 
//			NSLog("结束")
//		}
//		
//		NSLog("不阻塞1")
//		NSLog("不阻塞2")
//		NSLog("不阻塞3")
		
		// 4.2. dispatch_group_wait
//		queue.async(group: group) {
//			NSLog("block 1")
//		}
//		
//		queue.async(group: group) {
//			NSLog("block 2")
//		}
//		
//		queue.async(group: group) {
//			Thread.sleep(forTimeInterval: 2.0)
//			NSLog("block 3")
//		}
//		
//		let result = group.wait(timeout: DispatchTime.distantFuture)
//		if result == .success {
//			group.notify(queue: DispatchQueue.main) {
//				NSLog("结束")
//			}
//		}
//		
//		NSLog("阻塞1")
//		NSLog("阻塞2")
//		NSLog("阻塞3")
		////////////////////////////////////////////////////////////
		
		
		/// 5. dispatch_apply
//		DispatchQueue.global().async {
//			NSLog("concurrentPerform中是并发，所以是乱序的 - %@", Thread.current)
//			
//			DispatchQueue.concurrentPerform(iterations: 3, execute: { (index) in
//				NSLog("%d - %@", index, Thread.current)
//			})
//			
//			NSLog("此函数会等待处理执行结束 - %@", Thread.current)
//		}
//		
//		NSLog("不阻塞 - %@", Thread.current)
		////////////////////////////////////////////////////////////
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
