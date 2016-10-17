//
//  MyPhotoGridCell.swift
//  PhotoKitTest
//
//  Created by DejingMa on 16/9/7.
//  Copyright © 2016年 DejingMa. All rights reserved.
//

import Foundation
import UIKit
import Photos

protocol MyPhotoGridCellDelegate: NSObjectProtocol {
	func myPhotoGridCellButtonSelect(cell: MyPhotoGridCell)
}

class MyPhotoGridCell: UICollectionViewCell {
	var m_imageView: UIImageView!
//	var m_selectButton: YLButton!
	var m_selectedCountView: MyPhotoSelectCountView!
	
	weak var m_delegate: MyPhotoGridCellDelegate?
	
	var m_data: MyPhotoItem!
	
	var m_representedAssetIdentifier: String!
	
	var m_imageRequestID: PHImageRequestID!
	
	override init(frame: CGRect) {
		super.init(frame: frame)

		m_imageView = UIImageView(frame: self.bounds)
		
		let selectViewWidth: CGFloat = 23.0
		let delta: CGFloat = 4.0
		let selectViewFrame = CGRect(x: self.bounds.width-45, y: 0, width: 45, height: 45)
		let bgViewFrame = CGRect(x: 45-selectViewWidth-delta, y: delta, width: selectViewWidth, height: selectViewWidth)
		
		m_selectedCountView = MyPhotoSelectCountView(frame: selectViewFrame, bgViewFrame: bgViewFrame)
		m_selectedCountView.m_selectButton.addTarget(self, action: #selector(photoSelect), for: .touchUpInside)
		
		addSubview(m_imageView)
		addSubview(m_selectedCountView)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)!
	}
	
	static func getCellIndentifier() -> String {
		return "MyPhotoGridCell"
	}
	
	func updateData(_ asset: PHAsset, size: CGSize, indexPath: IndexPath) {
		m_representedAssetIdentifier = MyPhotoImageManager.defaultManager.getAssetIndentifier(asset)
		
		let option = PHImageRequestOptions()
		option.resizeMode = .fast
		
		let imageRequestId = MyPhotoImageManager.defaultManager.getPhotoWithAsset(asset, size: size, options: option) {
			[weak self] (image, _, isDegraded) in
			
			guard let weakSelf = self else { return }
			
			if (weakSelf.m_representedAssetIdentifier == MyPhotoImageManager.defaultManager.getAssetIndentifier(asset)) {
				let item = MyPhotoItem()
				item.updateWithData(image, asset: asset, index: indexPath)
				weakSelf.updateCellWithData(item)
			} else {
				PHImageManager.default().cancelImageRequest(weakSelf.m_imageRequestID)
			}
			
			if (!isDegraded) {
				weakSelf.m_imageRequestID = 0
			}
		}
				
		if (m_imageRequestID != nil && imageRequestId != m_imageRequestID) {
			PHImageManager.default().cancelImageRequest(m_imageRequestID)
		}
		
		m_imageRequestID = imageRequestId
	}
	
	func updateCellWithData(_ data: MyPhotoItem) {
		m_data = data
		
		m_imageView.image = data.m_img
		
        updateCellBadge()
    }
    
    func updateCellBadge() {
        if MyPhotoSelectManager.defaultManager.m_selectedIndex.contains(m_data.m_index) {
            let sIndex: Int = MyPhotoSelectManager.defaultManager.m_selectedIndex.index(of: m_data.m_index)!
			m_selectedCountView.updateSubViews(selected: true, title: String(sIndex+1))
		} else {
			m_selectedCountView.updateSubViews(selected: false, title: "")
		}
    }
	
	func photoSelect() {
		m_delegate!.myPhotoGridCellButtonSelect(cell: self)
	}
	
}
