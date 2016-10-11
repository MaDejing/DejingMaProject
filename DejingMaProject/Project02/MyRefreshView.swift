//
//  MyRefreshView.swift
//  DejingMaProject
//
//  Created by DejingMa on 16/9/29.
//  Copyright © 2016年 DejingMa. All rights reserved.
//

import Foundation
import UIKit

class MyRefreshView: UIView {
	
	override func layoutSubviews() {
		backgroundColor = UIColor.clear
		setupFrame(in: superview)
		
		super.layoutSubviews()
	}
	
	override func willMove(toSuperview newSuperview: UIView?) {
		super.willMove(toSuperview: newSuperview)
		setupFrame(in: superview)
	}
	
	func setupFrame(in newSuperview: UIView?) {
		guard let superview = newSuperview else { return }
		
		frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: superview.frame.width, height: frame.height)
	}

}
