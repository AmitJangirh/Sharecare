//
//  EventsError.swift
//  Events
//
//  Created by Amit Jangirh on 21/05/21.
//

import Foundation

/// Events APIs error,
public enum EventsError: Error {
    case networkError(Error)
    case invalidStatusCode(Int)
    case invalidAccessToken
}
