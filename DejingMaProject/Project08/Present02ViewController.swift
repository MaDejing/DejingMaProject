//
//  Present02ViewController.swift
//  DejingMaProject
//
//  Created by DejingMa on 16/10/21.
//  Copyright © 2016年 DejingMa. All rights reserved.
//

import UIKit

class Present02ViewController: UIViewController {

	static let myNotification = Notification.Name("rootDismiss")
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		view.backgroundColor = UIColor.yellow
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@objc fileprivate func cancel() {
//		dismiss(animated: true, completion: nil)
		NotificationCenter.default.post(name: Present02ViewController.myNotification, object: self, userInfo: ["hhh": "lll"])
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
