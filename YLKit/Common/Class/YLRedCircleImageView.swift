import UIKit

class YLRedCircleImageView: YLCircleImageView {

    override var image: UIImage? {
        set { super.image = UIImage.solidColorImage(fillColor: UIColor(ARGBHEX: 0xFFF2472F), size: frame.size) }
        get { return super.image }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        image = UIImage.solidColorImage(fillColor: UIColor(ARGBHEX: 0xFFF2472F), size: frame.size)
    }
}
