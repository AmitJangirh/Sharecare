//
//  NetworkConnectionTests.swift
//  NetworkConnectionTests
//
//  Created by Amit Jangirh on 21/05/21.
//

import XCTest
@testable import NetworkConnection

class NetworkConnectionTests: XCTestCase {
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
    var request: NetworkRequest? {
        var request = NetworkRequest(path: networkPath)
        try? request?.setBody(body)
        request?.setHeaders(headers)
        return request
    }
    
    func test_networkConnection_sendRequest() throws {
        let expectation = XCTestExpectation(description: "Wait for API Call")
        NetworkConnection.shared.sendConnection(request: request!) { (responseObject: MockResponse?, response, error) in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }
}

struct MockResponse: Codable {
    var int: Int = 1
}
