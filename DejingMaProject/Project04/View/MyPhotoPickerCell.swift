//
//  MyPhotoPickerCell.swift
//  PhotoKitTest
//
//  Created by DejingMa on 16/9/7.
//  Copyright © 2016年 DejingMa. All rights reserved.
//

import Foundation
import UIKit
import Photos

class MyPhotoPickerCell: UITableViewCell {
	
	fileprivate var m_imageView: UIImageView!
	fileprivate var m_title: UILabel!
	fileprivate var m_count: UILabel!
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
//		layoutMargins = UIEdgeInsets.zero
		initSubViews()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	static func getCellHeight() -> CGFloat {
		return 80.0
	}
	
	static func getCellIdentifier() -> String {
		return "myPhotoPickerCell"
	}
	
	func initSubViews() {
		m_imageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 70, height: 70))
		m_imageView.contentMode = .scaleAspectFill
		m_imageView.layer.masksToBounds = true
		
		m_title = UILabel(frame: CGRect(x: 95, y: 0, width: kScreenWidth-95, height: 30))
		m_title.center.y = 40

		contentView.addSubview(m_imageView)
		contentView.addSubview(m_title)
	}
	
	func updateRowWithData(_ data: MyPhotoAlbumItem) {
		
		let title = NSMutableAttributedString()
		
		let nameDic = [NSFontAttributeName: UIFont.getFont(name: "PingFang-SC-Regular", size: 17), NSForegroundColorAttributeName: UIColor.black]
		let name = NSAttributedString(string: data.m_title, attributes: nameDic)
		title.append(name)
		
		let content: PHFetchResult = data.m_content
		let countDic = [NSFontAttributeName: UIFont.getFont(name: "PingFang-SC-Regular", size: 15), NSForegroundColorAttributeName: UIColor.gray]
		let count = NSAttributedString(string: "(\(content.count))", attributes: countDic)
		title.append(count)
		
		m_title.attributedText = title
		
		let lastAssert = content.lastObject as! PHAsset
		let imageWidth = MyPhotoPickerCell.getCellHeight()-10
		let size = CGSize(width:imageWidth * 2.0, height: imageWidth * 2.0)
		
		PHImageManager.default().requestImage(for: lastAssert, targetSize: size, contentMode: .aspectFill, options: nil) {
			[weak self] (image, _) in
			
			guard let weakSelf = self else { return }
			weakSelf.m_imageView.image = image
		}
	}
	
}
