//
//  NetworkHeadersTests.swift
//  NetworkConnectionTests
//
//  Created by Amit Jangirh on 21/05/21.
//

import Foundation
@testable import NetworkConnection
import XCTest

class NetworkHeadersTests: XCTestCase {
    let headers = ["key1": "value1", "key2": "value2"]

    func test_networkHeaders_creation_with_no_values() throws {
        let headers = NetworkHeaders(headers: nil)
        XCTAssertEqual(headers.headers?.count, nil)
    }
    
    func test_networkHeaders_creation_with_values() throws {
        let headers = NetworkHeaders(headers: self.headers)
        XCTAssertEqual(headers.headers?.count, 2)
        XCTAssertEqual(headers.headers?["key1"], "value1")
        XCTAssertEqual(headers.headers?["key2"], "value2")
    }
    
    func test_networkHeaders_creation_with_commonValues() throws {
        let headers = NetworkHeaders.commonHeaders()
        XCTAssertEqual(headers.headers?.count, 1)
        XCTAssertEqual(headers.headers?["Content-Type"], "application/json")
    }
    
    func test_networkHeaders_creation_with_commonValuesAppendMoreValue() throws {
        let headers = NetworkHeaders.commonHeaders(with: self.headers)
        XCTAssertEqual(headers.headers?.count, 3)
        XCTAssertEqual(headers.headers?["Content-Type"], "application/json")
        XCTAssertEqual(headers.headers?["key1"], "value1")
        XCTAssertEqual(headers.headers?["key2"], "value2")
    }
}
