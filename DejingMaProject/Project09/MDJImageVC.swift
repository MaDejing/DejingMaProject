//
//  MDJImageVC.swift
//  DejingMaProject
//
//  Created by DejingMa on 16/11/9.
//  Copyright © 2016年 DejingMa. All rights reserved.
//

import UIKit

class MDJImageVC: UIViewController {

	fileprivate var m_imageView: MDJImageView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		view.backgroundColor = UIColor.white
		
		let button = UIButton(frame: CGRect(x: 20, y: 100, width: 200, height: 50))
		button.setTitle("点击出现大图", for: .normal)
		button.setTitleColor(UIColor.black, for: .normal)
		button.addTarget(self, action: #selector(showImageView(_:)), for: .touchUpInside)
		
		view.addSubview(button)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	@objc fileprivate func showImageView(_ sender: UIButton) {
		m_imageView = MDJImageView(frame: CGRect(x: 50, y: 100, width: 300, height: 300), mode: .aspectFit, maxZoomScale: 2.0, minZoomScale: 0.5)
		m_imageView.updateWithImage(UIImage(named: "image01")!)
		
		m_imageView.m_delegate = self
		
		view.addSubview(m_imageView)
	}

}

extension MDJImageVC: MDJImageViewDelegate {
	func afterSingleTap(_ view: MDJImageView) {
		m_imageView.removeFromSuperview()
	}
}
