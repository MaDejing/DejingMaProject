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

}
