//
//  HitTestScrollView.swift
//  DejingMaProject
//
//  Created by DejingMa on 16/9/29.
//  Copyright © 2016年 DejingMa. All rights reserved.
//

import UIKit

class HitTestScrollView: UIScrollView {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        for subView in self.subviews.reversed() {
            let newPoint = subView.convert(point, from: self)
            
            let hitView = subView.hitTest(newPoint, with: event)
            if hitView != nil {
                return hitView!
            }
        }
        
        return super.hitTest(point, with: event)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
