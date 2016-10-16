import UIKit

class YLViewController: UIViewController {
    
    fileprivate var _statusBarStyle = UIStatusBarStyle.default
    fileprivate var _statusBarHidden = false
    fileprivate var _statusBarUpdateAnimation = UIStatusBarAnimation.slide
    
    fileprivate var _navigationBarHidden = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(_navigationBarHidden, animated: animated)
        super.viewWillAppear(animated)
    }
}

extension YLViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return _statusBarStyle
    }
    
    override var prefersStatusBarHidden: Bool {
        return _statusBarHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return _statusBarUpdateAnimation
    }
}

extension YLViewController {
    
    func updateStatusBarStyle(style: UIStatusBarStyle) {
        _statusBarStyle = style
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func showStatusBar(animation _animation: UIStatusBarAnimation? = nil) {
        _statusBarHidden = false
        if let animation = _animation {
            _statusBarUpdateAnimation = animation
        }
        else {
            _statusBarUpdateAnimation = .slide
        }
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func hideStatusBar(animation _animation: UIStatusBarAnimation? = nil) {
        _statusBarHidden = true
        if let animation = _animation {
            _statusBarUpdateAnimation = animation
        }
        else {
            _statusBarUpdateAnimation = .slide
        }
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func showNavigationBar(animated _animated: Bool = true) {
        _navigationBarHidden = false
        navigationController?.setNavigationBarHidden(_navigationBarHidden, animated: _animated)
    }
    
    func hideNavigationBar(animated _animated: Bool = true) {
        _navigationBarHidden = true
        navigationController?.setNavigationBarHidden(_navigationBarHidden, animated: _animated)
    }
}
