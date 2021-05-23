//
//  Utilities.swift
//  EventsTests
//
//  Created by Amit Jangirh on 22/05/21.
//

import Foundation
@testable import Events
import XCTest

extension Event {
    static var events: [Event] {
        return [event1, event2]
    }
    static var event1: Event {
        Event(id: 119281, title: "Movie Night", createdAt: -1451, timeToLive: 7200, participants: 4)
    }
    static var event2: Event {
        Event(id: 2019285, title: "Cocoa Heads Meetup", createdAt: -10, timeToLive: 7200, participants: 67)
    }
}

extension Result {
    var object: Success? {
        return try? self.get()
    }
    var eventError: EventsError? {
        if case let .failure(error) = self, let eventError = error as? EventsError {
            return eventError
        }
        return nil
    }
}

extension EventService {
    func isEqual(to: EventService) -> Bool {
        return self.string == to.string
    }
}
