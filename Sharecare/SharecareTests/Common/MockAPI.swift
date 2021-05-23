//
//  MockAPI.swift
//  SharecareTests
//
//  Created by Amit Jangirh on 23/05/21.
//

import Foundation
import Events
import XCTest

struct MockData {
    var response: Result<Any, EventsError>?
    var expectation: XCTestExpectation?
}

class MockAPI {
    let mockData: MockData
    init(mockData: MockData) {
        self.mockData = mockData
    }
    
    private func commonHandler<T: Codable>(completion: @escaping (Result<T, EventsError>) -> Void) {
        guard let response = self.mockData.response else {
            return
        }
        switch response {
        case .success(let data):
            completion(.success(data as! T))
        case .failure(let error):
            completion(.failure(error))
        }
        DispatchQueue.main.sync {
            self.mockData.expectation?.fulfill()
        }
    }
}

extension MockAPI: EventsInterface {
    func searchEvents(event: String, completion: @escaping (Result<[Event], EventsError>) -> Void) {
       commonHandler(completion: completion)
    }
    
    func joinEvent(event: Event, completion: @escaping (Result<Bool, EventsError>) -> Void) {
        commonHandler(completion: completion)
    }
    
    func leaveEvent(event: Event, completion: @escaping (Result<Bool, EventsError>) -> Void) {
        commonHandler(completion: completion)
    }
}
