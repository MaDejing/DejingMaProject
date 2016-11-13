//
//  MDJImageVC.swift
//  DejingMaProject
//
//  Created by DejingMa on 16/11/9.
//  Copyright © 2016年 DejingMa. All rights reserved.
//

import UIKit

class MDJImageVC: UIViewController {

	fileprivate var m_imageView: MDJScrollImageView!
    fileprivate var m_collectionView: UICollectionView!
    fileprivate var conView: UIView!
    
    let m_itemSpace = MDJScrollImageCell.m_spacing
    let m_pageWidth: CGFloat = kScreenWidth
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		view.backgroundColor = UIColor.white
		
		let button = UIButton(frame: CGRect(x: 20, y: 100, width: 200, height: 50))
		button.setTitle("点击出现大图", for: .normal)
		button.setTitleColor(UIColor.black, for: .normal)
		button.addTarget(self, action: #selector(MDJImageVC.showCollectionView(_:)), for: .touchUpInside)
		
		view.addSubview(button)
        
        let button2 = UIButton(frame: CGRect(x: kScreenWidth-100, y: 100, width: 100, height: 50))
        button2.setTitle("随机切换", for: .normal)
        button2.setTitleColor(UIColor.black, for: .normal)
        button2.addTarget(self, action: #selector(MDJImageVC.changeSize(_:)), for: .touchUpInside)
        view.addSubview(button2)
        
        conView = UIView(frame: CGRect(x: 100, y: 400, width: 100, height: 200))
        conView.backgroundColor = UIColor.clear
        conView.clipsToBounds = true
        view.addSubview(conView)
        
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        m_collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: conView.frame.width+m_itemSpace, height: conView.frame.height), collectionViewLayout: collectionViewFlowLayout)
        m_collectionView.showsHorizontalScrollIndicator = false
        m_collectionView.isPagingEnabled = true
        
        m_collectionView.backgroundColor = UIColor.color(RGBHEX: 0x232329, alpha: 1.0)
        
        m_collectionView.delegate = self
        m_collectionView.dataSource = self
        
        m_collectionView.contentOffset = CGPoint.zero
        m_collectionView.contentSize = CGSize(width: 5*m_collectionView.frame.width, height: m_collectionView.frame.height)
        
        m_collectionView.register(MDJScrollImageCell.self, forCellWithReuseIdentifier: MDJScrollImageCell.getCellIdentifier())
        
        collectionViewFlowLayout.minimumLineSpacing = 0
        collectionViewFlowLayout.minimumInteritemSpacing = 0
        collectionViewFlowLayout.itemSize = m_collectionView.frame.size
        collectionViewFlowLayout.scrollDirection = .horizontal
        
        m_collectionView.isHidden = true
        
        conView.addSubview(m_collectionView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
    @objc fileprivate func showCollectionView(_ sender: UIButton) {
        m_collectionView.isHidden = !m_collectionView.isHidden
    }
    
    @objc fileprivate func changeSize(_ sender: UIButton) {
        let smallSize = CGRect(x: 100, y: 400, width: 100, height: 200)
        conView.frame = conView.frame == smallSize ? CGRect(x: 0, y: 300, width: m_pageWidth, height: 300) : smallSize
        m_collectionView.frame = CGRect(x: 0, y: 0, width: conView.frame.width+m_itemSpace, height: conView.frame.height)
        (m_collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize = m_collectionView.frame.size
        
        m_collectionView.contentOffset = CGPoint.zero
        m_collectionView.contentSize = CGSize(width: 5*m_collectionView.frame.width, height: m_collectionView.frame.height)
        
        m_collectionView.reloadData()
    }
    
	@objc fileprivate func showImageView(_ sender: UIButton) {
        m_imageView = MDJScrollImageView(frame: CGRect(x: 0, y: 300, width: 200, height: 300), maxZoomScale: 2.0, minZoomScale: 0.5)
		m_imageView.setImageWithName(name: "image01")
        m_imageView.setImageSize(CGSize(width: 100, height: 50))
        m_imageView.setRadius(radius: 10.0)

        m_imageView.show(superView: view, startRect: sender.frame, duration: 0.3)
    }

    @objc fileprivate func changeMode(_ sender: UIButton) {
        m_imageView.setImageSize(with: MDJScrollImageViewMode(rawValue: Int(arc4random_uniform(4)))!)
    }
}

extension MDJImageVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MDJScrollImageCell.getCellIdentifier(), for: indexPath) as! MDJScrollImageCell
        
        cell.updateWithData(img: UIImage(named: "image01")!, mode: .aspectFill)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? MDJScrollImageCell else { return }
        cell.imageResize()
    }
}

