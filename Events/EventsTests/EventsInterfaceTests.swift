//
//  EventsInterfaceTests.swift
//  EventsInterfaceTests
//
//  Created by Amit Jangirh on 21/05/21.
//

import XCTest
@testable import Events

class EventsInterfaceTests: XCTestCase {
    
    override func setUpWithError() throws {
        networkAdapter = MockNetworkAdapter.self
    }
    
    override func tearDownWithError() throws {
        MockNetworkAdapter.requests.clear()
    }
    
    func test_events_searchAPI_shouldRespond_success() throws {
        let expectation = XCTestExpectation(description: "Wait for API Call")
        let expectedData = Event.events
        let testCase = TestCase.success(expectedData)
        MockNetworkAdapter.initialise(testCase: testCase, expectation: expectation)
        events.searchEvents(event: "name") { (result: Result<[Event], EventsError>) in
            XCTAssertEqual(expectedData, result.object)
        }
    }
    
    func test_events_searchAPI_shouldRespond_failure() throws {
        let expectation = XCTestExpectation(description: "Wait for API Call")
        let expectedData = EventsError.invalidStatusCode(500)
        let testCase = TestCase.failure(.invalidStatusCode(500))
        MockNetworkAdapter.initialise(testCase: testCase, expectation: expectation)
        events.searchEvents(event: "name") { (result: Result<[Event], EventsError>) in
            XCTAssertEqual(expectedData, result.eventError)
        }
    }
}
