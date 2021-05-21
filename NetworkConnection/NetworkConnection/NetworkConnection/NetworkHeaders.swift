//
//  NetworkHeaders.swift
//  NetworkConnection
//
//  Created by Amit Jangirh on 21/05/21.
//

import Foundation

public struct NetworkHeaders {
    let headers: [String: String]?
    struct Key {
        static let contentType = "Content-Type"
    }
    struct Value {
        static let json = "application/json"
    }
    
    public func appendHeaders(additionalHeaders: [String: String]) -> NetworkHeaders {
        var existing = self.headers ?? [:]
        additionalHeaders.forEach { (args) in
            let (key, value) = args
            existing[key] = value
        }
        return .init(headers: existing)
    }
}

public extension NetworkHeaders {
    /// Static func to append headers to common headers
    /// - Parameter headers: HTTP String headers that needs to be appended to common headers
    /// - Returns: New instance to headers with all the header
    static func commonHeaders(with headers: [String: String]? = nil) -> NetworkHeaders {
        let result = NetworkHeaders(headers: [Key.contentType: Value.json])
        if let availableHeaders = headers {
            return result.appendHeaders(additionalHeaders: availableHeaders)
        }
        return result
    }
}
