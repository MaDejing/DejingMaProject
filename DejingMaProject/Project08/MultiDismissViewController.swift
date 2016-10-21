//
//  MultiDismissViewController.swift
//  DejingMaProject
//
//  Created by DejingMa on 16/10/20.
//  Copyright © 2016年 DejingMa. All rights reserved.
//

import UIKit

class MultiDismissViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.view.backgroundColor = UIColor.white

        // Do any additional setup after loading the view.
		let button = UIButton(type: .custom)
		button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
		button.center = view.center
		button.setTitle("开始多个present", for: .normal)
		button.setTitleColor(UIColor.black, for: .normal)
		button.addTarget(self, action: #selector(MultiDismissViewController.multiPresent(sender:)), for: .touchUpInside)
		
		view.addSubview(button)
		
		NotificationCenter.default.addObserver(self, selector: #selector(rootDismiss(noti:)), name: Present02ViewController.myNotification, object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	@objc fileprivate func rootDismiss(noti: Notification) {
		print(noti.userInfo)
		
		dismiss(animated: true, completion: nil)
	}
	
	@objc fileprivate func multiPresent(sender: UIButton) {
		let vc1 = Present01ViewController()
				
		let nav = UINavigationController(rootViewController: vc1)
		present(nav, animated: true, completion: nil)
	}
	
}
