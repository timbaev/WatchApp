//
//  WatchSupportable.swift
//  CheatSheet
//
//  Created by Timur Shafigullin on 01/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

public protocol WatchSupportable {
    
    // MARK: - Instance Properties
    
    /// Dictionary with only primitive types
    var data: [String: Any] { get }
}
