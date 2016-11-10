//
//  MDJImageVC.swift
//  DejingMaProject
//
//  Created by DejingMa on 16/11/9.
//  Copyright © 2016年 DejingMa. All rights reserved.
//

import UIKit

class MDJImageVC: UIViewController {

	fileprivate var m_imageView: MDJScrollImageView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		view.backgroundColor = UIColor.white
		
		let button = UIButton(frame: CGRect(x: 20, y: 100, width: 200, height: 50))
		button.setTitle("点击出现大图", for: .normal)
		button.setTitleColor(UIColor.black, for: .normal)
		button.addTarget(self, action: #selector(showImageView(_:)), for: .touchUpInside)
		
		view.addSubview(button)
        
        let button2 = UIButton(frame: CGRect(x: kScreenWidth-100, y: 100, width: 100, height: 50))
        button2.setTitle("随机切换", for: .normal)
        button2.setTitleColor(UIColor.black, for: .normal)
        button2.addTarget(self, action: #selector(changeMode), for: .touchUpInside)
        view.addSubview(button2)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	@objc fileprivate func showImageView(_ sender: UIButton) {
        m_imageView = MDJScrollImageView(frame: CGRect(x: 0, y: 300, width: 200, height: 300), mode: .fitWidth, maxZoomScale: 2.0, minZoomScale: 0.5)
		m_imageView.setWithImage(name: "image01")

        m_imageView.show(superView: view, startRect: CGRect(x: 20, y: 100, width: 200, height: 50))
//        m_imageView.show(superView: view)
    }

    @objc fileprivate func changeMode() {
        m_imageView.setMode(mode: MDJScrollImageViewMode(rawValue: Int(arc4random_uniform(4)))!)
    }
}
