//
//  EventsInterfaceTests.swift
//  EventsInterfaceTests
//
//  Created by Amit Jangirh on 21/05/21.
//

import XCTest
@testable import Events

class EventsInterfaceTests: XCTestCase {
    let accessToken = AccessToken(accessToken: "dsadasdasdqecwefeafa",
                                  expiresIn: 3600,
                                  scope: nil,
                                  tokenType: nil,
                                  storeDate: Date())
    
    override func setUpWithError() throws {
        networkAdapter = MockNetworkAdapter.self
        DataStore.accessToken = accessToken
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
            XCTAssertEqual(MockNetworkAdapter.requests.header, [.authorization : self.accessToken.accessToken!])
            XCTAssertEqual(MockNetworkAdapter.requests.parameter, [.query : "name"])
            XCTAssertTrue(MockNetworkAdapter.requests.service!.isEqual(to: .eventsSearch))
        }
    }
    
    func test_events_searchAPI_shouldRespond_failure() throws {
        let expectation = XCTestExpectation(description: "Wait for API Call")
        let testCase = TestCase.failure(.invalidStatusCode(500))
        MockNetworkAdapter.initialise(testCase: testCase, expectation: expectation)
        events.searchEvents(event: "name") { (result: Result<[Event], EventsError>) in
            XCTAssertNotNil(result.eventError)
            XCTAssertEqual(MockNetworkAdapter.requests.header, [.authorization : self.accessToken.accessToken!])
            XCTAssertEqual(MockNetworkAdapter.requests.parameter, [.query : "name"])
            XCTAssertTrue(MockNetworkAdapter.requests.service!.isEqual(to: .eventsSearch))
        }
    }
    
    func test_events_join_shouldRespond_success() throws {
        let expectation = XCTestExpectation(description: "Wait for API Call")
        let testCase = TestCase.success(true)
        MockNetworkAdapter.initialise(testCase: testCase, expectation: expectation)
        events.joinEvent(event: Event.event1) { (result: Result<Bool, EventsError>) in
            XCTAssertEqual(true, result.object)
            XCTAssertEqual(MockNetworkAdapter.requests.header, [.authorization : self.accessToken.accessToken!])
            XCTAssertEqual(MockNetworkAdapter.requests.parameter, nil)
            XCTAssertTrue(MockNetworkAdapter.requests.service!.isEqual(to: .join("119281")))
        }
    }
    
    func test_events_leave_shouldRespond_success() throws {
        let expectation = XCTestExpectation(description: "Wait for API Call")
        let testCase = TestCase.success(true)
        MockNetworkAdapter.initialise(testCase: testCase, expectation: expectation)
        events.leaveEvent(event: Event.event1) { (result: Result<Bool, EventsError>) in
            XCTAssertEqual(true, result.object)
            XCTAssertEqual(MockNetworkAdapter.requests.header, [.authorization : self.accessToken.accessToken!])
            XCTAssertEqual(MockNetworkAdapter.requests.parameter, nil)
            XCTAssertTrue(MockNetworkAdapter.requests.service!.isEqual(to: .leave("119281")))
        }
    }
}
