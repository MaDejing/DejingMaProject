
extension YLButton {

    static var largeButtonOrigin: CGFloat { return 8.0 }
    static var largeButtonWidth: CGFloat { return UIScreen.mainWidth - 16.0 }
    static var largeButtonHeight: CGFloat { return 40.0 }
    
    static var largeButton: YLButton {
        let button = YLButton(frame: CGRect(x: YLButton.largeButtonOrigin, y: 0.0, width: YLButton.largeButtonWidth, height: YLButton.largeButtonHeight))
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 4.0
        button.setBackgroundImage(UIImage.solidColorImage(fillColor: UIColor.white), for: .normal)
        button.setTitleColor(UIColor(ARGBHEX: 0xFF151518), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        return button
    }
}
