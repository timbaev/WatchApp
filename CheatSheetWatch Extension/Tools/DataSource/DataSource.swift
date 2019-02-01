//
//  DataSource.swift
//  CheatSheetWatch Extension
//
//  Created by Timur Shafigullin on 01/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

struct DataSource {
    
    // MARK: - Instance Properties
    
    let item: Item
    
    init(data: [String: Any]) {
        if let cheatSheetsData = data["cheatSheets"] as? [[String: Any]] {
            let cheatSheets = cheatSheetsData.compactMap { WatchCheatSheet(dictionary: $0) }
            
            self.item = .cheatSheets(cheatSheets)
        } else {
            self.item = .unknown
        }
    }
}
