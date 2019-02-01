//
//  DefaultWatchManager.swift
//  CheatSheet
//
//  Created by Timur Shafigullin on 31/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
import WatchConnectivity

class DefaultWatchManager: NSObject, WatchManager {
    
    // MARK: - Instance Properties
    
    fileprivate var watchSession: WCSession?
    
    fileprivate var validSession: WCSession? {
        if let session = self.watchSession, session.isPaired, session.isWatchAppInstalled {
            return session
        }
        
        return nil
    }
    
    fileprivate var validReachableSession: WCSession? {
        if let session = self.validSession, session.isReachable {
            return session
        }
        
        return nil
    }
    
    // MARK: - Initializers
    
    override init() {
        super.init()
        
        if WCSession.isSupported() {
            let watchSession = WCSession.default
            
            watchSession.delegate = self
            watchSession.activate()
            
            self.watchSession = watchSession
        }
    }
    
    // MARK: - Instance Methods
    
    func sendData(_ dictionary: [String: WatchSupportable]) {
        if let session = self.validSession {
            do {
                let preparedData = dictionary.mapValues { $0.data }
                
                Log.medium("Send Data with keys \(dictionary.keys)", from: self)
                try session.updateApplicationContext(preparedData)
            } catch {
                Log.high("Error sending data to Apple Watch!", from: self)
            }
        }
    }
    
    func sendDataArray(_ dictionary: [String: [WatchSupportable]]) {
        if let session = self.validSession {
            do {
                let preparedData = dictionary.mapValues { $0.map { $0.data } }
                
                Log.medium("Send Data with keys \(dictionary.keys)", from: self)
                try session.updateApplicationContext(preparedData)
            } catch {
                Log.high("Error sending data to Apple Watch!", from: self)
            }
        }
    }
}

// MARK: - WCSessionDelegate

extension DefaultWatchManager: WCSessionDelegate {
    
    // MARK: - Instance Properties
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        Log.high("activationDidComplete(activationState: \(activationState.description))", from: self)
        
        if let error = error {
            Log.high("activationDidComplete(error: \(error.localizedDescription)", from: self)
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        Log.high("sessionDidBecomeInactive()", from: self)
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        Log.high("sessionDidDeactivate()", from: self)
    }
    
    func sessionWatchStateDidChange(_ session: WCSession) {
        Log.high("sessionWatchStateDidChange(activationState: \(session.activationState.description))", from: self)
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        Log.high("sessionReachabilityDidChange(\(session.isReachable))", from: self)
    }
}
