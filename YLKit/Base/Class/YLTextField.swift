
class YLTextField: UITextField {

    fileprivate var _clearButtonColor: UIColor?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateClearButtonColor()
    }
    
    fileprivate func updateClearButtonColor() {
        guard let color = _clearButtonColor , clearButtonMode != .never else { return }
        for subview in subviews {
            if let button = subview as? UIButton {
                let normalImage = button.image(for: .normal)?.changeColor(color: color)
                let highlightedImage = button.image(for: .highlighted)?.changeColor(color: color)
                button.setImage(normalImage, for: .normal)
                button.setImage(highlightedImage, for: .highlighted)
                return
            }
        }
    }
}

extension YLTextField {
    var clearButtonColor: UIColor? {
        set { _clearButtonColor = newValue }
        get { return _clearButtonColor }
    }
}
