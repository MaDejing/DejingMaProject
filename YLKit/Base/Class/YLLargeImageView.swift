import AssetsLibrary

class YLLargeImageView: UIView, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    fileprivate var _fixedImageViewCenter: CGPoint = CGPoint(x: UIScreen.mainWidth / 2.0, y: UIScreen.mainHeight / 2.0)
    fileprivate var _zoomScale: CGFloat = 1.0
    fileprivate var _enableSave: Bool = true
    fileprivate var _enableReplace: Bool = true

    fileprivate var _didReplace: ((_ image: UIImage) -> Void)?
    
    fileprivate var _scrollView: UIScrollView!
    fileprivate var _imageView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.mainBounds)
        backgroundColor = UIColor(ARGBHEX: 0xFF151518)
        alpha = 0.0
        
        _scrollView = UIScrollView(frame: bounds)
        _scrollView.backgroundColor = backgroundColor
        _scrollView.showsVerticalScrollIndicator = false
        _scrollView.showsHorizontalScrollIndicator = false
        addSubview(_scrollView)
        
        _imageView = UIImageView(frame: bounds)
        _imageView.backgroundColor = backgroundColor
        _imageView.isUserInteractionEnabled = true
        _scrollView.addSubview(_imageView)
    }
    
    convenience init(image: UIImage?,
                     fixedImageViewCenter: CGPoint = CGPoint(x: UIScreen.mainWidth / 2.0, y: UIScreen.mainHeight / 2.0),
                     zoomScale: CGFloat = 1.0,
                     enableSave: Bool = true,
                     enableReplace: Bool = true)
    {
        self.init(frame: UIScreen.mainBounds)

        if let image = image {
            _imageView.image = image
            _imageView.frame.size = CGSize(width: UIScreen.mainWidth, height: UIScreen.mainWidth / image.size.width * image.size.height)
        }
        
        commonInit(fixedImageViewCenter: fixedImageViewCenter, zoomScale: zoomScale, enableSave: enableSave, enableReplace: enableReplace)
    }
    
    convenience init(url: NSURL?,
                     placeholderImage: UIImage?,
                     fixedImageViewCenter: CGPoint = CGPoint(x: UIScreen.mainWidth / 2.0, y: UIScreen.mainHeight / 2.0),
                     zoomScale: CGFloat = 1.0,
                     enableSave: Bool = true,
                     enableReplace: Bool = true)
    {
        self.init(frame: UIScreen.mainBounds)
        
        _imageView.sd_setImageWithPreviousCachedImage(with: url as URL!, placeholderImage: placeholderImage, options: .retryFailed, progress: nil, completed: { [weak self] (image, error, cacheType, imageURL) -> Void in
            if let image = image {
                self?._imageView.frame.size = CGSize(width: UIScreen.mainWidth, height: UIScreen.mainWidth / image.size.width * image.size.height)
                self?.commonInit(fixedImageViewCenter: fixedImageViewCenter, zoomScale: zoomScale, enableSave: enableSave, enableReplace: enableReplace)
            }
        })
    }
    
    convenience init(url: NSURL?,
                     activityIndicatorViewStyle: UIActivityIndicatorViewStyle,
                     fixedImageViewCenter: CGPoint = CGPoint(x: UIScreen.mainWidth / 2.0, y: UIScreen.mainHeight / 2.0),
                     zoomScale: CGFloat = 1.0,
                     enableSave: Bool = true,
                     enableReplace: Bool = true)
    {
        self.init(frame: UIScreen.mainBounds)
        
        _imageView.setShowActivityIndicator(true)
        _imageView.setIndicatorStyle(activityIndicatorViewStyle)
        _imageView.sd_setImageWithPreviousCachedImage(with: url as URL!, placeholderImage: nil, options: .retryFailed, progress: nil, completed: { [weak self] (image, error, cacheType, imageURL) -> Void in
            if let image = image {
                self?._imageView.frame.size = CGSize(width: UIScreen.mainWidth, height: UIScreen.mainWidth / image.size.width * image.size.height)
                self?.commonInit(fixedImageViewCenter: fixedImageViewCenter, zoomScale: zoomScale, enableSave: enableSave, enableReplace: enableReplace)
            }
            })
    }
    
    fileprivate func commonInit(fixedImageViewCenter _center: CGPoint,
                                                 zoomScale: CGFloat,
                                                 enableSave: Bool,
                                                 enableReplace: Bool) {
        _fixedImageViewCenter = _center
        _imageView.center = center
        
        _zoomScale = zoomScale
        if _zoomScale > 1.0 {
            _scrollView.delegate = self
            _scrollView.maximumZoomScale = _zoomScale
            
            let zoomTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(YLLargeImageView.handleZoomTapGesture))
            zoomTapGestureRecognizer.numberOfTapsRequired = 2
            _imageView.addGestureRecognizer(zoomTapGestureRecognizer)
            if let gestureRecognizers = _scrollView.gestureRecognizers {
                for gestureRecognizer in gestureRecognizers {
                    if gestureRecognizer.isKind(of: UITapGestureRecognizer.self) {
                        gestureRecognizer.require(toFail: zoomTapGestureRecognizer)
                    }
                }
            }
        }
        
        _enableSave = enableSave
        _enableReplace = enableReplace
        if _enableSave || _enableReplace {
            let editLongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(YLLargeImageView.handleEditLongPressGesture))
            _imageView.addGestureRecognizer(editLongPressGestureRecognizer)
        }
    }
}

// MARK: Handle Gesture

extension YLLargeImageView {
    
    @objc fileprivate func handleZoomTapGesture(recognizer: UITapGestureRecognizer) {
        let scale: CGFloat = _imageView.frame.width == UIScreen.mainWidth ? _zoomScale : 1.0
        _scrollView.setZoomScale(scale, animated: true)
    }
    
    @objc fileprivate func handleEditLongPressGesture(recognizer: UILongPressGestureRecognizer) {
        guard recognizer.state == .began else { return }
        showEditActionSheet(enableSave: _enableSave, enableReplace: _enableReplace)
    }
    
    @objc fileprivate func handleDismissTapGesture(recognizer: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.alpha = 0.0
        }) { [weak self] (finished) in
            self?.removeFromSuperview()
        }
    }
}

// MARK: Public Property

extension YLLargeImageView {
    var didReplaceImage: ((_ image: UIImage) -> Void)? {
        set { _didReplace = newValue }
        get { return _didReplace }
    }
}

// MARK: Show & Dismiss

extension YLLargeImageView {
    
    func show(startRect _rect: CGRect = CGRect.zero) {
        guard let rootViewController = UIApplication.shared.delegate?.window??.rootViewController else { return }
        rootViewController.view.addSubview(self)
        
        if _rect != CGRect.zero {
            let width = _rect.width
            let height = _rect.height
            let scale = CGAffineTransform(scaleX: width / UIScreen.mainWidth, y: height / UIScreen.mainHeight)
            let translation = CGAffineTransform(translationX: _rect.minX - (UIScreen.mainWidth - width) / 2.0, y: _rect.minY - (UIScreen.mainHeight - height) / 2.0)
            transform = scale.concatenating(translation)
        }
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            let scale = CGAffineTransform(scaleX: 1.0, y: 1.0)
            let translation = CGAffineTransform(translationX: 0.0, y: 0.0)
            self?.transform = scale.concatenating(translation)
            self?.alpha = 1.0
        }) { [weak self] (finished) in
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(YLLargeImageView.handleDismissTapGesture))
            self?._scrollView.addGestureRecognizer(tapGestureRecognizer)
            if let gestureRecognizers = self?._imageView.gestureRecognizers {
                for gestureRecognizer in gestureRecognizers {
                    if gestureRecognizer.isKind(of: UITapGestureRecognizer.self) {
                        tapGestureRecognizer.require(toFail: gestureRecognizer)
                    }
                }
            }
        }
    }
}

// MARK: Zoom & UIScrollViewDelegate
extension YLLargeImageView {
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return _imageView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        let contentWidth = scrollView.contentSize.width
        let contentHeight = scrollView.contentSize.height
        let offsetX = max((scrollView.bounds.width - contentWidth) / 2.0, 0.0) + _fixedImageViewCenter.x - UIScreen.mainWidth / 2.0
        let offsetY = max((scrollView.bounds.height - contentHeight) / 2.0, 0.0) + _fixedImageViewCenter.y - UIScreen.mainHeight / 2.0
        _imageView.center = CGPoint(x: contentWidth / 2.0 + offsetX, y: contentHeight / 2.0 + offsetY)
    }
}


// MARK: Edit & UIImagePickerControllerDelegate

extension YLLargeImageView {
    
    func showEditActionSheet(enableSave _enableSave: Bool, enableReplace _enableReplace: Bool) {
        guard _enableSave || _enableReplace else { return }
        
        var titles: [String] = []
        var actions: [Selector] = []
        if _enableSave {
            titles += ["保存图片"]
            actions += [#selector(YLLargeImageView.save)]
        }
        if _enableReplace {
            titles += ["从手机相册选择", "拍照"]
            actions += [#selector(YLLargeImageView.replaceBySelectFromLibrary), #selector(YLLargeImageView.replaceByTakePhoto)]
        }
        
        let actionSheet = YLCustomActionSheet(otherButtonTitles: titles)
        actionSheet.didClickButtonAtIndex = { [weak self] (index) -> Void in
            let actionIndex = index - 1
            guard actionIndex >= 0 && actionIndex < actions.count else { return }
            _ = self?.perform(actions[actionIndex])
        }
        actionSheet.show()
    }
    
    @objc fileprivate func save() {
        guard let image = _imageView.image, let data = UIImagePNGRepresentation(image) else { return }
        ALAssetsLibrary().writeImageData(toSavedPhotosAlbum: data, metadata: nil) { (url, error) -> Void in }
    }

    @objc fileprivate func replaceBySelectFromLibrary() {
        guard let rootViewController = UIApplication.shared.delegate?.window??.rootViewController else { return }
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        guard let mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) else { return }
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = mediaTypes
        rootViewController.present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc fileprivate func replaceByTakePhoto() {
        guard let rootViewController = UIApplication.shared.delegate?.window??.rootViewController else { return }
        guard UIImagePickerController.isCameraDeviceAvailable(.rear) && UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .camera
        rootViewController.present(imagePickerController, animated: true, completion: nil)
    }
    
    fileprivate func replace(image _image: UIImage) {
        if _zoomScale > 1.0 {
            _scrollView.setZoomScale(1.0, animated: false)
            _scrollView.delegate = nil
            _imageView.image = _image
            _imageView.frame.size = CGSize(width: UIScreen.mainWidth, height: UIScreen.mainWidth / _image.size.width * _image.size.height)
            _imageView.center = _fixedImageViewCenter
            _scrollView.delegate = self
        }
        else {
            _imageView.image = _image
            _imageView.frame.size = CGSize(width: UIScreen.mainWidth, height: UIScreen.mainWidth / _image.size.width * _image.size.height)
            _imageView.center = _fixedImageViewCenter
        }
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            if picker.sourceType == .camera {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
            replace(image: image)
            _didReplace?(image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
