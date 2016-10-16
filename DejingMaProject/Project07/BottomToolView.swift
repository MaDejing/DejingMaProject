//
//  BottomToolView.swift
//  DejingMaProject
//
//  Created by yolo on 2016/10/16.
//  Copyright © 2016年 DejingMa. All rights reserved.
//

import UIKit
import Foundation

protocol BottomToolViewDelegate: NSObjectProtocol {
    func afterRedPacketClick(bottomToolView: BottomToolView)
    func afterPhotoPickerClick(bottomToolView: BottomToolView)
    func afterCameraClick(bottomToolView: BottomToolView)
}

class BottomToolView: UIView {
    
    fileprivate var m_displayByShow: Bool = false
    fileprivate var m_config: BottomToolViewConfig!
    fileprivate var m_redPacketButton: BottomToolViewButton!
    fileprivate var m_photoPickerButton: BottomToolViewButton!
    fileprivate var m_cameraButton: BottomToolViewButton!
    
    weak var m_delegate: BottomToolViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.8)
        m_config = BottomToolViewConfig()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        frame = CGRect(x: 0, y: kScreenHeight - m_config.height, width: kScreenWidth, height: m_config.height)
        
        m_redPacketButton = BottomToolViewButton(frame: CGRect(x: 0, y: 17.5, width: 62.5, height: 62.5))
        m_redPacketButton.center.x = 42.5 + 20
        m_photoPickerButton = BottomToolViewButton(frame: CGRect(x: 0, y: 17.5, width: 62.5, height: 62.5))
        m_photoPickerButton.center.x = self.center.x
        m_cameraButton = BottomToolViewButton(frame: CGRect(x: 0, y: 17.5, width: 62.5, height: 62.5))
        m_cameraButton.center.x = kScreenWidth-42.5-20
        
        m_redPacketButton.setImage(UIImage(named: "image01"), for: .normal)
        m_redPacketButton.setImage(UIImage(named: "image01"), for: .highlighted)
        m_redPacketButton.setTitle("发红包", for: .normal)
        m_redPacketButton.addTarget(self, action: #selector(BottomToolView.redPacketClick), for: .touchUpInside)
        
        m_photoPickerButton.setImage(UIImage(named: "image01"), for: .normal)
        m_photoPickerButton.setImage(UIImage(named: "image01"), for: .highlighted)
        m_photoPickerButton.setTitle("图片", for: .normal)
        m_photoPickerButton.addTarget(self, action: #selector(BottomToolView.photoPickerClick), for: .touchUpInside)
        
        m_cameraButton.setImage(UIImage(named: "image01"), for: .normal)
        m_cameraButton.setImage(UIImage(named: "image01"), for: .highlighted)
        m_cameraButton.setTitle("拍摄", for: .normal)
        m_cameraButton.addTarget(self, action: #selector(BottomToolView.cameraClick), for: .touchUpInside)
        
        self.addSubview(m_redPacketButton)
        self.addSubview(m_photoPickerButton)
        self.addSubview(m_cameraButton)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if !bounds.contains(point) { dismiss() }
        
        return super.point(inside: point, with: event)
    }
    
}

extension BottomToolView {

    func show() {
        guard let delegate = UIApplication.shared.delegate, let optionalWindow = delegate.window, let window = optionalWindow, window.isKeyWindow
            else { return }
        
        for subview in window.subviews {
            guard !subview.isKind(of: BottomToolView.self) else { return }
        }
        
        window.addSubview(self)
        
        frame.origin.y = kScreenHeight - m_config.height
        transform = CGAffineTransform(translationX: 0, y: m_config.height)
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.transform = CGAffineTransform(translationX: 0, y: 0)
        }) { [weak self] (finished) in
            self?.m_displayByShow = true
        }
    }
    
    func dismiss() {
        guard m_displayByShow else { return }
        
        let height = m_config.height
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.transform = CGAffineTransform(translationX: 0, y: height)
        }) { [weak self] (finished) in
            self?.transform = CGAffineTransform(translationX: 0, y: 0)
            self?.removeFromSuperview()
        }
    }

}

extension BottomToolView {
    
    func redPacketClick() {
        m_delegate?.afterRedPacketClick(bottomToolView: self)
    }
    
    func photoPickerClick() {
        m_delegate?.afterPhotoPickerClick(bottomToolView: self)
    }
    
    func cameraClick() {
        m_delegate?.afterCameraClick(bottomToolView: self)
    }
}

