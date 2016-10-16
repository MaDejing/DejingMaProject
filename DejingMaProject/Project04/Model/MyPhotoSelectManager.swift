//
//  MyPhotoSelectManager.swift
//  PhotoKitTest
//
//  Created by DejingMa on 16/9/14.
//  Copyright © 2016年 DejingMa. All rights reserved.
//

import UIKit
import Photos

// MARK: - Class - 选中项
class MySelectedItem: NSObject {
	var m_asset: PHAsset!
	var m_index: IndexPath!
	
	init(asset: PHAsset, index: IndexPath) {
		self.m_asset = asset
		self.m_index = index
	}
}

/// 最多选中的数目
let maxCount: Int = 9

// MARK: - Class - 照片选择管理类
class MyPhotoSelectManager: NSObject {
	
	var m_selectedItems: [MySelectedItem] = []
	var m_selectedIndex: [IndexPath] = []
    var m_sendItems: [UIImage] = []
	
	/// static是延时加载的，并且是常量，加载一次后不会加载第二次，所以实现了单例。
	static let defaultManager: MyPhotoSelectManager = MyPhotoSelectManager()
	
	/// 更新已选项
	///
	/// - parameter vcToShowAlert: 展示提示框的VC
	/// - parameter button:        选择按钮
	/// - parameter selectedItem:  被选择的资源
	func updateSelectItems(vcToShowAlert: UIViewController, button: UIButton, selectedItem: MySelectedItem, keepOrigin: Bool = false, sIndex: Int? = nil) {
		if self.m_selectedItems.count >= maxCount && !button.isSelected {
			let alert = UIAlertController(title: nil, message: "最多可选择\(maxCount)张照片", preferredStyle: .alert)
			let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
			
			alert.addAction(cancelAction)
			
			vcToShowAlert.present(alert, animated: true, completion: nil)
		} else {
			button.isSelected = !button.isSelected
			
			if button.isSelected {
				if keepOrigin && sIndex != nil {
					m_selectedItems.insert(selectedItem, at: sIndex!)
				} else {
					self.m_selectedItems.append(selectedItem)
				}
			} else {
				let index = self.m_selectedIndex.index(of: selectedItem.m_index)
				
				if (index != nil) {
					self.m_selectedItems.remove(at: index!)
				}
			}
			
			self.updateIndexArr()
		}
	}
	
	/// 更新已选项index数组
	func updateIndexArr() {
		self.m_selectedIndex.removeAll()
		for asset in self.m_selectedItems {
			self.m_selectedIndex.append(asset.m_index)
		}
	}
	
	func contains(item indexPath: IndexPath) -> Bool {
		return m_selectedIndex.contains(indexPath)
	}
	
	func index(of indexPath: IndexPath) -> Int? {
		return m_selectedIndex.index(of: indexPath)
	}
	
	/// 清空已选数据
	func clearData() {
		self.m_selectedItems.removeAll()
		self.m_selectedIndex.removeAll()
	}
	
	/// 发送事件
	///
	/// - parameter vcToDismiss: 需要dismiss的VC
	func doSend(vcToDismiss: UIViewController) {
//		print(MyPhotoSelectManager.defaultManager.m_selectedItems)
        
        m_sendItems.removeAll()
        for item in MyPhotoSelectManager.defaultManager.m_selectedItems {
            let asset = item.m_asset
            
            _ = MyPhotoImageManager.defaultManager.getPhotoWithAsset(asset!, size: PHImageManagerMaximumSize, options: nil, completion: { (image, _, _) in
                
                self.m_sendItems.append(image)
                
                print(image)
            })
        }
        
        
		vcToDismiss.dismiss(animated: true, completion: nil)
		MyPhotoSelectManager.defaultManager.clearData()
	}

}
