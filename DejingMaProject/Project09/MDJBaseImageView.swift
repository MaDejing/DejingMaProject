//
//  MDJBaseImageView.swift
//  DejingMaProject
//
//  Created by yolo on 2016/11/9.
//  Copyright © 2016年 DejingMa. All rights reserved.
//

import UIKit

class MDJBaseImageView: UIView {
    
    open var m_scrollView: UIScrollView!
    open var m_imageView: UIImageView!
    open var m_radius: CGFloat = 0.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.color(RGBHEX: 0x232329, alpha: 1.0)
        clipsToBounds = true
        
        m_scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        m_scrollView.backgroundColor = UIColor.clear
        m_scrollView.showsVerticalScrollIndicator = false
        m_scrollView.showsHorizontalScrollIndicator = false
        m_scrollView.isScrollEnabled = false
        
        m_imageView = UIImageView(frame: m_scrollView.bounds)
        m_imageView.contentMode = .scaleAspectFit
        m_imageView.layer.masksToBounds = true
        m_imageView.clipsToBounds = true
        m_imageView.isUserInteractionEnabled = true
        
        m_scrollView.addSubview(m_imageView)
        addSubview(m_scrollView)
    }
    
    /// 设置圆角半径
    ///
    /// - parameter radius: 半径
    open func setRadius(radius: CGFloat) {
        if (m_radius != radius) {
            m_radius = radius
            m_imageView.layer.cornerRadius = m_radius
        }
    }
    
    /// 自定义设置图片大小(图片居中显示)
    ///
    /// - parameter size: 图片大小
    open func setImageSize(_ size: CGSize) {
        m_imageView.contentMode = .scaleToFill
        m_imageView.frame.size = size
        m_imageView.center = CGPoint(x: frame.width*0.5, y: frame.height*0.5)
    }
    
    open func setImage(with img: UIImage) {
        m_imageView.image = img
    }
    
    /// 设置图片(文件名)
    ///
    /// - parameter name: 文件名
    open func setImageWithName(name: String) {
        m_imageView.image = UIImage(named: name)
    }
    
    /// 设置图片(数据)
    ///
    /// - parameter data: 数据
    open func setImageWithData(data: Data) {
        m_imageView.image = UIImage(data: data)
    }
    
    /// 设置图片(url)
    ///
    /// - parameter url:
    open func setImageWithUrl(url: String) {
        m_imageView.sd_setImage(with: URL(string: url), completed: nil)
    }

    /// 设置图片(url)
    ///
    /// - parameter url:         url
    /// - parameter placeholder: 占位图
    open func setImageWithUrl(url: String, placeholder: UIImage) {
        m_imageView.sd_setImage(with: URL(string: url),
                                placeholderImage: placeholder,
                                options: .retryFailed,
                                progress: nil,
                                completed: nil)
    }
	
    /// 从某个矩形开始放大平移展示
    ///
    /// - parameter superView:
    /// - parameter _rect:     动画开始处的矩形
    /// - parameter duration:  动画时长
    open func show(superView: UIView, startRect _rect: CGRect = CGRect.zero, duration: Double) {
        
        for subview in superView.subviews {
            guard !subview.isKind(of: MDJBaseImageView.self) else { return }
        }

		superView.addSubview(self)
		
		if _rect != CGRect.zero {
			let width = _rect.width
			let height = _rect.height
			let scale = CGAffineTransform(scaleX: width / frame.width, y: height / frame.height)
            
			let translation = CGAffineTransform(translationX: _rect.midX - frame.midX, y: _rect.midY - frame.midY)
			transform = scale.concatenating(translation)
        }
		
		showWithAnimation(duration: duration)
	}
	
	/// 普通展示
	///
	/// - parameter superView:
	/// - parameter duration:  动画时长
	open func show(superView: UIView, duration: Double) {
        
        for subview in superView.subviews {
            guard !subview.isKind(of: MDJBaseImageView.self) else { return }
        }
        
		superView.addSubview(self)
		
		showWithAnimation(duration: duration)
	}
    
    /// 隐藏
    ///
    /// - parameter duration: 动画时长
    open func hide(duration: Double) {
        
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.alpha = 0.0
        }) { [weak self] (finished) in
            self?.removeFromSuperview()
        }
    }
	
	/// 保存
	open func save() {
        
		guard let image = m_imageView.image else { return }
		//调用方法保存到图像库中
		UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
	}
	
	fileprivate func showWithAnimation(duration: Double) {
        
		UIView.animate(withDuration: duration, animations: { [weak self] in
            let scale = CGAffineTransform(scaleX: 1.0, y: 1.0)
            let translation = CGAffineTransform(translationX: 0.0, y: 0.0)
            self?.transform = scale.concatenating(translation)
            self?.alpha = 1.0
		}) { (finished) in
		}
	}

}
