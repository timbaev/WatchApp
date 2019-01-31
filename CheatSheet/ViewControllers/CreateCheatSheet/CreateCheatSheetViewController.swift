//
//  CreateCheatSheetViewController.swift
//  CheatSheet
//
//  Created by Timur Shafigullin on 30/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class CreateCheatSheetViewController: LoggedViewController {
    
    // MARK: - Nested Types
    
    fileprivate enum Segues {
        
        // MARK: - Type Properties
        
        static let finishCheatSheetCreation = "FinishCheatSheetCreation"
    }
    
    // MARK: - Instance Properties
    
    @IBOutlet fileprivate weak var scrollView: UIScrollView!
    
    @IBOutlet fileprivate weak var titleTextView: UITextView!
    @IBOutlet fileprivate weak var contentTextView: UITextView!
    
    @IBOutlet fileprivate weak var bottomSpaceViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Initializers
    
    deinit {
        self.unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: - Instance Methods
    
    @objc fileprivate func onDoneBarButtonItemTouchUpInside(_ sender: UIBarButtonItem) {
        guard let title = self.titleTextView.text else {
            return
        }
        
        guard let content = self.contentTextView.text else {
            return
        }
        
        Managers.cheatSheetManager.create { [unowned self] cheatSheet in
            cheatSheet.title = title
            cheatSheet.content = content
            
            self.performSegue(withIdentifier: Segues.finishCheatSheetCreation, sender: self)
        }
    }
    
    @objc fileprivate func onCancelBarButtonItemTouchUpInside(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: Segues.finishCheatSheetCreation, sender: self)
    }
    
    fileprivate func updateDoneBarButtonState() {
        if !self.titleTextView.text.isEmpty, !self.contentTextView.text.isEmpty {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                target: self,
                                                action: #selector(self.onDoneBarButtonItemTouchUpInside(_:)))
        
        doneBarButtonItem.isEnabled = false
        
        let cancenBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                  target: self,
                                                  action: #selector(self.onCancelBarButtonItemTouchUpInside(_:)))
        
        self.navigationItem.rightBarButtonItem = doneBarButtonItem
        self.navigationItem.leftBarButtonItem = cancenBarButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.unsubscribeFromKeyboardNotifications()
    }
}

// MARK: - UITextViewDelegate

extension CreateCheatSheetViewController: UITextViewDelegate {
    
    // MARK: - Instance Methods
    
    func textViewDidChange(_ textView: UITextView) {
        self.updateDoneBarButtonState()
    }
}

// MARK: - KeyboardScrollableHandler

extension CreateCheatSheetViewController: KeyboardScrollableHandler {
    
    // MARK: - Instance Properties
    
    var scrollableView: UIScrollView {
        return self.scrollView
    }
}

// MARK: - Keyboard Handler

extension CreateCheatSheetViewController: KeyboardHandler {
    
    // MARK: - Instance Methods
    
    func handle(keyboardHeight: CGFloat, view: UIView) {
        self.bottomSpaceViewHeightConstraint.constant = keyboardHeight
        
        UIView.animate(withDuration: 0.25) { [unowned self] in
            self.view.layoutIfNeeded()
        }
    }
}
