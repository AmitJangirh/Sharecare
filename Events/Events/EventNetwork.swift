//
//  EventNetwork.swift
//  Events
//
//  Created by Amit Jangirh on 21/05/21.
//

import Foundation
import NetworkConnection

struct EventNetwork {
    static func getAccessToken(completion: @escaping (Result<AccessToken, EventsError>) -> Void) {
        networkAdapter.getAPI(with: .authToken,
                              header: [.authorization: EventsConfiguration.current.basicToken],
                              completion: completion)
    }
    
    static func searchEvents(event: String, token: String, completion: @escaping (Result<[Event], EventsError>) -> Void) {
        networkAdapter.getAPI(with: .eventsSearch,
                              parameter: [.query: event],
                              header: [.authorization: token],
                              completion: completion)
    }
    
    static func joinEvent(eventId: String, token: String, completion: @escaping (Result<Bool, EventsError>) -> Void) {
        networkAdapter.getAPI(with: .join(eventId),
                              header: [.authorization: token],
                              completion: completion)
    }
    
    static func leaveEvent(eventId: String, token: String, completion: @escaping (Result<Bool, EventsError>) -> Void) {
        networkAdapter.getAPI(with: .leave(eventId),
                              header: [.authorization: token],
                              completion: completion)
    }
}
