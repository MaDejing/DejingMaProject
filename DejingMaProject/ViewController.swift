//
//  ViewController.swift
//  DejingMaProject
//
//  Created by DejingMa on 16/9/28.
//  Copyright © 2016年 DejingMa. All rights reserved.
//

import UIKit
import Photos

let mainWindow = UIApplication.shared.keyWindow!

class secondObject: NSObject, NSCopying, NSMutableCopying {
	var a: Int!
	
	init(a: Int) {
		self.a = a
	}
	
	func copy(with zone: NSZone? = nil) -> Any {
		let obj = secondObject(a: a)
		return obj
	}
	
	func mutableCopy(with zone: NSZone? = nil) -> Any {
		let obj = secondObject(a: a)
		return obj
	}
}

class ViewController: UIViewController {
	
	var firstView: UIView!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		let obj1 = secondObject(a: 1)
		let obj2 = obj1.copy() as! secondObject
		let obj3 = obj1.mutableCopy() as! secondObject
		obj2.a = 2
		obj3.a = 3
//		print(obj1.a, obj2.a, obj3.a)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func changeStatusColor(_ sender: AnyObject) {
		let vc = storyboard?.instantiateViewController(withIdentifier: "ChangeStatusVC") as! ChangeStatusVC
		let nav = UINavigationController(rootViewController: vc)
		present(nav, animated: true, completion: nil)
	}

	@IBAction func pushToDoubleScroll(_ sender: AnyObject) {
		let vc = storyboard?.instantiateViewController(withIdentifier: "DoubleScrollVC") as! DoubleScrollVC
		navigationController?.pushViewController(vc, animated: true)
	}
	
	@IBAction func pushToGCD(_ sender: AnyObject) {
		let vc = storyboard?.instantiateViewController(withIdentifier: "GCDViewController") as! GCDViewController
		navigationController?.pushViewController(vc, animated: true)
	}
	
	@IBAction func pushToPhotoKit(_ sender: AnyObject) {
		let photoLibrayStatus: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
		
		if photoLibrayStatus == .notDetermined {
			PHPhotoLibrary.requestAuthorization { (status) in
				DispatchQueue.main.async { [weak self] in
					if status == PHAuthorizationStatus.denied || status == PHAuthorizationStatus.restricted {
						let vc = ChangeStatusVC()
						let nav = UINavigationController(rootViewController: vc)
						nav.navigationBar.isTranslucent = true
						self?.present(nav, animated: true, completion: nil)
					} else if status == PHAuthorizationStatus.authorized {
						let vc = MyPhotoPickerVC()
						let nav = UINavigationController(rootViewController: vc)
						nav.navigationBar.isTranslucent = true
						self?.present(nav, animated: true, completion: nil)
					}
				}
			}
		} else if photoLibrayStatus == .denied || photoLibrayStatus == .restricted {
			let alert = UIAlertController(title: nil, message: "请您设置允许APP访问您的照片\n设置>隐私>照片", preferredStyle: .alert)
			let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
			
			alert.addAction(cancelAction)
			
			present(alert, animated: true, completion: nil)
		} else {
			let vc = MyPhotoPickerVC()
			let nav = UINavigationController(rootViewController: vc)
			nav.navigationBar.isTranslucent = true
			present(nav, animated: true, completion: nil)
		}
	}
	
	@IBAction func pushToCamera(_ sender: AnyObject) {
		let vc = SysCameraViewController()
		navigationController?.pushViewController(vc, animated: true)
	}
    
    @IBAction func pushToPageEnable(_ sender: AnyObject) {
        let vc = PageEnableScrollViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func pushToBottomTool(_ sender: AnyObject) {
        let vc  = BottomToolViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
	
	@IBAction func pushToBottomTab(_ sender: AnyObject) {
		let vc  = BottomTabViewController()
//		present(vc, animated: true, completion: nil)
	}
	
	func panAction(_ ges: UIPanGestureRecognizer) {
		//1.取到图片中点坐标
		let centerPoint = firstView.center
		//2.获取拖拽手势相对于当前视图的偏移位置
		let point = ges.translation(in: view)
		
		//3.计算图片新的坐标
		firstView.center = CGPoint(x: centerPoint.x, y: centerPoint.y+point.y)
		//4.每拖拽一点，就将translation设置为CGPointZero，否则每次拖拽都会在原有基础上累加
		if ges.state == .changed {
			ges.setTranslation(CGPoint.zero, in: view)
		}
	}

}

