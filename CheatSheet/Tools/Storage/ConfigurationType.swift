//
//  ConfigurationType.swift
//  CheatSheet
//
//  Created by Timur Shafigullin on 31/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

enum ConfigurationType {
    
    // MARK: - Enumeration Cases
    
    case basic(url: String?)
    case inMemory(identifier: String?)
    
    // MARK: - Instance Properties
    
    var associated: String? {
        get {
            switch self {
            case .basic(let url):
                return url
            
            case .inMemory(let identifier):
                return identifier
            }
        }
    }
}
