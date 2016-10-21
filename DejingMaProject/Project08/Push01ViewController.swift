//
//  Push01ViewController.swift
//  DejingMaProject
//
//  Created by DejingMa on 16/10/21.
//  Copyright © 2016年 DejingMa. All rights reserved.
//

import UIKit

class Push01ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		view.backgroundColor = UIColor.red
		
		let button = UIButton(type: .custom)
		button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
		button.center = view.center
		button.setTitle("present一个新的", for: .normal)
		button.setTitleColor(UIColor.black, for: .normal)
		button.addTarget(self, action: #selector(Push01ViewController.presentVC2(sender:)), for: .touchUpInside)
		
		view.addSubview(button)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@objc fileprivate func presentVC2(sender: UIButton) {
		let vc = Present02ViewController()
		let nav = UINavigationController(rootViewController: vc)
		nav.navigationBar.isTranslucent = true
		
		present(nav, animated: true, completion: nil)
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
