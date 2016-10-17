//
//  MyPhotoSelectCountView.swift
//  DejingMaProject
//
//  Created by DejingMa on 16/10/17.
//  Copyright © 2016年 DejingMa. All rights reserved.
//

import UIKit

class MyPhotoSelectCountView: UIView {
	
	fileprivate var m_selectedBgView: UIView!
	var m_selectButton: YLButton!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.backgroundColor = UIColor.clear
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	convenience init(frame: CGRect, bgViewFrame: CGRect) {
		self.init(frame: frame)
		
		m_selectedBgView = UIView(frame: bgViewFrame)
		m_selectedBgView.layer.cornerRadius = bgViewFrame.width*0.5
		m_selectedBgView.layer.borderWidth = 1.0
		m_selectedBgView.layer.masksToBounds = false
		
		m_selectButton = YLButton(frame: bounds)
		m_selectButton.titleLabelFrame = bgViewFrame
		
		m_selectButton.setTitle("", for: .normal)
		m_selectButton.setTitleColor(UIColor.color(RGBHEX: 0x151518, alpha: 1.0), for: .selected)
		
		m_selectButton.titleLabel?.font = UIFont.getFont(name: "PingFang-SC-Regular", size: 15)
		m_selectButton.titleLabel?.textAlignment = .center
		
		self.addSubview(m_selectedBgView)
		self.addSubview(m_selectButton)

	}
	
	func updateSubViews(selected: Bool, title: String) {
		m_selectButton.setTitle(title, for: .selected)

		if selected {
			m_selectedBgView.backgroundColor = UIColor.color(RGBHEX: 0xffdd00, alpha: 1.0)
			m_selectedBgView.layer.borderColor = UIColor.clear.cgColor
		} else {
			m_selectedBgView.backgroundColor = UIColor.color(RGBHEX: 0x000000, alpha: 0.2)
			m_selectedBgView.layer.borderColor = UIColor.init(white: 1.0, alpha: 0.9).cgColor
		}
	}
}
