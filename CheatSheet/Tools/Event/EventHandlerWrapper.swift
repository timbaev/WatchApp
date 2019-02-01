//
//  EventHandlerWrapper.swift
//  ITISService
//
//  Created by Timur Shafigullin on 18/12/2018.
//  Copyright © 2018 Timur Shafigullin. All rights reserved.
//

import Foundation

public class EventHandlerWrapper<T: AnyObject, U>: Invocable, Disposable {
    
    public weak var target: T?
    public let event: Event<U>
    
    let handler: Event<U>.EventHandler
    
    init(target: T?, handler: @escaping Event<U>.EventHandler, event: Event<U>) {
        self.target = target
        self.handler = handler
        self.event = event
    }
    
    public func invoke(data: Any) {
        if self.target != nil {
            self.handler(data as! U)
        }
    }
    
    public func dispose() {
        self.event.eventHandlers = self.event.eventHandlers.filter { $0 !== self }
    }
}
