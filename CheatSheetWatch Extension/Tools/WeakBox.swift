//
//  WeakBox.swift
//  CheatSheetWatch Extension
//
//  Created by Timur Shafigullin on 01/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

final class WeakBox<A: AnyObject> {
    
    // MARK: - Instance Properties
    
    weak var unbox: A?
    
    // MARK: - Initializers
    
    init(_ value: A) {
        self.unbox = value
    }
}
