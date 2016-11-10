//
//  MDJBaseImageView.swift
//  DejingMaProject
//
//  Created by yolo on 2016/11/9.
//  Copyright © 2016年 DejingMa. All rights reserved.
//

import UIKit

class MDJBaseImageView: UIView {
    
    open var m_imageView: UIImageView!
    open var m_diameter: CGFloat = 0.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        m_imageView = UIImageView()
        m_imageView.contentMode = .scaleAspectFit
        m_imageView.layer.masksToBounds = true
        m_imageView.clipsToBounds = true
        m_imageView.isUserInteractionEnabled = true
    }
    
    open func setDiameter(diameter: CGFloat) {
        if (m_diameter != diameter) {
            m_diameter = diameter
            m_imageView.layer.cornerRadius = m_diameter*0.5
        }
    }
    
    open func setWithImage(name: String) {
        m_imageView.image = UIImage(named: name)
    }
    
    open func setWithData(data: Data) {
        m_imageView.image = UIImage(data: data)
    }
    
    open func setWithUrl(url: String) {
        m_imageView.sd_setImage(with: URL(string: url), completed: nil)
    }

    open func setWithUrl(url: String, placeholder: UIImage) {
        m_imageView.sd_setImage(with: URL(string: url),
                                placeholderImage: placeholder,
                                options: .retryFailed,
                                progress: nil,
                                completed: nil)
    }
	
    open func show(superView: UIView, startRect _rect: CGRect = CGRect.zero) {
        
        for subview in superView.subviews {
            guard !subview.isKind(of: MDJBaseImageView.self) else { return }
        }

		superView.addSubview(self)
		
		if _rect != CGRect.zero {
			let width = _rect.width
			let height = _rect.height
			let scale = CGAffineTransform(scaleX: width / frame.width, y: height / frame.height)
            
            print(_rect.midY, frame.midY)
            
			let translation = CGAffineTransform(translationX: _rect.midX - frame.midX, y: _rect.midY - frame.midY)
			transform = scale.concatenating(translation)
            
            print(frame, transform)
		}
		
		showWithAnimation()
	}
	
	open func show(superView: UIView) {
        
        for subview in superView.subviews {
            guard !subview.isKind(of: MDJBaseImageView.self) else { return }
        }
        
		superView.addSubview(self)
		
		showWithAnimation()
	}
	
	open func save() {
        
		guard let image = m_imageView.image else { return }
		//调用方法保存到图像库中
		UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
	}
	
	fileprivate func showWithAnimation() {
        
		UIView.animate(withDuration: 0.3, animations: { [weak self] in
            let scale = CGAffineTransform(scaleX: 1.0, y: 1.0)
            let translation = CGAffineTransform(translationX: 0.0, y: 0.0)
            self?.transform = scale.concatenating(translation)
            self?.alpha = 1.0
		}) { [weak self] (finished) in
            print(self?.frame, self?.transform)
		}
	}

}
