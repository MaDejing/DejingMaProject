//
//  MyPhotoPreviewCell.swift
//  PhotoKitTest
//
//  Created by DejingMa on 16/9/9.
//  Copyright © 2016年 DejingMa. All rights reserved.
//

import UIKit
import Photos

protocol MyPhotoPreviewCellDelegate: NSObjectProtocol {
	func afterSingleTap(_ cell: MyPhotoPreviewCell)
}

class MyPhotoPreviewCell: UICollectionViewCell {
	
	fileprivate var m_scrollView: UIScrollView!
	fileprivate var m_imageView: UIImageView!
    
	fileprivate var m_data: MyPhotoItem!
	
	weak var m_delegate: MyPhotoPreviewCellDelegate?
    
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.singleTap))
		singleTap.numberOfTapsRequired = 1
		singleTap.numberOfTouchesRequired = 1
		
		let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.doubleTap))
		doubleTap.numberOfTapsRequired = 2
		doubleTap.numberOfTouchesRequired = 1
		
		singleTap.require(toFail: doubleTap)
		
		m_scrollView = UIScrollView(frame: UIScreen.main.bounds)
		
		m_scrollView.delegate = self
		m_scrollView.backgroundColor = UIColor.color(RGBHEX: 0x232329, alpha: 1.0)
		m_scrollView.maximumZoomScale = 2
		m_scrollView.minimumZoomScale = 1
		m_scrollView.showsVerticalScrollIndicator = false
		m_scrollView.showsHorizontalScrollIndicator = false

		m_scrollView.addGestureRecognizer(singleTap)
		m_scrollView.addGestureRecognizer(doubleTap)
        
        m_imageView = UIImageView()
        m_imageView.contentMode = .scaleAspectFit
        m_imageView.clipsToBounds = true
        m_imageView.isUserInteractionEnabled = true
		
		self.addSubview(m_scrollView)
		m_scrollView.addSubview(m_imageView)
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	static func getCellIdentifier() -> String {
		return "MyPhotoPreviewCell"
	}
	
	func updateData(_ asset: PHAsset, size: CGSize, indexPath: IndexPath) {
		
		let option = PHImageRequestOptions()
		option.resizeMode = .fast
		
		let _ = MyPhotoImageManager.defaultManager.getPhotoWithAsset(asset, size: size, options: option) {
			[weak self] (image, _, _) in
			
			guard let weakSelf = self else { return }

			let item = MyPhotoItem()
			item.updateWithData(image, asset: asset, index: indexPath)
			weakSelf.updateCellWithData(item)
		}
	}
	
	func updateCellWithData(_ data: MyPhotoItem) {
		m_data = data
		
		m_imageView.image = data.m_img
		
        imageResize()
        
        m_scrollView.isHidden = false
    }
}

extension MyPhotoPreviewCell {

	func imageResize() {
		m_scrollView.zoomScale = 1
		
		guard let img = m_imageView.image else { return }
		
		let imgSize = img.size
		let widthRatio = imgSize.width / kScreenWidth
        		
		let newSize = CGSize(width: imgSize.width / widthRatio, height: imgSize.height / widthRatio)
		m_imageView.frame.size = newSize
        
        if (newSize.height <= m_scrollView.frame.size.height) {
            m_imageView.center = m_scrollView.center
			m_imageView.frame.origin.x = 0
        } else {
            m_imageView.frame.origin = CGPoint.zero
        }
        
        m_scrollView.contentOffset = CGPoint.zero
        m_scrollView.contentSize = CGSize(width: kScreenWidth, height: max(kScreenHeight, m_imageView.frame.size.height))
    }
    
    // 把从scrollView里截取的矩形区域缩放到整个scrollView当前可视的frame里面。获取所要放大的内容的rect，以点击点为中心。因为放大scale倍，所以截取内容宽高为scrollview的1/scale。
    fileprivate func zoomRectForScale(_ scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect: CGRect = CGRect.zero
        
        //大小
        zoomRect.size.height = m_scrollView.frame.size.height/scale;
        zoomRect.size.width = m_scrollView.frame.size.width/scale;
        //原点
        zoomRect.origin.x = center.x - zoomRect.size.width/2;
        zoomRect.origin.y = center.y - zoomRect.size.height/2;
        
        return zoomRect;
    }
}

extension MyPhotoPreviewCell {
	func singleTap(_ ges: UITapGestureRecognizer) {
		m_delegate?.afterSingleTap(self)
	}
	
	func doubleTap(_ ges: UITapGestureRecognizer) {
		let newScale: CGFloat
		
		if m_scrollView.zoomScale == 1 {
			newScale = m_scrollView.maximumZoomScale
		} else {
			newScale = 1
		}
		
		let newRect = zoomRectForScale(newScale, center: ges.location(in: m_imageView))
        m_scrollView.zoom(to: newRect, animated: true)
	}
}

extension MyPhotoPreviewCell: UIScrollViewDelegate {
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return m_imageView
	}
	
	func scrollViewDidZoom(_ scrollView: UIScrollView) {
		var xcenter = scrollView.center.x
		var ycenter = scrollView.center.y
		
		// ScrollView中内容的大小和ScrollView本身的大小，哪个大取哪个的中心
		let contentWidthLarger: Bool = scrollView.contentSize.width > scrollView.frame.size.width
		let contentHeightLarger: Bool = scrollView.contentSize.height > scrollView.frame.size.height
		
		xcenter = contentWidthLarger ? scrollView.contentSize.width/2 : xcenter
		ycenter = contentHeightLarger ? scrollView.contentSize.height/2 : ycenter
		m_imageView.center = CGPoint(x: xcenter, y: ycenter)
	}
	
}
