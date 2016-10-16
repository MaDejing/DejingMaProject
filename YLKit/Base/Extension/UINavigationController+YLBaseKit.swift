
// for YLViewController -> preferredStatusBarStyle
extension UINavigationController {

//    open override var childViewControllerForStatusBarStyle: UIViewController? {
//        return topViewController
//    }
    
    open override var childViewControllerForStatusBarHidden: UIViewController? {
        return topViewController
    }
}
