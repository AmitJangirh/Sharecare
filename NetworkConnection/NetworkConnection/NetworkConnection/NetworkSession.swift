//
//  NetworkSession.swift
//  NetworkConnection
//
//  Created by Amit Jangirh on 21/05/21.
//

import Foundation

class NetworkSession {
    private var session: URLSession = {
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
        return session
    }()
    
    // Append a new task to session and resume the task
    func resumeDataTask(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let task = session.dataTask(with: request) { (data, response, error) in
            NetworkLogger.log(request: request, data: data, response: response, error: error)
            completion(data, response, error)
        }
        task.resume()
    }
}
