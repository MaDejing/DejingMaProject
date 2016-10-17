//
//  SysCameraViewController.swift
//  DejingMaProject
//
//  Created by DejingMa on 16/10/12.
//  Copyright © 2016年 DejingMa. All rights reserved.
//

import UIKit
import AVFoundation

class SysCameraViewController: UIViewController {

	let imagePickerController: UIImagePickerController = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		view.backgroundColor = UIColor.white
		
		let cameraButton = UIButton(type: .custom)
		cameraButton.frame = CGRect(x: 20, y: 150, width: 100, height: 30)
		cameraButton.setTitle("调用相机", for: .normal)
		cameraButton.setTitleColor(UIColor.black, for: .normal)
		cameraButton.addTarget(self, action: #selector(openSysCamera), for: .touchUpInside)
		
		view.addSubview(cameraButton)
		
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
	
	func openSysCamera() {
		let authStatus: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
		if authStatus == .notDetermined {
			AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted) in
				DispatchQueue.main.async { [weak self] in
					if !granted {
						let vc = ChangeStatusVC()
						let nav = UINavigationController(rootViewController: vc)
						nav.navigationBar.isTranslucent = true
						self?.present(nav, animated: true, completion: nil)
					} else {
						self?.present((self?.imagePickerController)!, animated: true, completion: nil)
					}
				}
			})
		} else if (authStatus == .denied || authStatus == .restricted) {
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

extension SysCameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		//获取到拍摄的照片, UIImagePickerControllerEditedImage是经过剪裁过的照片,UIImagePickerControllerOriginalImage是原始的照片
		let image = info[UIImagePickerControllerOriginalImage] as! UIImage
		
		//调用方法保存到图像库中
		UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
		
		dismiss(animated: true, completion: nil)
	}
}
