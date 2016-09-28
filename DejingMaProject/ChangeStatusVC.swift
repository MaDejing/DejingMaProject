//
//  ChangeStatusVC.swift
//  DejingMaProject
//
//  Created by DejingMa on 16/9/28.
//  Copyright © 2016年 DejingMa. All rights reserved.
//

import UIKit

extension UINavigationController {
	override open var childViewControllerForStatusBarStyle: UIViewController? {
		return self.topViewController
	}
}

class ChangeStatusVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		let rightItem = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
		rightItem.tintColor = UIColor.red
		navigationItem.rightBarButtonItem = rightItem
		
		let pushButton = UIButton.init(type: .custom)
		pushButton.frame = CGRect(x: 20, y: 100, width: 200, height: 50)
		pushButton.backgroundColor = UIColor.red
		pushButton.addTarget(self, action: #selector(pushVC), for: .touchUpInside)
		
		view.addSubview(pushButton)
		
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	func cancel() {
		dismiss(animated: true, completion: nil)
	}
	
	func pushVC() {
		let vc = storyboard?.instantiateViewController(withIdentifier: "DoubleScrollVC") as! DoubleScrollVC
		navigationController?.pushViewController(vc, animated: true)
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
