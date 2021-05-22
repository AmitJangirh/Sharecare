//
//  Event.swift
//  Events
//
//  Created by Amit Jangirh on 21/05/21.
//

import Foundation

/// Event Object
public struct Event: Codable {
    enum CodingKeys: String, CodingKey {
        case id, title,  participants
        case createdAt = "created-at"
        case timeToLive = "ttl"
    }
    
    /// Unique event ID for identification
    public private(set) var id: Int?
    
    /// Event name for which query was made
    public private(set) var title: String?
    
    /// specified in seconds since the search request hits the service
    public private(set) var createdAt: Int?
    
    /// A time to live that indiciates for how long one can still join the event (speficied in seconds from the point in time since the request hits the service)
    public private(set) var timeToLive: Int?
    
    /// Number of participants in the event
    public private(set) var participants: Int?
}

extension Event: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
