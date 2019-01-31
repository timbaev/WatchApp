//
//  DefaultCheatSheetsManager.swift
//  CheatSheet
//
//  Created by Timur Shafigullin on 31/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

class DefaultCheatSheetsManager<Object>: CheatSheetsManager where Object: CheatSheet, Object: Storable {
    
    // MARK: - Instance Properties
    
    fileprivate lazy var sorted = Sorted(key: "createdAt", ascending: false)
    
    // MARK: -
    
    var storageContext: StorageContext
    
    // MARK: - Initializers
    
    init(storageContext: StorageContext) {
        self.storageContext = storageContext
    }
    
    // MARK: - Instance Methods
    
    fileprivate func createPredicate(withID id: String) -> NSPredicate {
        return NSPredicate(format: "id == %@", id)
    }
    
    // MARK: - CheatSheetsManager
    
    func first(withID id: String, completion: @escaping (CheatSheet?) -> ()) {
        self.storageContext.fetch(Object.self, predication: self.createPredicate(withID: id), sorted: sorted) { objects in
            completion(objects.first)
        }
    }
    
    func firstOrNew(withID id: String, completion: @escaping (CheatSheet) -> ()) {
        self.first(withID: id) { [unowned self] persistedCheatSheet in
            if let cheatSheet = persistedCheatSheet {
                completion(cheatSheet)
            } else {
                try? self.storageContext.create(Object.self, completion: completion)
            }
        }
    }
    
    func create(block: @escaping (CheatSheet) -> ()) {
        try? self.storageContext.create(Object.self) { [unowned self] cheatSheet in
            try? self.storageContext.update {
                block(cheatSheet)
            }
        }
    }
    
    func save(cheatSheet: CheatSheet) {
        if let cheatSheet = cheatSheet as? Object {
            try? self.storageContext.save(object: cheatSheet)
        }
    }
    
    func fetch(completion: ([CheatSheet]) -> ()) {
        self.storageContext.fetch(Object.self, predication: nil, sorted: self.sorted, completion: completion)
    }
    
    func update(block: @escaping () -> ()) {
        try? self.storageContext.update(block: block)
    }
}
