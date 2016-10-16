import UIKit

extension UIColor {
    
    convenience init(RGBHEX: Int, alpha: CGFloat) {
        self.init(red: CGFloat((RGBHEX & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((RGBHEX & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(RGBHEX & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    
    convenience init(ARGBHEX: UInt) {
        self.init(RGBHEX: Int(ARGBHEX & 0x00FFFFFF), alpha: CGFloat((ARGBHEX & 0xFF000000) >> 24) / 255.0)
    }
}

extension UIColor {
    static func color(RGBHEX _hex: Int, alpha: CGFloat) -> UIColor { return UIColor(RGBHEX: _hex, alpha: alpha) }
    static func color(ARGBHEX _hex: UInt) -> UIColor { return UIColor(ARGBHEX: _hex) }
}
