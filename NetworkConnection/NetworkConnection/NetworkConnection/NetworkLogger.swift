//
//  NetworkLogger.swift
//  NetworkConnection
//
//  Created by Amit Jangirh on 21/05/21.
//

import Foundation

struct NetworkLogger {
    static func log(object: Any...) {
        #if DEBUG
        print(object)
        #endif
    }
    
    static func log(request: URLRequest, data: Data?, response: URLResponse?, error: Error?) {
        log(object: "############### REQUEST #################")
        log(object: "URL:")
        log(object: "\(request.url?.absoluteString ?? "NO URL")")
        log(object: "############### RESPONSE #################")
        if let statusCode = (response as? HTTPURLResponse)?.statusCode {
            log(object: "STATUS CODE:")
            log(object: "\(statusCode)")
        }
        if let data = data {
            log(object: "DATA:")
            log(object: data)
        }
        if let error = error {
            log(object: "ERROR:")
            log(object: error)
        }
        log(object: "############### END #################")
    }
}
