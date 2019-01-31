//
//  CheatSheetManager.swift
//  CheatSheet
//
//  Created by Timur Shafigullin on 31/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol CheatSheetsManager {
    
    // MARK: - Instance Properties
    
    var storageContext: StorageContext { get }
    
    // MARK: - Instance Methods
    
    func create(block: @escaping (CheatSheet) -> ())
    
    func first(withID id: String, completion: @escaping (CheatSheet?) -> ())
    func firstOrNew(withID id: String, completion: @escaping (CheatSheet) -> ())
    
    func save(cheatSheet: CheatSheet)
    func update(block: @escaping () -> ())
    
    func fetch(completion: ([CheatSheet]) -> ())
}
