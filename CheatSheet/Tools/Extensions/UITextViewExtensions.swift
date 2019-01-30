//
//  UITextViewExtensions.swift
//  CheatSheet
//
//  Created by Timur Shafigullin on 30/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

extension UITextView {
    
    // MARK: - Instance Properties
    
    open override var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    @IBInspectable public var placeholder: String? {
        get {
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                return placeholderLabel.text
            }
            
            return nil
        }
        
        set {
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else if let newValue = newValue {
                self.addPlaceholder(with: newValue)
            }
        }
    }
    
    // MARK: - Instance Methods
    
    @objc fileprivate func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.count > 0
        }
    }
    
    fileprivate func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    fileprivate func addPlaceholder(with placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = self.text.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.textViewDidChange(_:)), name: UITextView.textDidChangeNotification, object: nil)
    }
}
