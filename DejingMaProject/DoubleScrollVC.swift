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
	
	@IBOutlet weak var refreshViewBottom: NSLayoutConstraint!
	@IBOutlet weak var refreshImage: UIImageView!
	
    @IBOutlet weak var scrollViewA: UIScrollView!
	@IBOutlet weak var tableView: UITableView!
	
	fileprivate var historyOffsetY: CGFloat!
	fileprivate let maxMoveDistance: CGFloat = 50.0
	fileprivate let multiAlphaViewTop: CGFloat = 3.0
	
	fileprivate var chooseView: UIView!
	fileprivate var modalView: UIView!
	fileprivate var chooseViewHeight: CGFloat!
	
	fileprivate var topPullToRefresher: PullToRefresh!
	
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
		
		if offset.y <= 0 {
			refreshViewBottom.constant = -offset.y
			refreshImage.alpha = max(0, min(0.3 + 0.7 * -offset.y / 16, 1))
		}
		
		alphaView.alpha = max(0, min(1 - offset.y/maxMoveDistance, 1))
    }
	
	fileprivate func addTableViewRefresh() {
		let refreshView = MyRefreshView()
		refreshView.frame.size.height = 40
		
		topPullToRefresher = PullToRefresh(refreshView: refreshView, animator: MyViewAnimator(animateView: refreshView), height: 40, position: .top)
		topPullToRefresher.animationDuration = 0.5
		topPullToRefresher.springDamping = 1
		
		tableView.addPullToRefresh(topPullToRefresher) { [weak self] in
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
//		tableView.decelerationRate = 0.1
	}
}

extension DoubleScrollVC {
    @IBAction func popVC(_ sender: AnyObject) {
		_ = navigationController?.popViewController(animated: true)
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

		let newHeaderViewTop = offset.y < maxMoveDistance ? 0 : min(-self.alphaViewHeight.constant, -offset.y)
		let newAlphaViewTop = offset.y < maxMoveDistance ? 0 : max(self.alphaViewHeight.constant, offset.y)/self.multiAlphaViewTop
		let newOffsetY = offset.y < maxMoveDistance ? 0 : max(self.alphaViewHeight.constant, offset.y)
		
		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: [.curveLinear], animations: {
			self.headerViewTop.constant = newHeaderViewTop
			self.alphaViewTop.constant = newAlphaViewTop
			self.tableView.contentOffset.y = newOffsetY
			
			self.headerView.layoutIfNeeded()
			self.view.layoutIfNeeded()
			}, completion: nil)
	}
}

extension DoubleScrollVC: NormalTableViewCellDelegate {
	func closeModal(_ ges: UITapGestureRecognizer) {
		let point = ges.location(in: modalView)
		guard !chooseView.frame.contains(point) else { return }
		
		modalView.removeFromSuperview()
	}
	
	func initModalView() {
		modalView = UIView(frame: UIScreen.main.bounds)
		modalView.backgroundColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.3)
		modalView.alpha = 0
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(closeModal))
		modalView.addGestureRecognizer(tap)
	}
	
	func initChooseView(point: CGPoint, isHigher: Bool) {
		
		let y: CGFloat = isHigher ? (point.y - 10) : (point.y + 10)
		
		chooseView = UIView(frame: CGRect(origin: CGPoint(x: point.x, y: y), size: CGSize.zero))
		chooseView.backgroundColor = UIColor.red
		
		initModalView()

		modalView.addSubview(chooseView)
		mainWindow.addSubview(modalView)
	}
	
	func afterShowModalClick(cell: NormalTableViewCell, buttonFrame: CGRect) {
		let buttonTopInWindow = mainWindow.convert(CGPoint(x: buttonFrame.midX, y: buttonFrame.minY), from: cell)
		let buttonBottomInWindow = CGPoint(x: buttonTopInWindow.x, y: buttonTopInWindow.y+buttonFrame.height)
		
		let isHigher: Bool
		let pointForChooseView: CGPoint
		chooseViewHeight = 100
		
		if buttonTopInWindow.y < kScreenHeight / 2 {
			isHigher = false
			pointForChooseView = buttonBottomInWindow
		} else {
			isHigher = true
			pointForChooseView = buttonTopInWindow
		}
		
		initChooseView(point: pointForChooseView, isHigher: isHigher)

		let y: CGFloat = isHigher ? (pointForChooseView.y - 10 - chooseViewHeight) : (pointForChooseView.y + 10)

		UIView.animate(withDuration: 0.3, animations: {
			self.modalView.alpha = 1
			self.chooseView.frame = CGRect(x: 20, y: y, width: kScreenWidth-40, height: self.chooseViewHeight)
		})
	}
}

extension DoubleScrollVC: UITableViewDelegate, UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 20
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch indexPath.row {
		case 0:
			let cell = tableView.dequeueReusableCell(withIdentifier: "topCell", for: indexPath)
			return cell
		default:
			let cell = tableView.dequeueReusableCell(withIdentifier: NormalTableViewCell.getCellIdentify(), for: indexPath) as! NormalTableViewCell
			cell.delegate = self
			
			cell.label.text = String(indexPath.row+1)
			
			return cell
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch indexPath.row {
		case 0:
			return headerViewHeight.constant
		default:
			return 80
		}
	}
}
