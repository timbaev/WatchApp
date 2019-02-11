//
//  StorageContextObserver.swift
//  CheatSheet
//
//  Created by Timur Shafigullin on 01/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol StorageContextObserver: class {
    
    // MARK: - Instance Methods
    
    func storageContext(_ storageContext: StorageContext, didRemoveObjectsAtIndices indices: [Int])
    func storageContext(_ storageContext: StorageContext, didAppendObjects objects: [Storable])
    func storageContext(_ storageContext: StorageContext, didUpdateObjects objects: [Storable])
    func storageContext(_ storageContext: StorageContext, didChangeObjects objects: [Storable])
}
