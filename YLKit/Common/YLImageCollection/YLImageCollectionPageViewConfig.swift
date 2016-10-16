
struct YLImageCollectionPageViewConfig {
    
    fileprivate var _y: CGFloat
    fileprivate var _height: CGFloat
    fileprivate var _pageControlHeight: CGFloat
    fileprivate var _imageViewSize: CGSize
    fileprivate var _cellHighlightedColor: UIColor
    fileprivate var _cellCornerRadius: CGFloat
    fileprivate var _cellSize: CGSize
    fileprivate var _cellXSpace: CGFloat
    fileprivate var _cellYSpace: CGFloat
    fileprivate var _top: CGFloat
    fileprivate var _bottom: CGFloat
    fileprivate var _left: CGFloat
    fileprivate var _right: CGFloat

    init() {
        _y = UIScreen.mainHeight - 190.0
        _height = 190.0
        _pageControlHeight = 25.0
        _imageViewSize = CGSize(width: 55.0, height: 55.0)
        _cellHighlightedColor = UIColor(white: 1.0, alpha: 0.1)
        _cellCornerRadius = 6.0
        _cellSize = CGSize(width: 60.0, height: 60.0)
        _cellYSpace = 15.0
        _top = 20.0
        _bottom = 35.0

        switch UIScreen.mainWidth {
        case 320.0:
            _cellXSpace = 15.0
            _left = (UIScreen.mainWidth - 285.0) / 2.0
            _right = (UIScreen.mainWidth - 285.0) / 2.0
            
        case 375.0:
            _cellXSpace = 25.0
            _left = (UIScreen.mainWidth - 315.0) / 2.0
            _right = (UIScreen.mainWidth - 315.0) / 2.0
            
        case 414.0:
            _cellXSpace = 38.0
            _left = (UIScreen.mainWidth - 354.0) / 2.0
            _right = (UIScreen.mainWidth - 354.0) / 2.0
            
        default:
            _cellXSpace = 0.0
            _left = 0.0
            _right = 0.0
        }
    }
}

extension YLImageCollectionPageViewConfig {
    var y: CGFloat {
        set { _y = newValue }
        get { return _y }
    }
    var height: CGFloat {
        set { _height = newValue }
        get { return _height }
    }
    var pageControlHeight: CGFloat {
        set { _pageControlHeight = newValue }
        get { return _pageControlHeight }
    }
    var imageViewSize: CGSize {
        set { _imageViewSize = newValue }
        get { return _imageViewSize }
    }
    var cellHighlightedColor: UIColor {
        set { _cellHighlightedColor = newValue }
        get { return _cellHighlightedColor }
    }
    var cellCornerRadius: CGFloat {
        set { _cellCornerRadius = newValue }
        get { return _cellCornerRadius }
    }
    var cellSize: CGSize {
        set { _cellSize = CGSize(width: newValue.height, height: newValue.width) }
        get { return _cellSize }
    }
    var cellXSpace: CGFloat {
        set { _cellXSpace = newValue }
        get { return _cellXSpace }
    }
    var cellYSpace: CGFloat {
        set { _cellYSpace = newValue }
        get { return _cellYSpace }
    }
    var top: CGFloat {
        set { _top = newValue }
        get { return _top }
    }
    var bottom: CGFloat {
        set { _bottom = newValue }
        get { return _bottom }
    }
    var left: CGFloat {
        set { _left = newValue }
        get { return _left }
    }
    var right: CGFloat {
        set { _right = newValue }
        get { return _right }
    }
}
