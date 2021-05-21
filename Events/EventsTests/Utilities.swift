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
        return [Event(id: 119281, title: "Movie Night", createdAt: -1451, total: 7200, participants: 4),
                Event(id: 2019285, title: "Cocoa Heads Meetup", createdAt: -10, total: 7200, participants: 67)]
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
