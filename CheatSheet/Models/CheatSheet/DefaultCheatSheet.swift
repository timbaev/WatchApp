//
//  DefaultCheatSheet.swift
//  CheatSheet
//
//  Created by Timur Shafigullin on 31/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
import RealmSwift

class DefaultCheatSheet: Object {
    
    // MARK: - Instance Properties
    
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var title = ""
    @objc dynamic var content = ""
    @objc dynamic var createdAt = Date()
    
    override public static func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - CheatSheet

extension DefaultCheatSheet: CheatSheet { }
