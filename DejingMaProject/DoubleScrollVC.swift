//
//  DoubleScrollVC.swift
//  DejingMaProject
//
//  Created by DejingMa on 16/9/28.
//  Copyright © 2016年 DejingMa. All rights reserved.
//

import UIKit

class DoubleScrollVC: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerViewTop: NSLayoutConstraint!
    @IBOutlet weak var scrollViewA: UIScrollView!
    @IBOutlet weak var scrollViewB: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        for ges in scrollViewA.gestureRecognizers! {
            scrollViewA.removeGestureRecognizer(ges)
        }
        
        for ges in scrollViewB.gestureRecognizers! {
            scrollViewA.addGestureRecognizer(ges)
        }
        
        scrollViewB.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.setNavigationBarHidden(true, animated: true)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		navigationController?.setNavigationBarHidden(false, animated: true)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension DoubleScrollVC {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let offset: CGPoint = scrollViewB.contentOffset
        headerViewTop.constant = -max(offset.y, 0)
    }
}

extension DoubleScrollVC {
    @IBAction func popVC(_ sender: AnyObject) {
		_ = navigationController?.popViewController(animated: true)
	}
    
    @IBAction func onClick1(_ sender: AnyObject) {
        print("onClick1")
    }

    @IBAction func onClick2(_ sender: AnyObject) {
        print("onClick2")
    }
    
    @IBAction func onClick3(_ sender: AnyObject) {
        print("onClick3")
    }
    
    @IBAction func onClick4(_ sender: AnyObject) {
        print("onClick4")
    }
}
