//
//  WatchManager.swift
//  CheatSheet
//
//  Created by Timur Shafigullin on 31/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol WatchManager {
    
    // MARK: - Instance Methods

    func sendData(_ dictionary: [String: WatchSupportable])
    func sendDataArray(_ dictionary: [String: [WatchSupportable]])
}
