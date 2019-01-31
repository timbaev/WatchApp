//
//  CheatSheetDetails.swift
//  CheatSheet
//
//  Created by Timur Shafigullin on 30/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class CheatSheetDetailsViewController: LoggedViewController {
    
    // MARK: - Nested Types
    
    fileprivate enum Segues {
        
        // MARK: - Type Properties
        
        static let finishCheatSheetUpdate = "FinishCheatSheetUpdate"
    }
    
    // MARK: - Instance Properties
    
    @IBOutlet fileprivate weak var scrollView: UIScrollView!
    
    @IBOutlet fileprivate weak var titleTextView: UITextView!
    @IBOutlet fileprivate weak var contentTextView: UITextView!
    
    @IBOutlet fileprivate weak var bottomSpaceViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: -
    
    fileprivate var cheatSheet: CheatSheet?
    
    fileprivate(set) var shouldApplyData = true
    
    // MARK: - Initializers
    
    deinit {
        self.unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: - Instance Methods
    
    @objc fileprivate func onSaveBarButtonItemTouchUpInside(_ sender: UIBarButtonItem) {
        guard let title = self.titleTextView.text, let content = self.contentTextView.text else {
            return
        }
        
        guard let cheatSheet = self.cheatSheet else {
            return
        }
        
        Managers.cheatSheetManager.update { [unowned self] in
            cheatSheet.title = title
            cheatSheet.content = content
            
            self.performSegue(withIdentifier: Segues.finishCheatSheetUpdate, sender: self)
        }
    }
    
    fileprivate func updateSaveBarButtonItemState() {
        if !self.titleTextView.text.isEmpty, !self.contentTextView.text.isEmpty {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    // MARK: -
    
    fileprivate func apply(cheatSheet: CheatSheet) {
        Log.high("apply(cheatSheet: \(cheatSheet.title))", from: self)
        
        self.cheatSheet = cheatSheet
        
        if self.isViewLoaded {
            self.titleTextView.text = cheatSheet.title
            self.contentTextView.text = cheatSheet.content
            
            self.updateSaveBarButtonItemState()
            
            self.shouldApplyData = false
        } else {
            self.shouldApplyData = true
        }
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let saveBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                target: self,
                                                action: #selector(self.onSaveBarButtonItemTouchUpInside(_:)))
        
        saveBarButtonItem.isEnabled = false
        
        self.navigationItem.rightBarButtonItem = saveBarButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.shouldApplyData, let cheatSheet = self.cheatSheet {
            self.apply(cheatSheet: cheatSheet)
        }
        
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.unsubscribeFromKeyboardNotifications()
    }
}

// MARK: - UITextViewDelegate

extension CheatSheetDetailsViewController: UITextViewDelegate {
    
    // MARK: - Instance Methods
    
    func textViewDidChange(_ textView: UITextView) {
        self.updateSaveBarButtonItemState()
    }
}

// MARK: - KeyboardScrollableHandler

extension CheatSheetDetailsViewController: KeyboardScrollableHandler {
    
    // MARK: - Instance Properties
    
    var scrollableView: UIScrollView {
        return self.scrollView
    }
}

// MARK: - Keyboard Handler

extension CheatSheetDetailsViewController: KeyboardHandler {
    
    // MARK: - Instance Methods
    
    func handle(keyboardHeight: CGFloat, view: UIView) {
        self.bottomSpaceViewHeightConstraint.constant = keyboardHeight
        
        UIView.animate(withDuration: 0.25) { [unowned self] in
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - DictionaryReceiver

extension CheatSheetDetailsViewController: DictionaryReceiver {
    
    // MARK: - Instance Methods
    
    func apply(dictionary: [String : Any]) {
        guard let cheatSheet = dictionary["cheatSheet"] as? CheatSheet else {
            return
        }
        
        self.apply(cheatSheet: cheatSheet)
    }
}
