import UIKit

extension UIImage {
    
    func changeColor(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context = UIGraphicsGetCurrentContext()
        draw(at: CGPoint.zero, blendMode: .normal, alpha: 1.0)
        context!.setFillColor(color.cgColor)
        context!.setBlendMode(.sourceIn)
        context!.setAlpha(1.0)
        context!.fill(CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    func clipCorner(radius _radius: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        UIBezierPath(roundedRect: rect, cornerRadius: _radius).addClip()
        draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}

extension UIImage {
    
    static func solidColorImage(fillColor _color: UIColor, size: CGSize = CGSize(width: 1.0, height: 1.0)) -> UIImage {
        var s = size
        if s.width != 1.0 { s.width = ceil(s.width) }
        if s.height != 1.0 { s.height = ceil(s.height) }
        UIGraphicsBeginImageContextWithOptions(s, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(_color.cgColor)
        context!.fill(CGRect(x: 0.0, y: 0.0, width: s.width, height: s.height))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    static func imageForKey(key: String) -> UIImage? {
        if key.components(separatedBy: ".").count == 1 && key.components(separatedBy: "@").count == 1 {
            var scale = Int(UIScreen.main.scale)
            while scale > 0 {
                if let image = UIImage.imageForFullname(fullname: scale == 1 ? key+".png" : key+"@\(scale)x.png") {
                    return image
                }
                if let image = UIImage.imageForFullname(fullname: scale == 1 ? key+".PNG" : key+"@\(scale)x.PNG") {
                    return image
                }
                scale -= 1
            }
            if let image = UIImage.imageForFullname(fullname: key+".jpg") {
                return image
            }
            if let image = UIImage.imageForFullname(fullname: key+".JPG") {
                return image
            }
            if let image = UIImage.imageForFullname(fullname: key+".jpeg") {
                return image
            }
            if let image = UIImage.imageForFullname(fullname: key+".JPEG") {
                return image
            }
            return nil
        }
        else {
            return UIImage.imageForFullname(fullname: key)
        }
    }
    
    static func imageForFullname(fullname: String) -> UIImage? {
        let components = fullname.components(separatedBy: ".")
        guard let type = components.last
            , components.count == 2
                && (type == "png" || type == "PNG"
                    || type == "jpg" || type == "JPG"
                    || type == "jpeg" || type == "JPEG")
            else { return nil }
        
        class YLImageCache: SDImageCache {
            static let sharedCache = SDImageCache(namespace: "image.extension.base.ylkit")
        }
        
        if let image = YLImageCache.sharedCache!.imageFromMemoryCache(forKey: fullname) {
            return image
        }
        else {
            if let path = Bundle.main.path(forResource: components.first!, ofType: type) {
                if let image = UIImage(contentsOfFile: path) {
                    YLImageCache.sharedCache!.store(image, forKey: fullname, toDisk: false)
                    return image
                }
            }
        }
        
        return nil
    }
}
