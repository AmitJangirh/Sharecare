//
//  EventsError.swift
//  Events
//
//  Created by Amit Jangirh on 21/05/21.
//

import Foundation

/// Events APIs error,
public enum EventsError: Error {
    /// HTTP Status was 200, but response decoded object was nil
    case invalidObject
    
    /// Invalide request created, use which is given in Configuration
    case invalidRequest
    
    /// Network error from Network module
    case networkError(Error)
    
    /// HTTP status code other than valid code ;ie 200
    case invalidStatusCode(Int)
    
    /// Access token got expired or is invalid 
    case invalidAccessToken
}
