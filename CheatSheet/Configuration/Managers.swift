//
//  Managers.swift
//  CheatSheet
//
//  Created by Timur Shafigullin on 31/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

enum Managers {
    
    // MARK: - Type Properties
    
    static let cheatSheetManager: CheatSheetsManager = DefaultCheatSheetsManager<DefaultCheatSheet>(storageContext: Models.storageContext)
}
