//
//  MySelectPhotoDoneButton.swift
//  DejingMaProject
//
//  Created by DejingMa on 16/10/17.
//  Copyright © 2016年 DejingMa. All rights reserved.
//

import UIKit

class MySelectPhotoDoneButton: YLButton {

	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.titleLabelFrame = self.bounds
		self.titleLabel?.font = UIFont(name: "PingFang-SC-Regular", size: 14)
		self.titleLabel?.textAlignment = .left
		self.setTitleColor(UIColor.white, for: .normal)
		self.setTitleColor(UIColor.lightGray, for: .disabled)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func updateView() {		
		let selectedCount = MyPhotoSelectManager.defaultManager.m_selectedItems.count
		let title = selectedCount > 0 ? "完成(\(selectedCount))" : "完成"
		self.setTitle(title, for: .normal)
	}
}
