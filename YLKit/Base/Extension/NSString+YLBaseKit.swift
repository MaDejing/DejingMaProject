import UIKit

extension NSString {
    var swiftString: String { return self as String }
    var swiftLength: Int { return swiftString.length }
    var composedCharacterSequences: [String] { return swiftString.composedCharacterSequences }
}

extension NSString {
    
    func substringBySequence(leftIndex _leftIndex: Int, rightIndex _rightIndex: Int) -> String {
        return swiftString.substring(leftIndex: _leftIndex, rightIndex: _rightIndex)
    }
    
    func substringBySequence(toIndex _index: Int) -> String {
        return swiftString.substring(toIndex: _index)
    }
    
    func substringBySequence(fromIndex _index: Int) -> String {
        return swiftString.substring(fromIndex: _index)
    }
}

extension NSString {
    
    func ceilBoundingSize(fromSize _size: CGSize, font: UIFont) -> CGSize {
        let boundRect = boundingRect(with: _size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return CGSize(width: ceil(boundRect.width), height: ceil(boundRect.height))
    }
    
    func ceilBoundingWidth(fromHeight _height: CGFloat, font: UIFont) -> CGFloat {
        return ceilBoundingSize(fromSize: CGSize(width: 0.0, height: _height), font: font).width
    }
    
    func ceilBoundingHeight(fromWidth _width: CGFloat, font: UIFont) -> CGFloat {
        return ceilBoundingSize(fromSize: CGSize(width: _width, height: 0.0), font: font).height
    }
}
