//
//  WatchSessionManager.swift
//  CheatSheetWatch Extension
//
//  Created by Timur Shafigullin on 01/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
import WatchConnectivity
import AurorKit

class WatchSessionManager: NSObject {
    
    // MARK: - Instance Properties
    
    fileprivate let session = WCSession.default
    
    let dataSourceDidChangedEvent = Event<DataSource>()
    
    // MARK: -
    
    static let shared = WatchSessionManager()
    
    // MARK: - Instance Methods
    
    func startSession() {
        self.session.delegate = self
        self.session.activate()
    }
}

// MARK: - WCSessionDelegate

extension WatchSessionManager: WCSessionDelegate {
    
    // MARK: - Instance Methods
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        Log.high("activationDidComplete()", from: self)
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        Log.high("didReceiveApplicationContext()", from: self)
        
        DispatchQueue.main.async { [unowned self] in
            self.dataSourceDidChangedEvent.emit(data: DataSource(data: applicationContext))
        }
    }
}
