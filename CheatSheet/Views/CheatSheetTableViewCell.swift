//
//  CheatSheetTableViewCell.swift
//  CheatSheet
//
//  Created by Timur Shafigullin on 30/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class CheatSheetTableViewCell: UITableViewCell {
    
    // MARK: - Instance Properties
    
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    
    // MARK: -
    
    var title: String? {
        get {
            return self.titleLabel.text
        }
        
        set {
            self.titleLabel.text = newValue
        }
    }
}
