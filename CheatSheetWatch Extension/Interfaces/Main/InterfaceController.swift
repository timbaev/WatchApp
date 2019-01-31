//
//  InterfaceController.swift
//  CheatSheetWatch Extension
//
//  Created by Timur Shafigullin on 31/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {
    
    // MARK: - Nested Types
    
    fileprivate enum Constants {
        
        // MARK: - Type Properties
        
        static let tableRowType = "CheatSheetRow"
    }
    
    // MARK: - Instance Properties

    @IBOutlet fileprivate weak var table: WKInterfaceTable!
}
