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
    
    let cellHeight: CGFloat = 64.0
    
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
//		layoutMargins = UIEdgeInsets.zero
        self.backgroundColor = UIColor.color(RGBHEX: 0x27272D, alpha: 1.0)
        
        self.selectionStyle = .none
        
		initSubViews()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	static func getCellHeight() -> CGFloat {
		return 64.0
	}
	
	static func getCellIdentifier() -> String {
		return "myPhotoPickerCell"
	}
	
	func initSubViews() {
		m_imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: cellHeight, height: cellHeight))
		m_imageView.contentMode = .scaleAspectFill
		m_imageView.layer.masksToBounds = true
		
		m_title = UILabel(frame: CGRect(x: cellHeight+10, y: 0, width: kScreenWidth-cellHeight-10-23, height: 30))
		m_title.center.y = cellHeight*0.5
        
        let accessory = UIImageView(frame: CGRect(x: kScreenWidth-8-15, y: 0, width: 8, height: 13))
        accessory.center.y = cellHeight*0.5
        accessory.image = UIImage(named: "image01")

		contentView.addSubview(m_imageView)
		contentView.addSubview(m_title)
        contentView.addSubview(accessory)
	}
	
	func updateRowWithData(_ data: MyPhotoAlbumItem) {
		
		let title = NSMutableAttributedString()
		
		let nameDic = [NSFontAttributeName: UIFont.getFont(name: "PingFang-SC-Regular", size: 17), NSForegroundColorAttributeName: UIColor.white]
		let name = NSAttributedString(string: data.m_title, attributes: nameDic)
		title.append(name)
		
		let content: PHFetchResult = data.m_content
		let countDic = [NSFontAttributeName: UIFont.getFont(name: "PingFang-SC-Regular", size: 17), NSForegroundColorAttributeName: UIColor.color(RGBHEX: 0x999999, alpha: 1.0)]
		let count = NSAttributedString(string: " (\(content.count))", attributes: countDic)
		title.append(count)
		
		m_title.attributedText = title
		
		let lastAssert = content.lastObject as! PHAsset
		let imageWidth = cellHeight
		let size = CGSize(width:imageWidth * 2.0, height: imageWidth * 2.0)
		
		PHImageManager.default().requestImage(for: lastAssert, targetSize: size, contentMode: .aspectFill, options: nil) {
			[weak self] (image, _) in
			
			guard let weakSelf = self else { return }
			weakSelf.m_imageView.image = image
		}
	}
	
}
