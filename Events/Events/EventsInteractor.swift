//
//  EventsInteractor.swift
//  Events
//
//  Created by Amit Jangirh on 22/05/21.
//

import Foundation
 
struct EventsInteractor: EventsInterface {
    func searchEvents(event: String, completion: @escaping (Result<[Event], EventsError>) -> Void) {
        TokenRefresher.refreshToken { (result: Result<String, EventsError>) in
            switch result {
            case .success(let accessToken):
                EventNetwork.searchEvents(event: event, token: accessToken, completion: completion)
            case .failure(let eventError):
                completion(.failure(eventError))
            }
        }
    }
    
    func joinEvent(event: Event, completion: @escaping (Result<Bool, EventsError>) -> Void) {
        TokenRefresher.refreshToken { (result: Result<String, EventsError>) in
            switch result {
            case .success(let accessToken):
                EventNetwork.joinEvent(eventId: "\(event.id!)", token: accessToken, completion: completion)
            case .failure(let eventError):
                completion(.failure(eventError))
            }
        }
    }
    
    func leaveEvent(event: Event, completion: @escaping (Result<Bool, EventsError>) -> Void) {
        TokenRefresher.refreshToken { (result: Result<String, EventsError>) in
            switch result {
            case .success(let accessToken):
                EventNetwork.leaveEvent(eventId: "\(event.id!)", token: accessToken, completion: completion)
            case .failure(let eventError):
                completion(.failure(eventError))
            }
        }
    }
}
