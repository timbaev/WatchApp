//
//  CheatSheetRowController.swift
//  CheatSheetWatch Extension
//
//  Created by Timur Shafigullin on 31/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import WatchKit
import Foundation

class CheatSheetRowController: NSObject {
    
    // MARK: - Instance Properties
    
    @IBOutlet fileprivate var titleLabel: WKInterfaceLabel!
    
    // MARK: -
    
    var title: String? {
        didSet {
            self.titleLabel.setText(self.title)
        }
    }
}
