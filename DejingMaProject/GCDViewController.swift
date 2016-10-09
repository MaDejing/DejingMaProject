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
		
		DispatchQueue.main.async {
			NSLog("(async in main queue) %@", Thread.current)
		}
		NSLog("after (主队列中async不会新开启线程) - %@", Thread.current)

		
//		let myQueue = DispatchQueue.init(label: "myQueue", attributes: .concurrent)
//		NSLog("1.之前 - %@", Thread.current)
//		
//		myQueue.async {
//			NSLog("(2. or 3. 此处开启一条新线程)sync之前 - %@", Thread.current)
//			
//			//sync后将通过async开启的线程被阻塞，sync前的任务被阻塞未完成。
//		    //如果myQueue是串行队列，那么一次只能一个任务，sync又必须在前一个任务完成后才能进行block中的任务，但是那个任务被sync阻塞了，所以造成死锁。
//		    //如果myQueue是并行队列，可以多任务进行，所以可以完成sync中的任务。
//			myQueue.sync {
//				NSLog("4.sync - %@", Thread.current)
//			}
//			NSLog("5.sync之后 - %@", Thread.current)
//		}
//
//		NSLog("(2. or 3. 此处有两条线程，打印先后顺序不定)之后 - %@", Thread.current)
		
		/// dispatch_after
		/// 在x秒后把任务追加到队列中，并不是在x秒后执行。当休眠时间 > 3s时，一休眠完就会立即执行block里的代码，反之则会在start后3s时执行。
//		let delay = DispatchTime.now() + 3.0
//		DispatchQueue.main.asyncAfter(deadline: delay) {
//			NSLog("waited at least three seconds.")
//		}
//		
//		Thread.sleep(forTimeInterval: 0)
		////////////////////////////////////////////////////////////
		
		/// dispatch_group
//		let queue = DispatchQueue.global()
//		let group = DispatchGroup()
		
		// dispatch_group_notify
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
		
		// dispatch_group_wait
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
		
		/// dispatch_apply
//		DispatchQueue.global().async {
//			NSLog("异步开始")
//			
//			DispatchQueue.concurrentPerform(iterations: 3, execute: { (index) in
//				Thread.sleep(forTimeInterval: TimeInterval(index))
//				NSLog(String(index))
//			})
//			
//			NSLog("阻塞")
//		}
//		
//		NSLog("不阻塞")
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
