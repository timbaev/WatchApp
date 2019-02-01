//
//  WeakArray.swift
//  CheatSheetWatch Extension
//
//  Created by Timur Shafigullin on 01/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

struct WeakArray<Element: AnyObject> {
    
    // MARK: - Instance Properties
    
    fileprivate var items: [WeakBox<Element>] = []
    
    // MARK: - Initializers
    
    init(_ elements: [Element]) {
        self.items = elements.map { WeakBox($0) }
    }
}

// MARK: - Collection

extension WeakArray: Collection {
    
    // MARK: - Instance Properties
    
    var startIndex: Int {
        return self.items.startIndex
    }
    
    var endIndex: Int {
        return self.items.endIndex
    }
    
    // MARK: - Subscript
    
    subscript(_ index: Int) -> Element? {
        return self.items[index].unbox
    }
    
    // MARK: - Instance Methods
    
    func index(after i: Int) -> Int {
        return self.items.index(after: i)
    }
}
