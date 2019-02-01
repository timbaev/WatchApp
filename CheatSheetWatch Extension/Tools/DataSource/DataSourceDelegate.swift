//
//  DataSourceDelegate.swift
//  CheatSheetWatch Extension
//
//  Created by Timur Shafigullin on 01/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol DataSourceDelegate: AnyObject {
    
    // MARK: - Instance Methods
    
    func dataSourceDidUpdated(_ datasource: DataSource)
}
