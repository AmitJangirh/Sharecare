//
//  MockAPI.swift
//  SharecareTests
//
//  Created by Amit Jangirh on 23/05/21.
//

import Foundation
import Events
@testable import Sharecare
import XCTest

struct MockData {
    var response: Result<Any, EventsError>?
    var expectation: XCTestExpectation?
}

struct MockDetailData {
    var expectation: XCTestExpectation
    var response: Bool
    var title: String
    var messgae: String
}

class MockAPI {
    var mockData: MockData? = nil
    var mockDetailData: MockDetailData? = nil
    
    init(mockData: MockData) {
        self.mockData = mockData
    }
    
    init(mockDetailData: MockDetailData) {
        self.mockDetailData = mockDetailData
    }
    
    init() {}
    
    private func commonHandler<T: Codable>(completion: @escaping (Result<T, EventsError>) -> Void) {
        guard let response = self.mockData?.response else {
            return
        }
        switch response {
        case .success(let data):
            completion(.success(data as! T))
        case .failure(let error):
            completion(.failure(error))
        }
        DispatchQueue.main.sync {
            self.mockData?.expectation?.fulfill()
        }
    }
    
    private func commonHandler(completion: @escaping (Bool, String, String) -> Void) {
        guard let mockData = mockDetailData else {
            return
        }
        completion(mockData.response, mockData.title, mockData.messgae)
        DispatchQueue.main.async {
            mockData.expectation.fulfill()
        }
    }
}

extension MockAPI: EventsInterface {
    func searchEvents(event: String, completion: @escaping (Result<[Event], EventsError>) -> Void) {
       commonHandler(completion: completion)
    }
    
    func joinEvent(event: Event, completion: @escaping (Result<Bool, EventsError>) -> Void) {
    }
    
    func leaveEvent(event: Event, completion: @escaping (Result<Bool, EventsError>) -> Void) {
    }
}

extension MockAPI: EventDetailService {
    func hitService(completion: @escaping ((Bool, String, String) -> Void)) {
        commonHandler(completion: completion)
    }
}
