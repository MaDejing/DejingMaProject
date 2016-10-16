
class YLCircleImageView: UIImageView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        let diameter = min(frame.width, frame.height)
        var newFrame = frame
        newFrame.size = CGSize(width: diameter, height: diameter)
        super.init(frame: newFrame)
        layer.masksToBounds = true
        layer.cornerRadius = diameter / 2.0
    }
}
