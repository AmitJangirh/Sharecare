//
//  EventService.swift
//  Events
//
//  Created by Amit Jangirh on 21/05/21.
//

import Foundation

enum EventService {
    case authToken
    case eventsSearch
    case join(String)
    case leave(String)
    
    var string: String {
        switch self {
        case .authToken:
            return "auth/token"
        case .eventsSearch:
            return "events/search"
        case .join(let eventId):
            return "events/\(eventId)/join"
        case .leave(let eventId):
            return "events/\(eventId)/leave"
        }
    }
}

enum HeaderKey: String {
    case authorization = "Authorization"
}

enum ParameterKey: String {
    case query = "q"
}
