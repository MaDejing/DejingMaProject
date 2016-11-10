//
//  MDJScrollImageView.swift
//  DejingMaProject
//
//  Created by DejingMa on 16/11/9.
//  Copyright © 2016年 DejingMa. All rights reserved.
//

import UIKit

public enum MDJScrollImageViewMode : Int {
	
	case toFill
	case aspectFit
	case aspectFill
	case fitWidth
}

class MDJScrollImageView: MDJBaseImageView {
	
	fileprivate var m_scrollView: UIScrollView!
	
	fileprivate var m_maximumZoomScale: CGFloat! = 2.0
	fileprivate var m_minimumZoomScale: CGFloat! = 1.0
	
	var m_singleTapEnabled = true
	var m_doubleTapEnabled = true
	var m_rotationTapEnabled = true
    var m_longPressEnabled = true
	
	fileprivate var m_rotation: CGFloat = 0.0
	
	fileprivate var m_mode: MDJScrollImageViewMode = .fitWidth
		
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
    
    lazy var m_longPress: UILongPressGestureRecognizer = {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress))
        
        return longPress
    }()
	
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		
		backgroundColor = UIColor.color(RGBHEX: 0x232329, alpha: 1.0)
		clipsToBounds = true
        
		m_scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
		m_scrollView.backgroundColor = UIColor.red
		m_scrollView.showsVerticalScrollIndicator = false
		m_scrollView.showsHorizontalScrollIndicator = false
		m_scrollView.delegate = self
	}
	
	convenience init(frame: CGRect, mode: MDJScrollImageViewMode, maxZoomScale: CGFloat, minZoomScale: CGFloat) {
		
		self.init(frame: frame)
		
		commonInit(mode: mode, maxZoomScale: maxZoomScale, minZoomScale: minZoomScale)
		
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
            m_singleTap.require(toFail: m_rotationGes)
			m_scrollView.addGestureRecognizer(m_rotationGes)
		}
        
        if m_longPressEnabled {
            m_scrollView.addGestureRecognizer(m_longPress)
        }
		
		m_scrollView.addSubview(m_imageView)
		addSubview(m_scrollView)
	}
	
	func commonInit(mode: MDJScrollImageViewMode, maxZoomScale: CGFloat, minZoomScale: CGFloat) {
	
		m_mode = mode
		
		m_maximumZoomScale = maxZoomScale
		m_minimumZoomScale = minZoomScale
	}
}

extension MDJScrollImageView {
    
    override func setWithImage(name: String) {
        
        super.setWithImage(name: name)
        
        initImageSize()
    }
    
    func setMode(mode: MDJScrollImageViewMode) {
     
        m_mode = mode
        
        initImageSize()
    }
    
}

extension MDJScrollImageView {
    
    func getZoomScale() -> CGFloat {
        
        return m_scrollView.zoomScale
    }
    
    func getCurRotation() -> CGFloat {
        
        return CGFloat(Double(m_rotation) * 180 / M_PI).truncatingRemainder(dividingBy: 360)
    }
}

extension MDJScrollImageView {
	
	func initImageSize() {
		
		m_scrollView.zoomScale = 1
		
		guard let img = m_imageView.image else { return }
		
		let imgSize = img.size
        let widthRatio = imgSize.width / frame.width
        let heightRatio = imgSize.height / frame.height
		
		switch m_mode {
		case .aspectFit:
            resizeWithAspectFit(imgSize: imgSize, widthRatio: widthRatio, heightRatio: heightRatio)
            
        case .aspectFill:
            resizeWithAspectFill(imgSize: imgSize, widthRatio: widthRatio, heightRatio: heightRatio)

        case .toFill:
            resizeWithToFill(imgSize: imgSize, widthRatio: widthRatio, heightRatio: heightRatio)

		case .fitWidth:
			resizeWithFitWidth(imgSize: imgSize, widthRatio: widthRatio)
        }
        
        m_scrollView.contentOffset = CGPoint.zero
	}
    
    fileprivate func resizeWithAspectFit(imgSize: CGSize, widthRatio: CGFloat, heightRatio: CGFloat) {
        
        let ratio = max(widthRatio, heightRatio)
        
        let newSize = CGSize(width: imgSize.width / ratio, height: imgSize.height / ratio)
        m_imageView.frame.size = newSize
        
        m_imageView.center = m_scrollView.center
        
        if ratio == widthRatio {
            m_imageView.frame.origin.x = 0
            m_scrollView.contentSize = CGSize(width: frame.width, height: max(frame.height, newSize.height))
        } else {
            m_scrollView.contentSize = CGSize(width: max(frame.width, newSize.width), height: frame.height)
        }
    }
    
    fileprivate func resizeWithAspectFill(imgSize: CGSize, widthRatio: CGFloat, heightRatio: CGFloat) {
       
        m_imageView.contentMode = .scaleAspectFill
        
        let ratio = min(widthRatio, heightRatio)
        
        if ratio == widthRatio {
            m_imageView.frame.size = CGSize(width: imgSize.width / ratio, height: frame.height)
        } else {
            m_imageView.frame.size = CGSize(width: frame.width, height: imgSize.height / ratio)
        }
        
        m_imageView.center = m_scrollView.center
        m_scrollView.contentSize = m_imageView.frame.size
    }
    
    fileprivate func resizeWithToFill(imgSize: CGSize, widthRatio: CGFloat, heightRatio: CGFloat) {
        
        m_imageView.contentMode = .scaleToFill
        
        m_imageView.frame.size = frame.size
        m_imageView.center = m_scrollView.center
        m_scrollView.contentSize = m_imageView.frame.size
    }
	
	fileprivate func resizeWithFitWidth(imgSize: CGSize, widthRatio: CGFloat) {
		
		m_imageView.contentMode = .scaleAspectFit
		
		let newSize = CGSize(width: imgSize.width / widthRatio, height: imgSize.height / widthRatio)
		m_imageView.frame.size = newSize
		
		if (newSize.height <= m_scrollView.frame.size.height) {
			m_imageView.center = m_scrollView.center
			m_imageView.frame.origin.x = 0
		} else {
			m_imageView.frame.origin = CGPoint.zero
		}
		
		m_scrollView.contentSize = CGSize(width: frame.width, height: max(frame.height, newSize.height))
	}
}

extension MDJScrollImageView {
	
	// 把从scrollView里截取的矩形区域缩放到整个scrollView当前可视的frame里面。获取所要放大的内容的rect，以点击点为中心。因为放大scale倍，所以截取内容宽高为scrollview的1/scale。
	fileprivate func zoomRectForScale(_ scale: CGFloat, center: CGPoint) -> CGRect {
		var zoomRect: CGRect = CGRect.zero
		
		//大小
		zoomRect.size.height = frame.height/scale;
		zoomRect.size.width = frame.width/scale;
		//原点
		zoomRect.origin.x = center.x - zoomRect.width/2;
		zoomRect.origin.y = center.y - zoomRect.height/2;
		
		return zoomRect;
	}

}

extension MDJScrollImageView {
	
	@objc fileprivate func singleTap(_ ges: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.alpha = 0.0
        }) { [weak self] (finished) in
            self?.removeFromSuperview()
        }
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
		ges.view?.transform = (ges.view?.transform.rotated(by: ges.rotation))!
		
		m_rotation += ges.rotation
		
		ges.rotation = 0.0
	}
    
    @objc fileprivate func longPress(_ ges: UILongPressGestureRecognizer) {
        guard ges.state == .began else { return }
        
        print("long press")
    }
}

extension MDJScrollImageView: UIScrollViewDelegate {
	
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return m_imageView
	}
	
	func scrollViewDidZoom(_ scrollView: UIScrollView) {
		var xcenter = scrollView.center.x
		var ycenter = scrollView.center.y
		
		// ScrollView中内容的大小和ScrollView本身的大小，哪个大取哪个的中心
		let contentWidthLarger: Bool = scrollView.contentSize.width > frame.width
		let contentHeightLarger: Bool = scrollView.contentSize.height > frame.height
		
		xcenter = contentWidthLarger ? scrollView.contentSize.width/2 : xcenter
		ycenter = contentHeightLarger ? scrollView.contentSize.height/2 : ycenter
		m_imageView.center = CGPoint(x: xcenter, y: ycenter)
	}
}


