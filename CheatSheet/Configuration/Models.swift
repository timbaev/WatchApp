//
//  Models.swift
//  CheatSheet
//
//  Created by Timur Shafigullin on 31/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

enum Models {
    
    // MARK: - Type Properties
    
    static let storageContext: StorageContext = try! RealmStorageContext()
}
