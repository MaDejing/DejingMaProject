//
//  MDJScrollImageCell.swift
//  DejingMaProject
//
//  Created by yolo on 2016/11/12.
//  Copyright © 2016年 DejingMa. All rights reserved.
//

import UIKit

class MDJScrollImageCell: UICollectionViewCell {
    
    fileprivate var m_imageCon: MDJScrollImageView!
    fileprivate var m_mode: MDJScrollImageViewMode = .aspectFit
    static var m_spacing: CGFloat = 10.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
    }
    
    static func getCellIdentifier() -> String {
        return "MDJScrollImageCell"
    }
    
    public func updateWithData(img: UIImage, mode: MDJScrollImageViewMode) {
        m_imageCon = MDJScrollImageView(frame: CGRect(x: 0, y: 0, width: frame.width-MDJScrollImageCell.m_spacing, height: frame.height))
        addSubview(m_imageCon)
        
        m_mode = mode

        m_imageCon.setImage(with: img)
        m_imageCon.setImageSize(with: m_mode)
        m_imageCon.setRadius(radius: 10.0)
    }
    
    public func imageResize() {
        m_imageCon = MDJScrollImageView(frame: CGRect(x: 0, y: 0, width: frame.width-MDJScrollImageCell.m_spacing, height: frame.height))
        m_imageCon.setImageSize(with: m_mode)
    }
}
