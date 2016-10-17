//
//  MyPhotoGridVC.swift
//  PhotoKitTest
//
//  Created by DejingMa on 16/9/7.
//  Copyright © 2016年 DejingMa. All rights reserved.
//

import Foundation
import UIKit
import Photos

// MARK: - Class - 照片
class MyPhotoItem: NSObject {
	var m_img: UIImage! = UIImage()
	var m_asset: PHAsset! = PHAsset()
	var m_index: IndexPath!
	
	func updateWithData(_ image: UIImage, asset: PHAsset, index: IndexPath) {
		m_img = image
		m_asset = asset
		m_index = index
	}
}

// MARK: - Class - 照片展示VC
class MyPhotoGridVC: UIViewController {
	
	/// StoryBoard相关
	fileprivate var m_collectionView: UICollectionView!
	fileprivate var m_bottomView: UIView!
	fileprivate var m_preview: YLButton!
	fileprivate var m_done: MySelectPhotoDoneButton!
	
	/// Collectionview 视图相关
	fileprivate var m_itemWidth: CGFloat = 0.0
	fileprivate let m_minLineSpace: CGFloat = 4.0
	fileprivate let m_minItemSpace: CGFloat = 4.0
	fileprivate let m_collectionTop: CGFloat = 2
	fileprivate let m_collectionLeft: CGFloat = 2
	fileprivate let m_collectionBottom: CGFloat = 2
	fileprivate let m_collectionRight: CGFloat = 2
	
	/// 数据相关
	var m_fetchResult: PHFetchResult<PHAsset>!
	
    /// 所有照片资源数组
    fileprivate var m_allAssets: [PHAsset]! = []
	
	/// 加载图片相关
	fileprivate lazy var m_imageManager = PHCachingImageManager()
	fileprivate var m_assetGridThumbnailSize: CGSize!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		initData()
		initSubViews()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		m_collectionView.reloadData()
		updateToolBarView()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		
		print("\(classForCoder)内存泄露")
	}
	
	override var prefersStatusBarHidden : Bool {
		return false
	}

}

// MARK: - Initial Functions
extension MyPhotoGridVC {
	fileprivate func initData() {
		updateAllAssets()

		m_itemWidth = (kScreenWidth - m_minItemSpace*3 - m_collectionLeft - m_collectionRight) / 4
		
		// 计算出小图大小 （ 为targetSize做准备 ）
		let scale: CGFloat = 1.0
		
        m_assetGridThumbnailSize = CGSize(width: m_itemWidth*scale, height: m_itemWidth*scale)
	}
	
	fileprivate func initSubViews() {

		let rightBarItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.plain, target: self, action:#selector(self.cancel))
		navigationItem.rightBarButtonItem = rightBarItem
		
		initWithCollectionView()

        scrollToBottom()
		
		initWithButtomView()
	}
    
    fileprivate func initWithCollectionView() {
		let collectionViewFlowLayout = UICollectionViewFlowLayout()
		m_collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight-44), collectionViewLayout: collectionViewFlowLayout)
		
        m_collectionView.backgroundColor = UIColor.white
		
		m_collectionView.delegate = self
		m_collectionView.dataSource = self
		
		m_collectionView.register(MyPhotoGridCell.self, forCellWithReuseIdentifier: MyPhotoGridCell.getCellIndentifier())
		
		collectionViewFlowLayout.minimumLineSpacing = m_minLineSpace
		collectionViewFlowLayout.minimumInteritemSpacing = m_minItemSpace
		collectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(m_collectionTop, m_collectionLeft, m_collectionBottom, m_collectionRight)
		collectionViewFlowLayout.itemSize = CGSize(width: m_itemWidth, height: m_itemWidth)
		
		view.addSubview(m_collectionView)
    }
	
	fileprivate func initWithButtomView() {
		m_bottomView = UIView(frame: CGRect(x: 0, y: kScreenHeight-44, width: kScreenWidth, height: 44))
		m_bottomView.backgroundColor = UIColor.black
		
		m_preview = YLButton(frame: CGRect(x: 17, y: 0, width: 46, height: 30))
		m_preview.center.y = 22
		m_preview.titleLabelFrame = m_preview.bounds
		m_preview.titleLabel?.textAlignment = .left
		m_preview.titleLabel?.font = UIFont(name: "PingFang-SC-Regular", size: 14)
		m_preview.setTitle("预览", for: .normal)
		m_preview.setTitleColor(UIColor.white, for: .normal)
		m_preview.setTitleColor(UIColor.lightGray, for: .disabled)
		m_preview.addTarget(self, action: #selector(previewClick), for: .touchUpInside)
		
		m_done = MySelectPhotoDoneButton(frame: CGRect(x: kScreenWidth-63, y: 0, width: 63, height: 30))
		m_done.center.y = 22
		m_done.addTarget(self, action: #selector(doneClick), for: .touchUpInside)
		
		m_bottomView.addSubview(m_preview)
		m_bottomView.addSubview(m_done)
		view.addSubview(m_bottomView)
		
		updateToolBarView()
	}

}

// MARK: - Update Functions
extension MyPhotoGridVC {
	
	fileprivate func enableItems() {
		let enable = MyPhotoSelectManager.defaultManager.m_selectedItems.count > 0
		
		m_preview.isEnabled = enable
		m_done.isEnabled = enable
	}
		
	fileprivate func updateToolBarView() {
		enableItems()
		
		m_done.updateView()
	}
	
	fileprivate func scrollToBottom() {
		m_collectionView.layoutIfNeeded()
		
		let contentSize = m_collectionView.contentSize
		let frameSize = m_collectionView.frame.size
		if contentSize.height + 64 > frameSize.height {
			m_collectionView.setContentOffset(CGPoint(x: 0, y: m_collectionView.contentSize.height - m_collectionView.frame.size.height + 64), animated: false)
		}
	}
	
	fileprivate func updateAllAssets() {
		m_allAssets.removeAll()
		
		for i in 0 ..< m_fetchResult.count {
			let asset = m_fetchResult[i]
			m_allAssets.append(asset)
		}
	}
}

// MARK: - Functions
extension MyPhotoGridVC {

	func cancel() {
		navigationController?.dismiss(animated: true, completion: nil)
	}
	
	func previewClick() {
		let vc = MyPhotoPreviewVC()
		
		var assets: [PHAsset] = []
		for item in MyPhotoSelectManager.defaultManager.m_selectedItems {
			assets.append(item.m_asset)
		}
		vc.m_assets = assets
		vc.m_allAssets = m_allAssets
		vc.m_firstIndexPath = IndexPath.init(item: 0, section: 0)
		
		navigationController?.pushViewController(vc, animated: true)
	}
	
	func doneClick() {
		MyPhotoSelectManager.defaultManager.doSend(vcToDismiss: self)
	}
}

// MARK: - MyPhotoGridCellDelegate, MyPhotoPreviewVCDelegate
extension MyPhotoGridVC: MyPhotoGridCellDelegate {
	func myPhotoGridCellButtonSelect(cell: MyPhotoGridCell) {
		
		let lastSelectedIndex = MyPhotoSelectManager.defaultManager.m_selectedIndex
		
		let selectedItem = MySelectedItem.init(asset: cell.m_data.m_asset, index: cell.m_data.m_index)
		MyPhotoSelectManager.defaultManager.updateSelectItems(vcToShowAlert: self, button: cell.m_selectedCountView.m_selectButton, selectedItem: selectedItem)
		
		updateToolBarView()
		
		var needUpdateIndex = lastSelectedIndex
		
		for indexPath in MyPhotoSelectManager.defaultManager.m_selectedIndex {
			if !needUpdateIndex.contains(indexPath) {
				needUpdateIndex.append(indexPath)
			}
		}
		
        for indexPath in needUpdateIndex {
            if let cell = m_collectionView.cellForItem(at: indexPath) as? MyPhotoGridCell {
                cell.updateCellBadge()
            }
        }
	}
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension MyPhotoGridVC: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return m_fetchResult.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPhotoGridCell.getCellIndentifier(), for: indexPath) as! MyPhotoGridCell
		
		cell.m_delegate = self
		
		let asset = m_fetchResult[indexPath.item]
		
		cell.updateData(asset, size: m_assetGridThumbnailSize, indexPath: indexPath)
		
		cell.m_selectedCountView.m_selectButton.isSelected = MyPhotoSelectManager.defaultManager.m_selectedIndex.contains(indexPath)

		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		collectionView.deselectItem(at: indexPath, animated: true)
		
		let vc = MyPhotoPreviewVC()
		
		vc.m_assets = m_allAssets
		vc.m_allAssets = m_allAssets
		vc.m_firstIndexPath = indexPath
		
		navigationController?.pushViewController(vc, animated: true)
	}
}
