//
//  EventsInterface.swift
//  Events
//
//  Created by Amit Jangirh on 21/05/21.
//

import Foundation

/// Events is a simple Api that lets you search for events, join them or leave them.
public protocol EventsInterface {
    /// Search for any event name, will provide array for Events Objects
    /// - Parameters:
    ///   - event: Event name to be search for
    ///   - completion: API Reponse with result
    func searchEvents(event: String, completion: @escaping (Result<[Event], EventsError>) -> Void)
    
    /// Joint an event
    /// - Parameters:
    ///   - event: Event Object
    ///   - completion: API Reponse with result
    func joinEvent(event: Event, completion: @escaping (Result<Bool, EventsError>) -> Void)
    
    /// Leave an Event
    /// - Parameters:
    ///   - event: Event Object
    ///   - completion: API Reponse with result
    func leaveEvent(event: Event, completion: @escaping (Result<Bool, EventsError>) -> Void)
}

/// Global Interface events getter to be used to call any available API
public var events: EventsInterface {
    return EventsInteractor()
}
