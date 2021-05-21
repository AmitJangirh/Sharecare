//
//  NetworkRequest.swift
//  NetworkConnection
//
//  Created by Amit Jangirh on 21/05/21.
//

import Foundation

public struct NetworkRequest {
    var urlRequest: URLRequest
    private var jsonEncoder: JSONEncoder = {
        // Do additional stuff if required
        return JSONEncoder()
    }()
    
    public init?(path: NetworkPath) {
        guard let url = path.url else {
            NetworkLogger.log(object: "Invalid Netwrok path")
            return nil
        }
        urlRequest = URLRequest(url: url)
    }
    
    // Set Body
    public mutating func body<T: Codable>(_ value: T) throws {
        do {
            urlRequest.httpBody = try jsonEncoder.encode(value)
        } catch {
            NetworkLogger.log(object: "Json Encoding failed with error: \(error)")
            throw error
        }
    }
    
    // Set Headers
    public mutating func headers(_ headers: NetworkHeaders) {
        if let headers = headers.headers {
            headers.forEach({ (args) in
                let (key, value) = args
                urlRequest.addValue(key, forHTTPHeaderField: value)
            })
        }
    }
}
