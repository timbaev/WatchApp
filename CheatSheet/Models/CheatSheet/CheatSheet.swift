//
//  CheatSheet.swift
//  CheatSheet
//
//  Created by Timur Shafigullin on 31/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol CheatSheet: AnyObject {
    
    // MARK: - Instance Properties
    
    var id: String { get set }
    
    var title: String { get set }
    var content: String { get set }
}
