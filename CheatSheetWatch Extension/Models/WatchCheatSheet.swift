//
//  CheatSheet.swift
//  CheatSheet
//
//  Created by Timur Shafigullin on 01/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

class WatchCheatSheet: CheatSheet {
    
    var id: String
    var title: String
    var content: String
    var createdAt: Date
    
    var data: [String : Any] {
        return [
            "id": self.id,
            "title": self.title,
            "content": self.content,
            "createdAt": self.createdAt
        ]
    }
    
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String else {
            return nil
        }
        
        guard let title = dictionary["title"] as? String else {
            return nil
        }
        
        guard let content = dictionary["content"] as? String else {
            return nil
        }
        
        guard let createdAt = dictionary["createdAt"] as? Date else {
            return nil
        }
        
        self.id = id
        self.title = title
        self.content = content
        self.createdAt = createdAt
    }
}
