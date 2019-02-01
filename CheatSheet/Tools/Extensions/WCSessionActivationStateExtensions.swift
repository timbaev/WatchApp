//
//  WCSessionActivationStateExtensions.swift
//  CheatSheet
//
//  Created by Timur Shafigullin on 01/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
import WatchConnectivity

extension WCSessionActivationState {
    
    // MARK: - Instance Properties
    
    var description: String {
        switch self {
        case .activated:
            return "Activated"
            
        case .inactive:
            return "Inactive"
            
        case .notActivated:
            return "Not Activated"
        }
    }
}
