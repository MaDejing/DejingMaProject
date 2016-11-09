//
//  MDJImageView.swift
//  DejingMaProject
//
//  Created by DejingMa on 16/11/9.
//  Copyright © 2016年 DejingMa. All rights reserved.
//

import UIKit

public enum MDJImageViewContentMode : Int {
	
	case tofill
	
	case aspectFit // contents scaled to fit with fixed aspect. remainder is transparent
	
	case aspectFill // contents scaled to fill with fixed aspect. some portion of content may be clipped.
}


protocol MDJImageViewDelegate: NSObjectProtocol {
	func afterSingleTap(_ view: MDJImageView)
}

class MDJImageView: UIView {
	
	fileprivate var m_scrollView: UIScrollView!
	fileprivate var m_imageView: UIImageView!
	
	var m_maximumZoomScale: CGFloat! = 2.0
	var m_minimumZoomScale: CGFloat! = 1.0
	
	var m_singleTapEnabled = true
	var m_doubleTapEnabled = true
	var m_rotationTapEnabled = true
	
	fileprivate var m_rotation: CGFloat = 0.0
	
	fileprivate var m_mode: MDJImageViewContentMode = .aspectFit
	
	weak var m_delegate: MDJImageViewDelegate?
	
	lazy var m_singleTap: UITapGestureRecognizer = {
		let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.singleTap))
		singleTap.numberOfTapsRequired = 1
		singleTap.numberOfTouchesRequired = 1
		
		return singleTap
	}()
	
	lazy var m_doubleTap: UITapGestureRecognizer = {
		let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.doubleTap))
		doubleTap.numberOfTapsRequired = 2
		doubleTap.numberOfTouchesRequired = 1
		
		return doubleTap
	}()
	
	lazy var m_rotationGes: UIRotationGestureRecognizer = {
		let m_rotationGes = UIRotationGestureRecognizer(target: self, action: #selector(self.rotationTap))
		
		return m_rotationGes
	}()
	
	func getZoomScale() -> CGFloat {
		return m_scrollView.zoomScale
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		
		backgroundColor = UIColor.color(RGBHEX: 0x232329, alpha: 1.0)
		
		m_scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
		m_scrollView.backgroundColor = UIColor.red
		m_scrollView.showsVerticalScrollIndicator = false
		m_scrollView.showsHorizontalScrollIndicator = false
		m_scrollView.delegate = self
	}
	
	convenience init(frame: CGRect,
	                 mode: MDJImageViewContentMode,
	                 maxZoomScale: CGFloat,
	                 minZoomScale: CGFloat) {
		
		self.init(frame: frame)
		
		commonInit(mode: mode, maxZoomScale: maxZoomScale, minZoomScale: minZoomScale)
		
		m_imageView = UIImageView()
		m_imageView.contentMode = .scaleAspectFit
		m_imageView.clipsToBounds = true
		m_imageView.isUserInteractionEnabled = true
		
		m_scrollView.maximumZoomScale = m_maximumZoomScale
		m_scrollView.minimumZoomScale = m_minimumZoomScale
		
		if m_singleTapEnabled {
			m_scrollView.addGestureRecognizer(m_singleTap)
		}
		
		if m_doubleTapEnabled {
			m_singleTap.require(toFail: m_doubleTap)
			m_scrollView.addGestureRecognizer(m_doubleTap)
		}
		
		if m_rotationTapEnabled {
			m_scrollView.addGestureRecognizer(m_rotationGes)

//			if let gestureRecognizers = m_scrollView.gestureRecognizers {
//				for ges in gestureRecognizers {
//					if ges.isKind(of: UIGestureRecognizer.self) {
//						ges.require(toFail: m_rotationGes)
//					}
//				}
//			}
		}
		
		m_scrollView.addSubview(m_imageView)
		addSubview(m_scrollView)
	}
	
	
	func commonInit(mode: MDJImageViewContentMode, maxZoomScale: CGFloat, minZoomScale: CGFloat) {
	
		m_mode = mode
		
		m_maximumZoomScale = maxZoomScale
		m_minimumZoomScale = minZoomScale
	}
	
	func updateWithImage(_ img: UIImage) {
		
		m_imageView.image = img
		
		imageResize()
	}
}

extension MDJImageView {
	
	func imageResize() {
		m_scrollView.zoomScale = 1
		
		guard let img = m_imageView.image else { return }
		
		let imgSize = img.size
		
		switch m_mode {
		case .aspectFit:
			let widthRatio = imgSize.width / m_scrollView.frame.width
			let heightRatio = imgSize.height / m_scrollView.frame.height
			let ratio = max(widthRatio, heightRatio)
			
			let newSize = CGSize(width: imgSize.width / ratio, height: imgSize.height / ratio)
			m_imageView.frame.size = newSize
			
			m_imageView.center = m_scrollView.center

			if ratio == widthRatio {
				m_imageView.frame.origin.x = 0
				m_scrollView.contentSize = CGSize(width: m_scrollView.frame.width, height: max(m_scrollView.frame.height, newSize.height))

			} else {
				m_scrollView.contentSize = CGSize(width: max(m_scrollView.frame.width, newSize.width), height:m_scrollView.frame.height)
			}
			
			m_scrollView.contentOffset = CGPoint.zero

			
		default:
			break
		}
		
//		let widthRatio = imgSize.width / m_scrollView.frame.width
//		
//		let newSize = CGSize(width: imgSize.width / widthRatio, height: imgSize.height / widthRatio)
//		m_imageView.frame.size = newSize
//		
//		if (newSize.height <= m_scrollView.frame.height) {
//			m_imageView.center = m_scrollView.center
//			m_imageView.frame.origin.x = 0
//		} else {
//			m_imageView.frame.origin = CGPoint.zero
//		}
//		
//		m_scrollView.contentOffset = CGPoint.zero
//		m_scrollView.contentSize = CGSize(width: m_scrollView.frame.width, height: max(m_scrollView.frame.height, m_imageView.frame.height))
	}
	
	// 把从scrollView里截取的矩形区域缩放到整个scrollView当前可视的frame里面。获取所要放大的内容的rect，以点击点为中心。因为放大scale倍，所以截取内容宽高为scrollview的1/scale。
	fileprivate func zoomRectForScale(_ scale: CGFloat, center: CGPoint) -> CGRect {
		var zoomRect: CGRect = CGRect.zero
		
		//大小
		zoomRect.size.height = m_scrollView.frame.height/scale;
		zoomRect.size.width = m_scrollView.frame.width/scale;
		//原点
		zoomRect.origin.x = center.x - zoomRect.width/2;
		zoomRect.origin.y = center.y - zoomRect.height/2;
		
		return zoomRect;
	}
}

extension MDJImageView {
	
	@objc fileprivate func singleTap(_ ges: UITapGestureRecognizer) {
		m_delegate?.afterSingleTap(self)
	}
	
	@objc fileprivate func doubleTap(_ ges: UITapGestureRecognizer) {
		let newScale: CGFloat
		
		if m_scrollView.zoomScale == 1 {
			newScale = m_maximumZoomScale
		} else {
			newScale = 1
		}
		
		let newRect = zoomRectForScale(newScale, center: ges.location(in: m_imageView))
		m_scrollView.zoom(to: newRect, animated: true)
	}
	
	@objc fileprivate func rotationTap(_ ges: UIRotationGestureRecognizer) {
		ges.view?.transform = CGAffineTransform(rotationAngle: m_rotation+ges.rotation)
		if (ges.state == .ended) {
			m_rotation += ges.rotation
		}
	}
}

extension MDJImageView: UIScrollViewDelegate {
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


