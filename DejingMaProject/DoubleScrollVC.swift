//
//  DoubleScrollVC.swift
//  DejingMaProject
//
//  Created by DejingMa on 16/9/28.
//  Copyright © 2016年 DejingMa. All rights reserved.
//

import UIKit

class DoubleScrollVC: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerViewTop: NSLayoutConstraint!
	@IBOutlet weak var headerViewHeight: NSLayoutConstraint!
	
	@IBOutlet weak var alphaView: UIView!
	@IBOutlet weak var alphaViewHeight: NSLayoutConstraint!
	@IBOutlet weak var alphaViewTop: NSLayoutConstraint!
	
    @IBOutlet weak var scrollViewA: UIScrollView!
	@IBOutlet weak var tableView: UITableView!
	
	fileprivate var historyOffsetY: CGFloat!
	let maxMoveDistance: CGFloat = 50.0
	let multiAlphaViewTop: CGFloat = 3.0
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		updateGestures()
		updateTableView()
		
		addObservers()
		addTableViewRefresh()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.setNavigationBarHidden(true, animated: true)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		navigationController?.setNavigationBarHidden(false, animated: true)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	deinit {
		removeObservers()
		removeTableViewRefresh()
	}
}

extension DoubleScrollVC {
	
	fileprivate func addObservers() {
		tableView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
	}
	
	fileprivate func removeObservers() {
		tableView.removeObserver(self, forKeyPath: "contentOffset")
	}
	
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let offset: CGPoint = tableView.contentOffset
		
		if tableView.isDragging {
			headerViewTop.constant = min(-offset.y, 0)
			alphaViewTop.constant = max(offset.y/multiAlphaViewTop, 0)
		}
		
		alphaView.alpha = 1 - offset.y/maxMoveDistance
    }
	
	fileprivate func addTableViewRefresh() {
		let refreshView = MyRefreshView()
		refreshView.frame.size.height = 40
		
		let refresher = PullToRefresh(refreshView: refreshView, animator: MyViewAnimator(animateView: refreshView), height: 40, position: .top)
		refresher.animationDuration = 0.5
		refresher.springDamping = 1
		
		tableView.addPullToRefresh(refresher) { [weak self] in
			let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
			DispatchQueue.main.asyncAfter(deadline: delayTime) {
				self?.tableView.endRefreshing(at: .top)
			}
		}
		
//		tableView.startRefreshing(at: .top)
	}
	
	fileprivate func removeTableViewRefresh() {
		tableView.removePullToRefresh(tableView.topPullToRefresh!)
	}

}

extension DoubleScrollVC {
	fileprivate func updateGestures() {
		for ges in scrollViewA.gestureRecognizers! {
			scrollViewA.removeGestureRecognizer(ges)
		}
		
		for ges in tableView.gestureRecognizers! {
			tableView.addGestureRecognizer(ges)
		}
	}
	
	fileprivate func updateTableView() {
		tableView.scrollIndicatorInsets = UIEdgeInsetsMake(headerViewHeight.constant, 0, 0, 0)
	}
}

extension DoubleScrollVC: UIScrollViewDelegate {
	
	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		guard tableView == scrollView else { return }

		historyOffsetY = scrollView.contentOffset.y
	}
	
	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		guard tableView == scrollView else { return }
		
		let offset = scrollView.contentOffset
		
		if !decelerate{
			if (offset.y > historyOffsetY && historyOffsetY >= 0) ||
				(offset.y < historyOffsetY && historyOffsetY > 0) {
				
				updateViewAfterScroll(scrollView: scrollView)
			}
		}
	}
	
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		guard tableView == scrollView else { return }
		
		updateViewAfterScroll(scrollView: scrollView)
	}
	
	func updateViewAfterScroll(scrollView: UIScrollView) {
		let offset = scrollView.contentOffset

		guard offset.y >= 0 else { return }
		
		if offset.y < maxMoveDistance {
			UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: [.curveLinear], animations: {
				self.headerViewTop.constant = 0
				self.alphaViewTop.constant = 0
				self.tableView.contentOffset.y = 0
				
				self.headerView.layoutIfNeeded()
				self.view.layoutIfNeeded()
				}, completion: nil)
			
		} else {
			UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: [.curveLinear], animations: {
				self.headerViewTop.constant = min(-self.alphaViewHeight.constant, -offset.y)
				self.alphaViewTop.constant = max(self.alphaViewHeight.constant, offset.y)/self.multiAlphaViewTop
				self.tableView.contentOffset.y = max(self.alphaViewHeight.constant, offset.y)
				
				self.headerView.layoutIfNeeded()
				self.view.layoutIfNeeded()
				}, completion: nil)
		}
	}
}

extension DoubleScrollVC {
    @IBAction func popVC(_ sender: AnyObject) {
		_ = navigationController?.popViewController(animated: true)
	}
}

extension DoubleScrollVC: UITableViewDelegate, UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 4
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0, 2 :
			return 1
		case 1:
			return 20
		case 3:
			return 3
		default:
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell: UITableViewCell!
		switch indexPath.section {
		case 0:
			cell = tableView.dequeueReusableCell(withIdentifier: "topCell", for: indexPath)
		default:
			cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		}
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch indexPath.section {
		case 0:
			return headerViewHeight.constant
		default:
			return 80
		}
	}
}
