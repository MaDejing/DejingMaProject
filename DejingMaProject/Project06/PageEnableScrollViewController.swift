//
//  PageEnableScrollViewController.swift
//  DejingMaProject
//
//  Created by yolo on 2016/10/15.
//  Copyright © 2016年 DejingMa. All rights reserved.
//

import UIKit

class PageEnableScrollViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        /// pagingEnable每次滑过一个scrollView的宽度
        let scrollView = UIScrollView(frame: UIScreen.main.bounds)
        scrollView.isPagingEnabled = true
//        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.contentSize = CGSize(width: 900, height: kScreenHeight-64)
        view.addSubview(scrollView)
        
        let view0 = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: scrollView.frame.height))
        view0.backgroundColor = UIColor.red
        scrollView.addSubview(view0)
        
        let view1 = UIView(frame: CGRect(x: 200, y: 0, width: 300, height: scrollView.frame.height))
        view1.backgroundColor = UIColor.blue
        scrollView.addSubview(view1)
        
        let view2 = UIView(frame: CGRect(x: 500, y: 0, width: 400, height: scrollView.frame.height))
        scrollView.backgroundColor = UIColor.color(RGBHEX: 0xffdd00, alpha: 1.0)
        scrollView.addSubview(view2)
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
