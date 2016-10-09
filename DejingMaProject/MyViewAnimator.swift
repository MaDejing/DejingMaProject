//
//  MyViewAnimator.swift
//  DejingMaProject
//
//  Created by DejingMa on 16/9/29.
//  Copyright © 2016年 DejingMa. All rights reserved.
//

import Foundation
import UIKit

class MyViewAnimator: RefreshViewAnimator {
	fileprivate let animateView: UIView
	
	init(animateView: UIView) {
		self.animateView = animateView
	}
	
	func animate(_ state: State) {
		switch state {
		case .initial: break
//			refreshView.activityIndicator.stopAnimating()
			
		case .releasing(_): break
//			refreshView.activityIndicator.isHidden = false
//			
//			var transform = CGAffineTransform.identity
//			transform = transform.scaledBy(x: progress, y: progress)
//			transform = transform.rotated(by: CGFloat(M_PI) * progress * 2)
//			refreshView.activityIndicator.transform = transform
			
		case .loading: break
//			refreshView.activityIndicator.startAnimating()
			
		default: break
		}
	}
}
