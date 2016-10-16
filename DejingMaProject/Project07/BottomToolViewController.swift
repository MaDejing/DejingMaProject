//
//  BottomToolViewController.swift
//  DejingMaProject
//
//  Created by yolo on 2016/10/16.
//  Copyright © 2016年 DejingMa. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class BottomToolViewController: UIViewController {

    fileprivate var m_bottomToolView: BottomToolView!
    
    fileprivate let imagePickerController: UIImagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        
        m_bottomToolView = BottomToolView()
        m_bottomToolView.m_delegate = self
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        button.center = view.center
        button.setTitle("点击出现底栏", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(bottomToolShow), for: .touchUpInside)
        
        view.addSubview(button)
        
        imagePickerController.delegate = self
        
        imagePickerController.modalTransitionStyle = .coverVertical
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .camera
        imagePickerController.mediaTypes = ["public.image"]
        imagePickerController.cameraCaptureMode = .photo
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func bottomToolShow() {
        m_bottomToolView.show()
    }

}

extension BottomToolViewController: BottomToolViewDelegate {
    func afterRedPacketClick(bottomToolView: BottomToolView) {
        m_bottomToolView.dismiss()
    }
    
    func afterPhotoPickerClick(bottomToolView: BottomToolView) {
        m_bottomToolView.dismiss()
        let photoLibrayStatus: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoLibrayStatus {
        case .notDetermined:
            break
            
        case .denied, .restricted:
            let alert = UIAlertController(title: nil, message: "请您设置允许APP访问您的照片\n设置>隐私>照片", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
            
        case .authorized:
            let vc = MyPhotoPickerVC()
            let nav = UINavigationController(rootViewController: vc)
            nav.navigationBar.isTranslucent = true
            present(nav, animated: true, completion: nil)
        }
    }
    
    func afterCameraClick(bottomToolView: BottomToolView) {
        m_bottomToolView.dismiss()

        let authStatus: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        if (authStatus == .denied || authStatus == .restricted) {
            let alert = UIAlertController(title: nil, message: "请您设置允许APP访问您的相机\n设置>隐私>相机", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
        } else {
            present(imagePickerController, animated: true, completion: {
                
            })
        }
    }
}

extension BottomToolViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //获取到拍摄的照片, UIImagePickerControllerEditedImage是经过剪裁过的照片,UIImagePickerControllerOriginalImage是原始的照片
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        //调用方法保存到图像库中
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
        
        dismiss(animated: true, completion: nil)
    }
}

