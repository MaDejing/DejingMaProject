import UIKit

class YLImageCollectionPageView: UIView {

    fileprivate let imageCollectionPageCollectionViewCellIdentifier = "imageCollectionPageCollectionViewCell"
    
    fileprivate var _didDisplayByShow = false
    
    fileprivate var _didSelectImageCollectionItem: ((_ item: YLImageCollectionItem) -> Void)?
    
    fileprivate var _imageCollection: YLImageCollection!
    fileprivate var _config: YLImageCollectionPageViewConfig!
    
    fileprivate var _collectionView: UICollectionView!
    fileprivate var _pageControl: UIPageControl!

    var didSelectImageCollectionItem: ((_ item: YLImageCollectionItem) -> Void)? {
        set { _didSelectImageCollectionItem = newValue }
        get { return _didSelectImageCollectionItem }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(RGBHEX: 0x151518, alpha: 0.9)
    }
    
    convenience init(imageCollection: YLImageCollection,
                     config: YLImageCollectionPageViewConfig = YLImageCollectionPageViewConfig())
    {
        self.init(frame: CGRect.zero)

        _imageCollection = imageCollection
        _config = config
        
        frame = CGRect(x: 0.0, y: _config.y, width: UIScreen.mainWidth, height: _config.height)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = _config.cellSize
        layout.minimumLineSpacing = _config.cellXSpace
        layout.minimumInteritemSpacing = _config.cellYSpace
        layout.sectionInset = UIEdgeInsetsMake(_config.top, 0.0, _config.bottom, 0.0)
        layout.headerReferenceSize = CGSize(width: _config.left, height: _config.height)
        layout.footerReferenceSize = CGSize(width: _config.right, height: _config.height)
        
        _collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        _collectionView.bounces = false
        _collectionView.showsHorizontalScrollIndicator = false
        _collectionView.register(YLImageCollectionPageCollectionViewCell.self, forCellWithReuseIdentifier: imageCollectionPageCollectionViewCellIdentifier)
        _collectionView.dataSource = self
        _collectionView.delegate = self
        addSubview(_collectionView)
        
        _pageControl = UIPageControl(frame: CGRect(x: 0.0, y: _config.height - _config.pageControlHeight, width: UIScreen.mainWidth, height: _config.pageControlHeight))
        _pageControl.numberOfPages = _imageCollection.numberOfPages()
        _pageControl.currentPage = 0
        _pageControl.addTarget(self, action: #selector(YLImageCollectionPageView.handlePageControlValueChanged), for: .valueChanged)
        addSubview(_pageControl)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _collectionView.contentInset = UIEdgeInsets.zero
    }
}

// MARK: UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDelegateFlowLayout

extension YLImageCollectionPageView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
   
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return _imageCollection.numberOfPages()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _imageCollection.numberOfItems(atPage: section)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCollectionPageCollectionViewCellIdentifier, for: indexPath) as! YLImageCollectionPageCollectionViewCell
        cell.config(item: _imageCollection.item(atIndexPath: indexPath as NSIndexPath),
                    cellHighlightedColor: _config.cellHighlightedColor,
                    cellCornerRadius: _config.cellCornerRadius,
                    imageViewSize: _config.imageViewSize)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! YLImageCollectionPageCollectionViewCell
        if let item = cell.item {
            _didSelectImageCollectionItem?(item)
            dismiss()
        }
    }
}

// MARK: UIScrollViewDelegate 

extension YLImageCollectionPageView: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        let contentOffsetX = scrollView.contentOffset.x
        
        let offset = contentOffsetX.truncatingRemainder(dividingBy: UIScreen.mainWidth)
        if offset > UIScreen.mainWidth / 2.0 {
            let nextPage = Int(contentOffsetX / UIScreen.mainWidth) + 1
            if nextPage <= _pageControl.numberOfPages {
                _pageControl.currentPage = nextPage
                _pageControl.updateCurrentPageDisplay()
            }
        }
        else {
            let currentPage = Int(contentOffsetX / UIScreen.mainWidth)
            if currentPage <= _pageControl.numberOfPages && currentPage != _pageControl.currentPage {
                _pageControl.currentPage = currentPage
                _pageControl.updateCurrentPageDisplay()
            }
        }
        _collectionView.setContentOffset(CGPoint(x: CGFloat(_pageControl.currentPage) * UIScreen.mainWidth, y: 0.0), animated: true)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        let velocity = scrollView.panGestureRecognizer.velocity(in: self)
        if velocity.x <= 0.0 {
            if _pageControl.currentPage + 1 < _pageControl.numberOfPages {
                _pageControl.currentPage += 1
                _pageControl.updateCurrentPageDisplay()
                showCurrentPage()
            }
        }
        else {
            if _pageControl.currentPage - 1 >= 0 {
                _pageControl.currentPage -= 1
                _pageControl.updateCurrentPageDisplay()
                showCurrentPage()
            }
        }
    }
}

// MARK: Page Control

extension YLImageCollectionPageView {
    
    fileprivate func showCurrentPage() {
        _collectionView.setContentOffset(CGPoint(x: CGFloat(_pageControl.currentPage) * UIScreen.mainWidth, y: 0.0), animated: true)
    }
    
    @objc fileprivate func handlePageControlValueChanged() {
        showCurrentPage()
    }
}

// MARK: Show & Dismiss

extension YLImageCollectionPageView {

    override func point(inside point: CGPoint, with
        event: UIEvent?) -> Bool {
        if !bounds.contains(point) { dismiss() }
        return super.point(inside: point, with: event)
    }
    
    func show() {
        guard let delegate = UIApplication.shared.delegate,
            let optionalWindow = delegate.window,
            let window = optionalWindow , window.isKeyWindow
            else { return }
        
        for subview in window.subviews {
            guard !subview.isKind(of: YLImageCollectionPageView.self) else { return }
        }
        
        window.addSubview(self)
        
        frame.origin.y = UIScreen.mainHeight - _config.height
        transform = CGAffineTransform(translationX: 0.0, y: _config.height)
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.transform = CGAffineTransform(translationX: 0.0, y: 0.0)
        }) { [weak self] (finished) in
            self?._didDisplayByShow = true
        }
    }
    
    func dismiss() {
        guard _didDisplayByShow else { return }
        let height = _config.height
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.transform = CGAffineTransform(translationX: 0.0, y: height)
        }) { [weak self] (finished) in
            self?.transform = CGAffineTransform(translationX: 0.0, y: 0.0)
            self?.removeFromSuperview()
        }
    }
}
