//
//  NetworkPath.swift
//  NetworkConnection
//
//  Created by Amit Jangirh on 21/05/21.
//

import Foundation

/// Struct Object as Wrapper for Endpoint URL
public struct NetworkPath {
    let domain: String
    let service: String?
    let paramters: [String: String]?
    
    /// Init the Network path
    /// - Parameters:
    ///   - domain: Base URL eg, https://www.example.com
    ///   - service: The service or method to invoke
    ///   - paramters: Additional paramter, mostly in case of Searching
    public init(domain: String, service: String? = nil, paramters: [String: String]? = nil) {
        self.domain = domain
        self.service = service
        self.paramters = paramters
    }
}

extension NetworkPath {
     var url: URL? {
        var urlPath = self.domain
        guard !urlPath.isEmpty else {
            NetworkLogger.log(object: "Empty Domain")
            return nil
        }
        // Appending service/method name
        if let servicePath = self.service {
            urlPath += "/\(servicePath)"
        }
        // Init URLComponent
        guard var urlComponents = URLComponents(string: urlPath) else {
            NetworkLogger.log(object: "Not able to create URLComponents with given domain")
            return nil
        }
        // Appending Parameters
        if let paramters = self.paramters {
            urlComponents.setQueryItems(with: paramters)
        }
        return urlComponents.url
    }
    var path: String? {
        return url?.absoluteString
   }
}

extension URLComponents {
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key,
                                                        value: $0.value) }
    }
}
