//
//  EmptyStateView.swift
//  Wager
//
//  Created by Marat Galeev on 07.03.2018.
//  Copyright © 2018 Influx. All rights reserved.
//

import UIKit

struct EmptyStateAction {
    
    // MARK: - Instance Properties
    
    let title: String
    
    let onActionButtonClicked: (() -> Void)
    
    // MARK: - Initializers
    
    init(title: String, onClicked: @escaping (() -> Void)) {
        self.title = title
        
        self.onActionButtonClicked = onClicked
    }
}

@IBDesignable final class EmptyStateView: UIView {
    
    // MARK: - Instance Properties
    
    fileprivate var imageView: UIImageView?
    
    fileprivate let titleLabel = UILabel()
    fileprivate let messageLabel = UILabel()
    
    fileprivate var actionButton: UIButton?
    
    fileprivate var activityIndicatorView: UIActivityIndicatorView?
    
    // MARK: -
    
    @IBInspectable var image: UIImage? {
        didSet {
            self.updateImageView()
        }
    }
    
    @IBInspectable var title: String? {
        get {
            return self.titleLabel.text
        }
        
        set {
            self.titleLabel.text = newValue
        }
    }
    
    @IBInspectable var message: String? {
        get {
            return self.messageLabel.text
        }
        
        set {
            self.messageLabel.text = newValue
        }
    }
    
    @IBInspectable var textColor: UIColor = Colors.blackText {
        didSet {
            self.titleLabel.textColor = self.textColor
            self.messageLabel.textColor = self.textColor
        }
    }
    
    @IBInspectable var activityIndicatorColor: UIColor = Colors.primary {
        didSet {
            self.activityIndicatorView?.color = self.activityIndicatorColor
        }
    }
    
    var action: EmptyStateAction? {
        didSet {
            self.updateActionButton()
        }
    }
    
    var isActivityIndicatorHidden: Bool {
        return self.activityIndicatorView?.isHidden ?? true
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialize()
    }
    
    // MARK: - Instance Methods
    
    @objc fileprivate func onActionButtonTouchUpInside(_ sender: UIButton) {
        self.action?.onActionButtonClicked()
    }
    
    // MARK: -
    
    fileprivate func initialize() {
        self.titleLabel.font = Fonts.medium(ofSize: 22.0)
        self.titleLabel.textColor = self.textColor
        self.titleLabel.numberOfLines = 2
        self.titleLabel.textAlignment = .center
        self.titleLabel.isUserInteractionEnabled = false
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.titleLabel)
        
        self.messageLabel.font = Fonts.regular(ofSize: 17.0)
        self.messageLabel.textColor = self.textColor
        self.messageLabel.numberOfLines = 0
        self.messageLabel.textAlignment = .center
        self.messageLabel.isUserInteractionEnabled = false
        self.messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.messageLabel)
        
        NSLayoutConstraint.activate([self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32.0),
                                     self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32.0)])
        
        NSLayoutConstraint.activate([self.messageLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10.0),
                                     self.messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 18.0),
                                     self.messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -18.0),
                                     self.messageLabel.bottomAnchor.constraint(equalTo: self.centerYAnchor, constant: -8.0)])
    }
    
    fileprivate func updateActionButton() {
        self.actionButton?.removeFromSuperview()
        self.actionButton = nil
        
        if let action = self.action {
            let actionButton = UIButton()

            self.addSubview(actionButton)
            self.actionButton = actionButton
            
            actionButton.setTitle(action.title, for: .normal)
            actionButton.setTitleColor(Colors.primary, for: .normal)
            
            actionButton.addTarget(self,
                                   action: #selector(self.onActionButtonTouchUpInside(_:)),
                                   for: .touchUpInside)
            
            actionButton.translatesAutoresizingMaskIntoConstraints = false

            actionButton.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 48.0, bottom: 0.0, right: 48.0)
            
            NSLayoutConstraint.activate([actionButton.topAnchor.constraint(equalTo: self.messageLabel.bottomAnchor, constant: 28.0),
                                         actionButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                                         actionButton.heightAnchor.constraint(equalToConstant: 44.0)])
            
            if !self.isActivityIndicatorHidden {
                actionButton.isEnabled = true
                actionButton.isHidden = false
            }
        }
    }
    
    fileprivate func updateImageView() {
        if let image = self.image {
            if let imageView = self.imageView {
                imageView.image = image
                imageView.isHidden = false
            } else {
                let imageView = UIImageView()
                
                imageView.image = image
                imageView.contentMode = .scaleAspectFill
                imageView.translatesAutoresizingMaskIntoConstraints = false
                
                self.addSubview(imageView)
                
                self.imageView = imageView
                
                NSLayoutConstraint.activate([imageView.bottomAnchor.constraint(equalTo: self.titleLabel.topAnchor, constant: -24.0),
                                             imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)])
            }
        } else {
            self.imageView?.isHidden = true
        }
    }
    
    // MARK: -
    
    func showActivityIndicator() {
        if self.activityIndicatorView == nil {
            let activityIndicatorView = UIActivityIndicatorView()
            
            activityIndicatorView.color = self.activityIndicatorColor
            activityIndicatorView.hidesWhenStopped = true
            activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
            
            self.addSubview(activityIndicatorView)
            self.activityIndicatorView = activityIndicatorView
            
            NSLayoutConstraint.activate([activityIndicatorView.centerYAnchor.constraint(equalTo: self.messageLabel.bottomAnchor, constant: 50.0),
                                         activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor)])
        }
        
        if let actionButton = self.actionButton {
            actionButton.isEnabled = false
            actionButton.isHidden = true
        }
        
        let activityIndicatorView = self.activityIndicatorView!
        
        if !activityIndicatorView.isAnimating {
            activityIndicatorView.startAnimating()
        }
    }
    
    func hideActivityIndicator() {
        if let actionButton = self.actionButton {
            actionButton.isEnabled = true
            actionButton.isHidden = false
        }
        
        self.activityIndicatorView?.stopAnimating()
    }
}
