//
//  StorageContext.swift
//  CheatSheet
//
//  Created by Timur Shafigullin on 31/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol StorageContext {
    
    // MARK: - Instance Methods
    
    func create<T: Storable>(_ model: T.Type, completion: @escaping (T) -> ()) throws
    func save(object: Storable) throws
    func update(block: @escaping () -> ()) throws
    func delete(object: Storable) throws
    func deleteAll<T: Storable>(_ model: T.Type) throws
    func reset() throws
    func fetch<T: Storable>(_ model: T.Type, predication: NSPredicate?, sorted: Sorted?, completion: ([T]) -> ())
}
