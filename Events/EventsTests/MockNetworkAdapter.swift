//
//  MockNetworkAdapter.swift
//  EventsTests
//
//  Created by Amit Jangirh on 22/05/21.
//

import Foundation
@testable import Events
import XCTest

enum TestCase {
    case success(Any)
    case failure(EventsError)
}

struct Requests {
    var service: EventService?
    var parameter: [ParameterKey : String]?
    var header: [HeaderKey : String]?
    
    mutating func clear() {
        self.service = nil
        self.parameter = nil
        self.header = nil
    }
}

struct MockNetworkAdapter: NetworkAdaptable {
    static var requests = Requests()
    static var testCase: TestCase!
    static var expectation: XCTestExpectation!
    
    static func initialise(testCase: TestCase, expectation: XCTestExpectation) {
        self.testCase = testCase
        self.expectation = expectation
    }
    
    static func deinitialise() {
        self.testCase = nil
        self.expectation = nil
        self.requests.clear()
    }

    static func getAPI<T>(with service: EventService,
                          parameter: [ParameterKey : String]?,
                          header: [HeaderKey : String],
                          completion: @escaping (Result<T, EventsError>) -> Void) where T: Codable {
        self.requests.service = service
        self.requests.parameter = parameter
        self.requests.header = header
        
        expectation.fulfill()
        
        switch self.testCase! {
        case .success(let object):
            completion(.success(object as! T))
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
