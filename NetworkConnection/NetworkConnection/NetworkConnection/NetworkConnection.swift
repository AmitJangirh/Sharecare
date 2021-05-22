//
//  NetworkConnection.swift
//  NetworkConnection
//
//  Created by Amit Jangirh on 21/05/21.
//

import Foundation

public class NetworkConnection {
    // MARK: - Constants
    struct Constants {
        static let ConnectionSerialQueue = "NetworkConnection_SerialQueue"
    }
    
    // MARK: - Properties
    private static let sharedInstance = NetworkConnection()
    // No thread safety required as shared is read only and data update is handled at the product side
    //private let connectionSerialQueue = DispatchQueue(label: Constants.ConnectionSerialQueue)
    
    /// Shared Instace to Network Module
    public static var shared: NetworkConnection {
        return sharedInstance
    }
    private let session = NetworkSession()
    private var jsonDecoder: JSONDecoder = {
        // Do additional stuff if required
        return JSONDecoder()
    }()
    
    // MARK: - Sending function
    /// Use it to send API request with given paramaters
    /// - Parameters:
    ///   - path: NetworkPath, to be set the URL to URLRequest
    ///   - method: HTTP method type
    ///   - headers: HTTP headers values to be set to URLRequest
    ///   - completion: Completion response from API, with Response decodable Object Type, and Network Error
    public func sendConnection<T: Codable>(path: NetworkPath,
                                           method: NetworkMethod,
                                           headers: NetworkHeaders,
                                           completion: @escaping (T?, URLResponse?, NetworkError? ) -> Void) {
        sendConnection(path: path, method: method, headers: headers, body: Optional<String>.none, completion: completion)
    }
    
    // MARK: - Sending function
    /// Use it to send API request with given paramaters
    /// - Parameters:
    ///   - path: NetworkPath, to be set the URL to URLRequest
    ///   - method: HTTP method type
    ///   - headers: HTTP headers values to be set to URLRequest
    ///   - body: HTTP Body to be set to URLRequest, it is object which should adapt to Codable. Coding handled by function
    ///   - completion: Completion response from API, with Response decodable Object Type, and Network Error
    public func sendConnection<T: Codable, U: Codable>(path: NetworkPath,
                                                       method: NetworkMethod,
                                                       headers: NetworkHeaders,
                                                       body: U? = nil,
                                                       completion: @escaping (T?, URLResponse?, NetworkError? ) -> Void) {
        guard var urlRequest = NetworkRequest(path: path) else {
            completion(nil, nil, .invalidRequestURL)
            return
        }
        // Set Body
        do {
            if let value = body {
                try urlRequest.setBody(value)
            }
        } catch {
            completion(nil, nil, .failedJsonEncode(error))
            return
        }
        
        // Set Headers
        urlRequest.setHeaders(headers)
        
        // set method
        urlRequest.setHTTPMethod(method: method)
        
        //Send call
        sendConnection(request: urlRequest, completion: completion)
    }
    
    /// Use it to send API request with given paramaters
    /// - Parameters:
    ///   - request: NetworkRequest object, where one can set headers, HTTP values and body
    ///   - completion: Completion response from API, with Response decodable Object Type, and Network Error
    public func sendConnection<T: Codable>(request: NetworkRequest,
                                           completion: @escaping (T?, URLResponse?, NetworkError? ) -> Void) {
        //Send call
        session.resumeDataTask(request: request.urlRequest) { (data, response, error) in
            guard let responseData = data else {
                completion(nil, response, .error(error!))
                return
            }
            do {
                let value = try self.jsonDecoder.decode(T.self, from: responseData)
                completion(value, response, nil)
            } catch {
                let err = NetworkError.failedJsonDecode(error)
                completion(nil, response, err)
            }
        }
    }
}
