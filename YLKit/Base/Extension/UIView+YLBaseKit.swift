
extension UIView {
    func convertToImage() -> UIImage? {
        let size = CGSize(width: ceil(bounds.size.width), height: ceil(bounds.size.height))
        UIGraphicsBeginImageContextWithOptions(size, isOpaque, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.bounds.size = size
        layer.render(in: context)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}
