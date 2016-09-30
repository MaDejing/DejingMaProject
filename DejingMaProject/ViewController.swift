//
//  ViewController.swift
//  DejingMaProject
//
//  Created by DejingMa on 16/9/28.
//  Copyright © 2016年 DejingMa. All rights reserved.
//

import UIKit

let kScreenWidth = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height
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
		
//		firstView = UIView.init(frame: CGRect(x: 20, y: 50, width: kScreenWidth-40, height: 100))
//		firstView.backgroundColor = UIColor.black
//		view.addSubview(firstView)
//		
//		let panGes = UIPanGestureRecognizer(target: self, action: #selector(panAction))
//		firstView.addGestureRecognizer(panGes)
//		firstView.isUserInteractionEnabled = true
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

