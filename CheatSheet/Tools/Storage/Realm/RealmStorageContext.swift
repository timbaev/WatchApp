//
//  RealmStorageContext.swift
//  CheatSheet
//
//  Created by Timur Shafigullin on 31/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
import RealmSwift

class RealmStorageContext: StorageContext {
    
    // MARK: - Instance Properties
    
    fileprivate var realm: Realm
    fileprivate var observers: [StorageContextObserver] = []
    fileprivate var tokens: [NotificationToken] = []
    
    // MARK: - Initializers
    
    required init(configuration: ConfigurationType = .basic(url: nil)) throws {
        var realmConfig: Realm.Configuration
        
        switch configuration {
        case .basic(let url):
            realmConfig = Realm.Configuration.defaultConfiguration
            
            if let url = url {
                realmConfig.fileURL = URL(string: url)
            }
            
        case .inMemory(let identifier):
            realmConfig = Realm.Configuration()
            
            if let identifier = identifier {
                realmConfig.inMemoryIdentifier = identifier
            } else {
                throw NSError()
            }
        }
        
        try self.realm = Realm(configuration: realmConfig)
    }
    
    // MARK: - Instance Methods
    
    fileprivate func safeWrite(_ block: () throws -> ()) throws {
        if self.realm.isInWriteTransaction {
            try block()
        } else {
            try realm.write(block)
        }
    }
    
    // MARK: - StorageContext
    
    func create<T>(_ model: T.Type, completion: @escaping (T) -> ()) throws where T : Storable {
        try self.safeWrite { [unowned self] in
            let newObject = self.realm.create(model as! Object.Type) as! T
            
            completion(newObject)
        }
    }
    
    func save(object: Storable) throws {
        try self.safeWrite { [unowned self] in
            self.realm.add(object as! Object)
        }
    }
    
    func update(block: @escaping () -> ()) throws {
        try self.safeWrite {
            block()
        }
    }
    
    func delete(object: Storable) throws {
        try self.safeWrite { [unowned self] in
            self.realm.delete(object as! Object)
        }
    }
    
    func deleteAll<T>(_ model: T.Type) throws where T : Storable {
        try self.safeWrite { [unowned self] in
            let objects = self.realm.objects(model as! Object.Type)
            
            objects.forEach { self.realm.delete($0) }
        }
    }
    
    func reset() throws {
        try self.safeWrite { [unowned self] in
            self.realm.deleteAll()
        }
    }
    
    func fetch<T>(_ model: T.Type, predication: NSPredicate?, sorted: Sorted?, completion: ([T]) -> ()) where T : Storable {
        var objects = self.realm.objects(model as! Object.Type)
        
        if let predication = predication {
            objects = objects.filter(predication)
        }
        
        if let sorted = sorted {
            objects = objects.sorted(byKeyPath: sorted.key, ascending: sorted.ascending)
        }
        
        let accumulate: [T] = objects.map { $0 as! T }
        
        completion(accumulate)
    }
    
    // MARK: -
    
    func addObserver<T>(_ observer: StorageContextObserver, to model: T.Type) where T : Storable {
        guard self.observers.index(where: { $0 === observer }) == nil else {
            return
        }
        
        let token = self.realm.objects(model as! Object.Type).observe { changes in
            switch changes {
            case .update(let results, let deletions, let insertions, let modifications):
                let accumulate: [T] = results.map { $0 as! T }
                
                if !deletions.isEmpty {
                    observer.storageContext(self, didRemoveObjectsAtIndices: deletions)
                }
                
                if !insertions.isEmpty {
                    let insertedObjects = insertions.map { accumulate[$0] }
                    
                    observer.storageContext(self, didAppendObjects: insertedObjects)
                }
                
                if !modifications.isEmpty {
                    let updatedObjects = modifications.map { accumulate[$0] }
                    
                    observer.storageContext(self, didUpdateObjects: updatedObjects)
                }
                
                observer.storageContext(self, didChangeObjects: accumulate)
                
            default:
                break
            }
        }
        
        self.observers.append(observer)
        self.tokens.append(token)
    }
    
    func removeObserver(_ observer: StorageContextObserver) {
        if let observerIndex = self.observers.index(where: { $0 === observer }) {
            let token = self.tokens[observerIndex]
            
            token.invalidate()
            
            self.tokens.remove(at: observerIndex)
            self.observers.remove(at: observerIndex)
        }
    }
}
