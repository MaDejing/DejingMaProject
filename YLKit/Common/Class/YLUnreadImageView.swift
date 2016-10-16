import UIKit

class YLUnreadImageView: YLRedCircleImageView {

    fileprivate var label: UILabel!
    
    var unread: Int = 0 {
        didSet {
            isHidden = (unread <= 0)
            label.text = "\(unread)"
        }
    }
    
    var textFont: UIFont = UIFont.systemFont(ofSize: 14.0) {
        didSet {
            label.font = textFont
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        
        label = UILabel(frame: bounds)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14.0)
        addSubview(label)
    }
}
