
extension Array {
    
    mutating func safeInsert(element _element: Element, atIndex _index: Int) {
        guard _index >= 0 && _index <= count else { return }
        insert(_element, at: _index)
    }
    
    mutating func safeRemove(atIndex _index: Int) {
        guard _index >= 0 && _index < count else { return }
        remove(at: _index)
    }
    
    func safeSubarray(leftIndex _leftIndex: Int, rightIndex _rightIndex: Int) -> Array {
        guard _leftIndex >= 0 && _rightIndex < count && _leftIndex <= _rightIndex else { return [] }
        return Array(self[startIndex.advanced(by: _leftIndex)...startIndex.advanced(by: _rightIndex)])
    }
    
    func safeSubarray(toIndex _index: Int) -> Array {
        return safeSubarray(leftIndex: 0, rightIndex: _index)
    }
    
    func safeSubarray(fromIndex _index: Int) -> Array {
        return safeSubarray(leftIndex: _index, rightIndex: count - 1)
    }
    
    func safeElement(atIndex _index: Int) -> Element? {
        guard _index >= 0 && _index < count else { return nil }
        return self[_index]
    }
    
    func splitBy(length _length: Int) -> Array<Array> {
        return stride(from: 0, to: count, by: _length).map { startIndex in
            var endIndex = startIndex.advanced(by: _length)
            if endIndex > count {
                endIndex = count
            }
            return Array(self[startIndex ..< endIndex])
        }
    }
}
