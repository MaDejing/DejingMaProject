//
//  MyPhotoPreviewVC.swift
//  PhotoKitTest
//
//  Created by DejingMa on 16/9/8.
//  Copyright © 2016年 DejingMa. All rights reserved.
//

import Foundation
import UIKit
import Photos

// MARK: - Class - 预览
class MyPhotoPreviewVC: UIViewController {
	
	var m_topView: UIView!
	var m_selectedCountView: UIView!
	var m_selectButton: UIButton!
	var m_collectionView: UICollectionView!
    var m_done: UIButton!
    var m_bottomView: UIView!
	
    /// UICollectionview 视图相关
    let m_minLineSpace: CGFloat = 0.0
    let m_minItemSpace: CGFloat = 0.0
	let m_pageWidth: CGFloat = kScreenWidth + 10
	
	/// 需要上级传递的参数
	/// 需要展示的照片
	var m_assets: [PHAsset]! = []
	/// 所有的照片
    var m_allAssets: [PHAsset]! = []
	/// 首张展示的照片indexPath
	var m_firstIndexPath: IndexPath!
	/// 当前展示的照片在全部照片中的indexPath
    var m_curIndexPath: IndexPath!
	/// 当前展示的照片index
	var m_curIndex: Int!
	var sIndex: Int?
	var curSelectIndex: Int?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.automaticallyAdjustsScrollViewInsets = false
		initData()
        initSubViews()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
        
		m_collectionView.setContentOffset(CGPoint(x: m_pageWidth*CGFloat(m_firstIndexPath.item), y: 0), animated: false)
		
		navigationController?.setNavigationBarHidden(true, animated: false)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		navigationController?.setNavigationBarHidden(false, animated: false)
	}
	
	override var prefersStatusBarHidden : Bool {
		return true
	}
}

// MARK: - Initial & Update Funtions
extension MyPhotoPreviewVC {
	
	func initData() {
		m_curIndex = m_firstIndexPath.item
		
		let asset = m_assets[m_firstIndexPath.item]
		m_curIndexPath = IndexPath.init(item: m_allAssets.index(of: asset)!, section: 0)
	}
	
    func initSubViews() {
        initWithCollectionView()
		initWithTopView()
		initWithButtomView()
        updateBottomView()
    }
    
    func initWithCollectionView() {
		let collectionViewFlowLayout = UICollectionViewFlowLayout()
		m_collectionView = UICollectionView(frame: CGRect(x: -((m_pageWidth - kScreenWidth)*0.5), y: 0, width: m_pageWidth, height: kScreenHeight), collectionViewLayout: collectionViewFlowLayout)
		m_collectionView.showsHorizontalScrollIndicator = false
		m_collectionView.isPagingEnabled = true
		
        m_collectionView.backgroundColor = UIColor.black
		
		m_collectionView.delegate = self
		m_collectionView.dataSource = self
		
		m_collectionView.contentOffset = CGPoint.zero
		m_collectionView.contentSize = CGSize(width: CGFloat(m_assets.count)*m_pageWidth, height: kScreenHeight)
		
        m_collectionView.register(MyPhotoPreviewCell.self, forCellWithReuseIdentifier: MyPhotoPreviewCell.getCellIdentifier())
		
		collectionViewFlowLayout.minimumLineSpacing = m_minLineSpace
		collectionViewFlowLayout.minimumInteritemSpacing = m_minItemSpace
		collectionViewFlowLayout.itemSize = CGSize(width: kScreenWidth + 10, height: kScreenHeight)
		collectionViewFlowLayout.scrollDirection = .horizontal
	
		view.addSubview(m_collectionView)
    }
	
	fileprivate func initWithTopView() {
		m_topView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 64))
		m_topView.backgroundColor = UIColor.black
		
		let backButton = UIButton(frame: CGRect(x: 12, y: 35, width: 50, height: 17.5))
		backButton.setTitle("back", for: .normal)
		backButton.setTitleColor(UIColor.white, for: .normal)
		backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
		
		m_selectedCountView = UIView(frame: CGRect(x: kScreenWidth-12.5-23, y: 42-23/2.0, width: 23, height: 23))
		m_selectButton = UIButton(frame: CGRect(x: 0, y: 0, width: 23, height: 23))
		
		m_selectButton.addTarget(self, action: #selector(selectClick), for: .touchUpInside)
		m_selectButton.setImage(UIImage(named: "GridCellButton"), for: .normal)
		m_selectButton.setTitle("", for: .normal)
		m_selectButton.setImage(UIImage(), for: .selected)
		m_selectButton.setTitleColor(UIColor.white, for: .selected)
		m_selectButton.titleLabel?.font = UIFont.getFont(name: "PingFang-SC-Regular", size: 15)

		updateTopView()
		
		m_selectedCountView.addSubview(m_selectButton)
		m_topView.addSubview(backButton)
		m_topView.addSubview(m_selectedCountView)
		view.addSubview(m_topView)
	}
	
	fileprivate func initWithButtomView() {
		m_bottomView = UIView(frame: CGRect(x: 0, y: kScreenHeight-44, width: kScreenWidth, height: 44))
		m_bottomView.backgroundColor = UIColor.black
		
		m_done = UIButton(type: .custom)
		m_done.frame = CGRect(x: kScreenWidth-17-46, y: 12, width: 46, height: 20)
		m_done.setTitle("完成", for: .normal)
		m_done.titleLabel?.font = UIFont(name: "PingFang-SC-Regular", size: 14)
		m_done.setTitleColor(UIColor.white, for: .normal)
		m_done.setTitleColor(UIColor.lightGray, for: .disabled)
		m_done.addTarget(self, action: #selector(doneClick), for: .touchUpInside)
		
		m_bottomView.addSubview(m_done)
		view.addSubview(m_bottomView)
		
		updateBottomView()
	}
	
	func updateTopView() {
		let indexPath = IndexPath(item: m_curIndex, section: 0)
		m_selectButton.isSelected = MyPhotoSelectManager.defaultManager.contains(item: indexPath)

		if m_selectButton.isSelected {
			let sIndex: Int = MyPhotoSelectManager.defaultManager.m_selectedIndex.index(of: indexPath)!
			m_selectButton.setTitle(String(sIndex+1), for: .selected)
			m_selectedCountView.backgroundColor = UIColor.orange
		} else {
			m_selectedCountView.backgroundColor = UIColor.clear
		}
	}
	
    func updateBottomView() {
        m_done.isEnabled = MyPhotoSelectManager.defaultManager.m_selectedItems.count > 0
    }
}

// MARK: - 方法
extension MyPhotoPreviewVC {
	fileprivate func calImageSize(_ asset: PHAsset, scale: CGFloat) -> CGSize {
		// 计算图片大小
		var imageSize: CGSize = CGSize(width: CGFloat(asset.pixelWidth), height: CGFloat(asset.pixelHeight))
		let aspectRatio: CGFloat = CGFloat(asset.pixelWidth) / CGFloat(asset.pixelHeight)
		imageSize = CGSize(width: kScreenWidth*scale, height: kScreenWidth/aspectRatio*scale);
		
		return imageSize
	}
}

// MARK: - IBActions
extension MyPhotoPreviewVC {
	
	func back() {
		_ = navigationController?.popViewController(animated: true)
	}
	
	func selectClick() {
		let indexPath = IndexPath(item: m_curIndex, section: 0)
		let selectedItem = MySelectedItem.init(asset: m_allAssets[m_curIndex], index: indexPath)

		if m_selectButton.isSelected {
			sIndex = MyPhotoSelectManager.defaultManager.index(of: indexPath)
			curSelectIndex = m_curIndexPath.item

			MyPhotoSelectManager.defaultManager.updateSelectItems(vcToShowAlert: self, button: m_selectButton, selectedItem: selectedItem)
			updateBottomView()

			m_selectedCountView.backgroundColor = UIColor.clear
			
		} else {
			
			if sIndex != nil && curSelectIndex != nil {
				MyPhotoSelectManager.defaultManager.updateSelectItems(vcToShowAlert: self, button: m_selectButton, selectedItem: selectedItem, keepOrigin: true, sIndex: sIndex)
			} else {
				MyPhotoSelectManager.defaultManager.updateSelectItems(vcToShowAlert: self, button: m_selectButton, selectedItem: selectedItem)
			}
			
			updateBottomView()
			
			updateTopView()
		}
	}
	
    func doneClick() {
		MyPhotoSelectManager.defaultManager.doSend(vcToDismiss: self)
    }
	
}

// MARK: - UIScrollViewDelegate
extension MyPhotoPreviewVC: UIScrollViewDelegate {
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		guard scrollView == m_collectionView else { return }
		
		var offSetX = scrollView.contentOffset.x
		offSetX += m_pageWidth * 0.5
		
		let currentIndex = Int(offSetX / m_pageWidth)
		
		if (m_curIndex != currentIndex) {
			m_curIndex = currentIndex
			
			updateTopView()
		}
	}
	
//	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//		guard scrollView == m_collectionView else { return }
//
//		let pageWidth = scrollView.frame.width + m_minLineSpace
//		m_curIndex = Int((scrollView.contentOffset.x + m_minLineSpace) / pageWidth)
//	}
//
//	func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//		guard scrollView == m_collectionView else { return }
//
//		targetContentOffset.pointee = scrollView.contentOffset
//
//		let pageWidth = scrollView.frame.width + m_minLineSpace
//
//		if (velocity.x == 0) {
//			m_nextIndex = Int(floor((scrollView.contentOffset.x - kScreenWidth/2) / pageWidth) + 1)
//		} else {
//			if velocity.x > 0 {
//				if scrollView.contentOffset.x < pageWidth * CGFloat(m_curIndex) {
//					m_nextIndex = m_curIndex
//				} else {
//					m_nextIndex = m_curIndex + 1
//				}
//			} else {
//				if scrollView.contentOffset.x > pageWidth * CGFloat(m_curIndex) {
//					m_nextIndex = m_curIndex
//				} else {
//					m_nextIndex = m_curIndex - 1
//				}
//			}
//		}
//		
//		if (m_nextIndex < 0) {
//			m_nextIndex = 0
//		} else if (m_nextIndex >= m_collectionView.numberOfItems(inSection: 0)) {
//			m_nextIndex = m_collectionView.numberOfItems(inSection: 0) - 1
//		}
//		
//		print(scrollView.contentOffset, velocity, m_curIndex, m_nextIndex)
//		
//		m_collectionView.scrollToItem(at: IndexPath.init(item: m_nextIndex, section: 0), at: .left, animated: true)
//	}
//	
	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		guard scrollView == m_collectionView else { return }
		
		let asset = m_assets[m_curIndex]
		m_curIndexPath = IndexPath.init(item: m_allAssets.index(of: asset)!, section: 0)

		if m_curIndex != curSelectIndex {
			curSelectIndex = nil
			sIndex = nil
		}
		
		updateTopView()
	}
}

// MARK: - MyPhotoPreviewCellDelegate
extension MyPhotoPreviewVC: MyPhotoPreviewCellDelegate {
	func afterSingleTap(_ cell: MyPhotoPreviewCell) {
		m_topView.isHidden = !m_topView.isHidden
		m_bottomView.isHidden = !m_bottomView.isHidden
	}
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension MyPhotoPreviewVC: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return m_assets.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPhotoPreviewCell.getCellIdentifier(), for: indexPath) as! MyPhotoPreviewCell
		
		cell.m_delegate = self
        
		let asset = m_assets[indexPath.item]
		
		cell.updateData(asset, size: calImageSize(asset, scale: 2.0), indexPath: indexPath)

		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		guard let cell = cell as? MyPhotoPreviewCell else { return }
		cell.imageResize()
	}
}


