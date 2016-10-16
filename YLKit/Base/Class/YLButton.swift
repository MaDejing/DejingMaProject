import UIKit

class YLButton: UIButton {
    
    fileprivate var _imageViewFrame: CGRect = CGRect.zero
    fileprivate var _titleLabelFrame: CGRect = CGRect.zero
    
    var imageViewFrame: CGRect {
        set {
            _imageViewFrame = newValue
            setNeedsLayout()
        }
        get { return _imageViewFrame }
    }
    
    var titleLabelFrame: CGRect {
        set {
            _titleLabelFrame = newValue
            setNeedsLayout()
        }
        get { return _titleLabelFrame }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if _imageViewFrame != CGRect.zero { imageView?.frame = _imageViewFrame }
        if _titleLabelFrame != CGRect.zero { titleLabel?.frame = _titleLabelFrame }
    }
}
