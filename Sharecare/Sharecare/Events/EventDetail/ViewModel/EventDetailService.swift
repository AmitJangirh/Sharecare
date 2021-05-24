//
//  EventDetailService.swift
//  Sharecare
//
//  Created by Amit Jangirh on 24/05/21.
//

import Foundation
import Events

protocol EventDetailService {
    func hitService(completion: @escaping ((Bool, String, String) -> Void))
}

struct JoinServiceAPI: EventDetailService {
    // MARK: - Constants
    struct Constant {
        static let joinSuccessTitle = "Was able to successfully join event"
        static let unableToJoinTitle = "Was unable to join"
    }
    
    // MARK: - UIComponent
    let eventsAPI: EventsInterface
    let event: Event
    
    func hitService(completion: @escaping ((Bool, String, String) -> Void)) {
        self.eventsAPI.joinEvent(event: self.event) { (result: Result<Bool, EventsError>) in
            self.handleResponse(response: result, completion: completion)
        }
    }
    
    private func handleResponse(response: Result<Bool, EventsError>, completion: @escaping ((Bool, String, String) -> Void)) {
        switch response {
        case .success(let response):
            let title = response ? Constant.joinSuccessTitle : Constant.unableToJoinTitle
            completion(response, title, "")
        case .failure(let eventsError):
            completion(false, eventsError.title, eventsError.message)
        }
    }
}

struct LeaveServiceAPI: EventDetailService {
    // MARK: - Constants
    struct Constant {
        static let leaveSuccessTitle = "Was able to successfully leave event"
        static let unableToLeaveTitle = "Was unable to leave"
    }
    
    // MARK: - UIComponent
    let eventsAPI: EventsInterface
    let event: Event
    var showAlert: ((Bool, String, String) -> Void)?
    
    func hitService(completion: @escaping ((Bool, String, String) -> Void)) {
        self.eventsAPI.leaveEvent(event: self.event) { (result: Result<Bool, EventsError>) in
            self.handleResponse(response: result, completion: completion)
        }
    }
    
    private func handleResponse(response: Result<Bool, EventsError>, completion: @escaping ((Bool, String, String) -> Void)) {
        switch response {
        case .success(let response):
            let title = response ? Constant.leaveSuccessTitle : Constant.unableToLeaveTitle
            self.showAlert?(response, title, "")
        case .failure(let eventsError):
            self.showAlert?(false, eventsError.title, eventsError.message)
        }
    }
}
