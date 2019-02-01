//
//  Invocable.swift
//  ITISService
//
//  Created by Timur Shafigullin on 18/12/2018.
//  Copyright © 2018 Timur Shafigullin. All rights reserved.
//

import Foundation

public protocol Invocable: class {
    
    // MARK: - Instance Methods
    
    func invoke(data: Any)
    
}
