//
//  NetworkRequestTests.swift
//  NetworkConnectionTests
//
//  Created by Amit Jangirh on 21/05/21.
//

import Foundation
@testable import NetworkConnection
import XCTest

class NetworkRequestTests: XCTestCase {
    let domain = "http://networkPathTest.com"
    let service = "service/submethod"
    let parameters: [String: String] = ["id": "1", "name": "testName"]
    let headerValue = ["key1": "value1", "key2": "value2"]

    var networkPath: NetworkPath {
        return NetworkPath(domain: domain, service: service, paramters: parameters)
    }
    var body: MockRequestBody {
        MockRequestBody()
    }
    var headers: NetworkHeaders {
        NetworkHeaders(headers: headerValue)
    }
    
    func test_networkRequest_creation_with_pathBodyHeaders() throws {
        var request = NetworkRequest(path: networkPath)
        try? request?.body(body)
        request?.headers(headers)
        XCTAssertEqual(request?.urlRequest.allHTTPHeaderFields?.count, 2)
        XCTAssertNotNil(request?.urlRequest.httpBody)
        XCTAssertEqual(request?.urlRequest.url?.absoluteString, "http://networkPathTest.com/service/submethod?id=1&name=testName")
    }
}

struct MockRequestBody: Codable {
    var stringValue: String = "Sample"
    var intValue: Int = 22
    var floatValue: Float = 22.3
}
 
