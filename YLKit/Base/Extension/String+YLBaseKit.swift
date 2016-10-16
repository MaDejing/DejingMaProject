
extension String {
    
    var nsstring: NSString { return self as NSString }
    
    var length: Int { return unicodeScalars.count }
    
    var composedCharacterSequences: [String] {
        var arr = [String]()
        enumerateSubstrings(in: startIndex..<endIndex, options: .byComposedCharacterSequences) {
            (substring, substringRange, enclosingRange, _) in
            if let str = substring { arr += [str] }
        }
        return arr
    }
}

extension String {
    
    func substring(leftIndex _leftIndex: Int, rightIndex _rightIndex: Int) -> String {
        var l = _leftIndex, r = _rightIndex
        if l < 0 { l = 0 }
        if r >= composedCharacterSequences.count { r = composedCharacterSequences.count - 1 }

        if l < r {
            var str = ""
            for i in l...r { str += composedCharacterSequences[i] }
            return str
        }
        else if l == r {
            return composedCharacterSequences[l]
        }
        else {
            return ""
        }
    }
    
    func substring(toIndex _index: Int) -> String {
        return substring(leftIndex: 0, rightIndex: _index)
    }
    
    func substring(fromIndex _index: Int) -> String {
        return substring(leftIndex: _index, rightIndex: composedCharacterSequences.count - 1)
    }
}

extension String {
    
    func ceilBoundingSize(fromSize _size: CGSize, font: UIFont) -> CGSize {
        return nsstring.ceilBoundingSize(fromSize: _size, font: font)
    }
    
    func ceilBoundingWidth(fromHeight _height: CGFloat, font: UIFont) -> CGFloat {
        return nsstring.ceilBoundingWidth(fromHeight: _height, font: font)
    }
    
    func ceilBoundingHeight(fromWidth _width: CGFloat, font: UIFont) -> CGFloat {
        return nsstring.ceilBoundingHeight(fromWidth: _width, font: font)
    }
}
