import UIKit

class YLTextViewContainerView: UIView, UITextViewDelegate {

    fileprivate var _maxLength = 0
    fileprivate var _enableWhitespace = true
    fileprivate var _enableNewline = false
    
    fileprivate var _textView: UITextView!

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect,
                     maxLength: Int,
                     enableWhitespace: Bool = true,
                     enableNewline: Bool = false,
                     textViewFrame: CGRect = CGRect.zero)
    {
        self.init(frame: frame)
        
        _textView = UITextView(frame: bounds)
        _textView.delegate = self
        addSubview(_textView)
        NotificationCenter.default.addObserver(self, selector: #selector(YLTextViewContainerView.receiveTextViewTextDidChangeNotification), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
        
        _maxLength = maxLength
        _enableWhitespace = enableWhitespace
        _enableNewline = enableNewline
        
        if textViewFrame != CGRect.zero {
            _textView.frame = textViewFrame
        }
    }
}

extension YLTextViewContainerView {
    var textView: UITextView? { return _textView }
}

extension YLTextViewContainerView {
    @objc fileprivate func receiveTextViewTextDidChangeNotification(notification: NSNotification) {
        guard let textView = notification.object as? UITextView , textView == _textView else { return }
        
        if textView.markedTextRange == nil {
            if !_enableWhitespace && textView.text.rangeOfCharacter(from: NSCharacterSet.whitespaces) != nil {
                textView.text = textView.text.trimmingCharacters(in: NSCharacterSet.whitespaces)
            }
            if !_enableNewline && textView.text.rangeOfCharacter(from: NSCharacterSet.newlines) != nil {
                textView.text = textView.text.trimmingCharacters(in: NSCharacterSet.newlines)
            }
        }
        
        if _maxLength > 0 {
            if let markTextRange = textView.markedTextRange {
                if let editedRange = textView.textRange(from: textView.beginningOfDocument, to: markTextRange.start) {
                    if let editedText = textView.text(in: editedRange) , editedText.length > _maxLength {
                        textView.text = editedText.substring(toIndex: _maxLength - 1)
                    }
                }
            }
            else {
                if textView.text.length > _maxLength {
                    textView.text = textView.text.substring(toIndex: _maxLength - 1)
                }
            }
        }
    }
}

extension YLTextViewContainerView {
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if !text.isEmpty {
            if !_enableWhitespace && text.rangeOfCharacter(from: NSCharacterSet.whitespaces) != nil {
                return false
            }
            if !_enableNewline && text.rangeOfCharacter(from: NSCharacterSet.newlines) != nil {
                return false
            }
        }
        
        if _maxLength > 0 {
            if let markTextRange = textView.markedTextRange {
                if let editedRange = textView.textRange(from: textView.beginningOfDocument, to: markTextRange.start) {
                    if let editedText = textView.text(in: editedRange) {
                        return editedText.length <= _maxLength
                    }
                }
            }
            return textView.text.nsstring.replacingCharacters(in: range, with: text).length <= _maxLength
        }
        
        return true
    }
}
