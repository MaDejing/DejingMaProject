import UIKit

class YLCustomActionSheet: UIView {
    
    fileprivate var _didClickButtonAt: ((_ index: Int) -> Void)?
    
    fileprivate var _containerView: UIView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.mainBounds)
        alpha = 0.0
        backgroundColor = UIColor(white: 0.0, alpha: 0.64)
        
        _containerView = UIView(frame: CGRect(x: 0.0, y: UIScreen.mainHeight, width: UIScreen.mainWidth, height: 0.0))
        addSubview(_containerView)
    }
    
    convenience init(otherButtonTitles: [String], cancelButtonTitle: String = "取消") {
        self.init(frame: UIScreen.mainBounds)
        
        let buttonTitles = [cancelButtonTitle] + otherButtonTitles
        
        _containerView.frame.size.height = CGFloat(buttonTitles.count) * 48.0 + 8.0
        
        for i in 0..<buttonTitles.count {
            let button = YLButton(frame: CGRect(x: 8.0, y: CGFloat(otherButtonTitles.count - i) * 48.0 + 8.0, width: UIScreen.mainWidth - 16.0, height: 40.0))
            button.tag = i + 1000
            button.layer.masksToBounds = true
            button.layer.cornerRadius = 4.0
            button.setTitle(buttonTitles[i], for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
            button.addTarget(self, action: #selector(YLCustomActionSheet.buttonTouchedUpInside), for: .touchUpInside)
            if i == 0 {
                button.setBackgroundImage(UIImage.solidColorImage(fillColor: UIColor(ARGBHEX: 0xFFFFDD00)), for: .normal)
                button.setTitleColor(UIColor(ARGBHEX: 0xFF050505), for: .normal)
            }
            else {
                button.setBackgroundImage(UIImage.solidColorImage(fillColor: UIColor.white), for: .normal)
                button.setTitleColor(UIColor(ARGBHEX: 0xFF151518), for: .normal)
            }
            _containerView.addSubview(button)
        }
    }
}

// MARK: Public Property

extension YLCustomActionSheet {
    var didClickButtonAtIndex: ((_ index: Int) -> Void)? {
        set { _didClickButtonAt = newValue }
        get { return _didClickButtonAt }
    }
}

// MARK: Show & Dismiss

extension YLCustomActionSheet {
    
    func show() {
        guard let delegate = UIApplication.shared.delegate,
            let optionalWindow = delegate.window,
            let window = optionalWindow , window.isKeyWindow
            else { return }
        window.addSubview(self)
        
        let containerViewHeight = _containerView.frame.height
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.alpha = 1.0
            self?._containerView.transform = CGAffineTransform(translationX: 0.0, y: -containerViewHeight)
        }) { [weak self] (finished) in
            let tapView = UIView(frame: UIScreen.mainBounds)
            self?.insertSubview(tapView, at: 0)
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(YLCustomActionSheet.dismiss))
            tapView.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    @objc fileprivate func dismiss() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.alpha = 0.0
            self?._containerView.transform = CGAffineTransform(translationX: 0.0, y: 0.0)
        }) { [weak self] (finished) in
            self?.removeFromSuperview()
        }
    }
}

// MARK: Content View

extension YLCustomActionSheet {
    func insert(customView _view: UIView, atIndex _index: Int) {
        guard let button = viewWithTag(1000 + _index) as? YLButton else { return }
        
        var viewY = _view.frame.minY
        
        if let view = _containerView.viewWithTag(_index + 2000) {
            viewY = view.frame.minY
            view.removeFromSuperview()
        }
        else {
            viewY = button.frame.minY - 8.0
        }
        
        _view.frame.origin.y = viewY
        _view.tag = _index + 2000
        _containerView.addSubview(_view)
        
        let offset = _view.frame.maxY - button.frame.minY
        for subview in _containerView.subviews {
            if (subview.tag / 1000 == 1 && subview.tag % 1000 <= _index)
                || (subview.tag / 2000 == 1 && subview.tag % 2000 < _index )
            {
                subview.frame.origin.y += offset
            }
        }
        
        let containerViewHeight = viewWithTag(1000)!.frame.maxY + 8.0
        _containerView.frame.size.height = containerViewHeight
        if _containerView.transform.ty != 0.0 {
            _containerView.transform = CGAffineTransform(translationX: 0.0, y: -containerViewHeight)
        }
    }
}

// MARK: Button Touched

extension YLCustomActionSheet {
    @objc fileprivate func buttonTouchedUpInside(sender: YLButton) {
        _didClickButtonAt?(sender.tag % 1000)
        dismiss()
    }
}
