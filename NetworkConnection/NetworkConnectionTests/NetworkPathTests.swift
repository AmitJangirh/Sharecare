//
//  NetworkPathTests.swift
//  NetworkConnectionTests
//
//  Created by Amit Jangirh on 21/05/21.
//

import Foundation
@testable import NetworkConnection
import XCTest

class NetworkPathTests: XCTestCase {
    let domain = "http://networkPathTest.com"
    let service = "service/submethod"
    let parameters: [String: String] = ["id": "1", "name": "testName"]

    func test_networkPath_creation_with_emptyDomain() throws {
        let path = NetworkPath(domain: "")
        XCTAssertNil(path.url?.absoluteString)
    }
    
    func test_networkPath_creation_with_domain() throws {
        let path = NetworkPath(domain: domain)
        XCTAssertEqual(path.url?.absoluteString, "http://networkPathTest.com")
    }
    
    func test_networkPath_creation_with_domain_service() throws {
        let path = NetworkPath(domain: domain, service: service)
        XCTAssertEqual(path.url?.absoluteString, "http://networkPathTest.com/service/submethod")
    }
    
    func test_networkPath_creation_with_domain_service_queries() throws {
        let path = NetworkPath(domain: domain, service: service, paramters: parameters)
        XCTAssertEqual(path.url?.absoluteString, "http://networkPathTest.com/service/submethod?id=1&name=testName")
    }
}
