//
//  CheatSheetDetailsInterfaceController.swift
//  CheatSheetWatch Extension
//
//  Created by Timur Shafigullin on 11/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import WatchKit
import Foundation

class CheatSheetDetailsInterfaceController: WKInterfaceController {
    
    // MARK: - Instance Properties
    
    @IBOutlet fileprivate weak var titleLabel: WKInterfaceLabel!
    @IBOutlet fileprivate weak var descriptionLabel: WKInterfaceLabel!
    
    // MARK: -
    
    var cheatSheet: CheatSheet?
    
    // MARK: - Instance Methods
    
    fileprivate func apply(cheatSheet: CheatSheet) {
        Log.high("apply(cheatSheet: \(cheatSheet.id))", from: self)
        
        self.cheatSheet = cheatSheet
        
        self.titleLabel.setText(cheatSheet.title)
        self.descriptionLabel.setText(cheatSheet.content)
    }
    
    // MARK: - WKInterfaceController

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if let cheatSheet = context as? CheatSheet {
            self.apply(cheatSheet: cheatSheet)
        }
    }
}
