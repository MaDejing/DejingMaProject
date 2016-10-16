
class YLTextFieldContainerView: UIView, UITextFieldDelegate {

    fileprivate var _maxLength = 0
    fileprivate var _enableWhitespace = true
    fileprivate var _enableNewline = false
    
    fileprivate var _textField: YLTextField!

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
                     textFieldFrame: CGRect = CGRect.zero)
    {
        self.init(frame: frame)
        
        _textField = YLTextField(frame: bounds)
        _textField.delegate = self
        addSubview(_textField)
        NotificationCenter.default.addObserver(self, selector: #selector(YLTextFieldContainerView.receiveTextFieldTextDidChangeNotification), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
        
        _maxLength = maxLength
        _enableWhitespace = enableWhitespace
        _enableNewline = enableNewline
        
        if textFieldFrame != CGRect.zero {
            _textField.frame = textFieldFrame
        }
    }
}

extension YLTextFieldContainerView {
    var textField: YLTextField? { return self.textField }
}

extension YLTextFieldContainerView {
    @objc fileprivate func receiveTextFieldTextDidChangeNotification(notification: NSNotification) {
        guard let textField = notification.object as? YLTextField , textField == _textField else { return }
        
        if textField.markedTextRange == nil {
            if !_enableWhitespace && textField.text?.rangeOfCharacter(from: NSCharacterSet.whitespaces) != nil {
                textField.text = textField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces)
            }
            if !_enableNewline && textField.text?.rangeOfCharacter(from: NSCharacterSet.newlines) != nil {
                textField.text = textField.text?.trimmingCharacters(in: NSCharacterSet.newlines)
            }
        }
        
        if _maxLength > 0 {
            if let markTextRange = textField.markedTextRange {
                if let editedRange = textField.textRange(from: textField.beginningOfDocument, to: markTextRange.start) {
                    if let editedText = textField.text(in: editedRange) , editedText.length > _maxLength {
                        textField.text = editedText.substring(toIndex: _maxLength - 1)
                    }
                }
            }
            else {
                if (textField.text?.length)! > _maxLength {
                    textField.text = textField.text?.substring(toIndex: _maxLength - 1)
                }

            }
        }
    }
}

extension YLTextFieldContainerView {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if !string.isEmpty {
            if !_enableWhitespace && string.rangeOfCharacter(from: NSCharacterSet.whitespaces) != nil {
                return false
            }
            if !_enableNewline && string.rangeOfCharacter(from: NSCharacterSet.newlines) != nil {
                return false
            }
        }
        
        if _maxLength > 0 {
            if let markTextRange = textField.markedTextRange {
                if let editedRange = textField.textRange(from: textField.beginningOfDocument, to: markTextRange.start) {
                    if let editedText = textField.text(in: editedRange) {
                        return editedText.length <= _maxLength
                    }
                }
            }
            return (textField.text?.nsstring.replacingCharacters(in: range, with: string).length)! <= _maxLength
        }
        
        return true
    }
}
