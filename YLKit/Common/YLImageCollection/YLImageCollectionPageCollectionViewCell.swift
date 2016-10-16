
class YLImageCollectionPageCollectionViewCell: UICollectionViewCell {
    
    fileprivate var _cellHighlightedColor: UIColor? = UIColor(white: 1.0, alpha: 0.1)
    
    fileprivate var _item: YLImageCollectionItem?
    
    fileprivate var _imageView: UIImageView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 6.0
        
        _imageView = UIImageView(frame: CGRect(x: 2.5, y: 2.5, width: 55.0, height: 55.0))
        _imageView.setShowActivityIndicator(true)
        _imageView.setIndicatorStyle(.white)
        addSubview(_imageView)
    }
}

extension YLImageCollectionPageCollectionViewCell {
    override var isHighlighted: Bool {
        didSet {
            guard _imageView.image != nil else { return }
            contentView.backgroundColor = isHighlighted ? _cellHighlightedColor : nil
        }
    }
}

extension YLImageCollectionPageCollectionViewCell {
    var item: YLImageCollectionItem? { return _item }
}

extension YLImageCollectionPageCollectionViewCell {

    func config(item _item: YLImageCollectionItem?,
                     cellHighlightedColor: UIColor?,
                     cellCornerRadius: CGFloat,
                     imageViewSize: CGSize)
    {
        self._item = _item
        
        _imageView.image = nil
        if let image = self._item?.image {
            _imageView.image = image
        }
        if let url = self._item?.url {
            _imageView.sd_setImageWithPreviousCachedImage(with: url as URL!, placeholderImage: nil, options: .retryFailed, progress: nil, completed: nil)
        }
        
        _cellHighlightedColor = cellHighlightedColor
        
        contentView.layer.cornerRadius = cellCornerRadius
        
        _imageView.frame.size = CGSize(width: imageViewSize.height, height: imageViewSize.width)
    }
}
