//
//  BottomToolViewButton.swift
//  DejingMaProject
//
//  Created by yolo on 2016/10/16.
//  Copyright © 2016年 DejingMa. All rights reserved.
//

import UIKit

class BottomToolViewButton: YLButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setTitleColor(UIColor.color(RGBHEX: 0x999999, alpha: 1.0), for: .normal)
        self.titleLabel?.font = UIFont(name: "PingFang-SC-Regular", size: 12)
        self.titleLabel?.textAlignment = .center
        self.imageViewFrame = CGRect(x: 11.25, y: 0, width: 40, height: 40)
        self.titleLabelFrame = CGRect(x: 0, y: 62.5-17, width: 62.5, height: 17)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
