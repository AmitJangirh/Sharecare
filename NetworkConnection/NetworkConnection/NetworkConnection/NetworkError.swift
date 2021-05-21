//
//  NetworkError.swift
//  NetworkConnection
//
//  Created by Amit Jangirh on 21/05/21.
//

import Foundation

/*
 NetworkError - Common error which can be handled at the Network layer
 */
public enum NetworkError {
    case invalidRequestURL
    case failedJsonEncode(Error)
    case failedJsonDecode(Error)
    case networkUnavailable
    case error(Error?)
}
