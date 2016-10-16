//
//  BottomToolViewConfig.swift
//  DejingMaProject
//
//  Created by yolo on 2016/10/16.
//  Copyright © 2016年 DejingMa. All rights reserved.
//

struct BottomToolViewConfig {
    fileprivate var _height: CGFloat
    
    init() {
        _height = 95
    }
}

extension BottomToolViewConfig {
    var height: CGFloat {
        set { _height = newValue }
        get { return _height }
    }
}
