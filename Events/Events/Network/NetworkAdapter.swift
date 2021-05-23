//
//  NetworkAdapter.swift
//  Events
//
//  Created by Amit Jangirh on 22/05/21.
//

import Foundation
import NetworkConnection

var networkAdapter: NetworkAdaptable.Type = NetworkAdapter.self

protocol NetworkAdaptable {
    static func getAPI<T: Codable>(with service: EventService,
                                   parameter: [ParameterKey: String]?,
                                   header: [HeaderKey: String],
                                   completion: @escaping (Result<T, EventsError>) -> Void)
    static func getAPI(with service: EventService,
                       parameter: [ParameterKey: String]?,
                       header: [HeaderKey: String],
                       completion: @escaping (Result<Data, EventsError>) -> Void)
}

extension NetworkAdaptable {
    static func getAPI<T: Codable>(with service: EventService,
                                   header: [HeaderKey: String],
                                   completion: @escaping (Result<T, EventsError>) -> Void) {
        getAPI(with: service, parameter: nil, header: header, completion: completion)
    }
}

struct NetworkAdapter: NetworkAdaptable {
    static func getAPI<T: Codable>(with service: EventService,
                                   parameter: [ParameterKey: String]? = nil,
                                   header: [HeaderKey: String],
                                   completion: @escaping (Result<T, EventsError>) -> Void) {
        let path = NetworkPath.path(with: service, paramters: parameter)
        let headers = NetworkHeaders.commonHeaders(header)
        NetworkConnection.shared.sendConnection(path: path,
                                                method: .get,
                                                headers: headers,
                                                body: Optional<String>.none) { (responseObject: T?, urlResponse, networkError) in
            // Handle Network Error and convert it to EventsError
            if let error = networkError {
                let eventError = EventsError.networkError(error)
                completion(.failure(eventError))
                return
            }
            
            // Handle HTTP response for status valid code
            let statusCode = urlResponse?.code ?? 0
            guard statusCode.isValidReponse else {
                completion(.failure(EventsError.invalidStatusCode(statusCode)))
                return
            }
            
            // Handle Data
            if let object = responseObject {
                completion(.success(object))
            } else {
                // Handle nil data from API
                completion(.failure(.invalidObject))
            }
        }
    }
    
    static func getAPI(with service: EventService,
                       parameter: [ParameterKey: String]? = nil,
                       header: [HeaderKey: String],
                       completion: @escaping (Result<Data, EventsError>) -> Void) {
        guard var request = NetworkRequest(path: NetworkPath.path(with: service, paramters: parameter)) else {
            completion(.failure(.invalidRequest))
            return
        }
        request.setHeaders(NetworkHeaders.commonHeaders(header))
        request.setHTTPMethod(method: .get)
        // Hit API
        NetworkConnection.shared.sendConnection(request: request) { (responseData, urlResponse, networkError) in
            // Handle Network Error and convert it to EventsError
            if let error = networkError {
                let eventError = EventsError.networkError(error)
                completion(.failure(eventError))
                return
            }
            
            // Handle HTTP response for status valid code
            let statusCode = urlResponse?.code ?? 0
            guard statusCode.isValidReponse else {
                completion(.failure(EventsError.invalidStatusCode(statusCode)))
                return
            }
            
            // Handle Data
            if let object = responseData {
                completion(.success(object))
            } else {
                // Handle nil data from API, since status code is 200, sending true
                completion(.success(Data()))
            }
        }
    }
}

extension NetworkPath {
    static func path(with service: EventService, paramters: [ParameterKey: String]? = nil) -> NetworkPath {
        var stringParams = [String: String]()
        paramters?.forEach({ (params) in
            let (key, value) = params
            stringParams[key.rawValue] = value
        })
        return NetworkPath(domain: EventsConfiguration.current.baseURL, service: service.string, paramters: stringParams)
    }
}

extension NetworkHeaders {
    static func commonHeaders(_ keyValues: [HeaderKey: String]) -> NetworkHeaders {
        var newHeaders = [String: String]()
        keyValues.forEach { (args) in
            let (key, value) = args
            newHeaders[key.rawValue] = value
        }
        return NetworkHeaders.commonHeaders(with: newHeaders)
    }
}

extension URLResponse {
    fileprivate var code: Int? {
        if let httpResponse = (self as? HTTPURLResponse) {
            return httpResponse.statusCode
        }
        return nil
    }
}

extension Int {
    fileprivate var isValidReponse: Bool {
        if self == 200 { // Put more status code as per requirements
            return true
        }
        return false
    }
}
