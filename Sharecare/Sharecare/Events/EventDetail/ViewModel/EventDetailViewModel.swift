//
//  EventDetailViewModel.swift
//  Sharecare
//
//  Created by Amit Jangirh on 22/05/21.
//

import Foundation
import Events
import UIKit

protocol EventDetailViewModelDelegate: class {
    func showAlert(success: Bool, title: String, message: String)
}

class EventDetailViewModel {
    // MARK: - Vars
    var eventDetailService: EventDetailService?
    var isLoading: Bool = false
    var event: Event!
    var delegate: EventDetailViewModelDelegate?
    
    // MARK: - Init
    init() { } // Do nothing
    
    // MARK: - Table getters
    func sections() -> Int {
        return 1
    }
    
    func rows(at section: Int) -> Int {
        return 4
    }
    
    subscript(indexPath: IndexPath) -> String? {
        switch indexPath.row {
        case 0:
            return event.title
        case 1:
            return String(format: "Created Before %.1f Hr", (event.createdAt?.hours ?? 0))
        case 2:
            return String(format: "Active till %.1f Hr", (event.timeToLive?.hours ?? 0))
        case 3:
            return "Number of Participants: \(event.participants ?? 0)"
        default: return nil
        }
    }
}

// MARK: - API Interaction
extension EventDetailViewModel {
    func joinEvent() {
        eventDetailService = JoinServiceAPI(eventsAPI: events, event: self.event)
        hitService()
    }
    
    func leaveEvent() {
        eventDetailService = LeaveServiceAPI(eventsAPI: events, event: self.event)
        hitService()
    }
    
    private func hitService() {
        self.isLoading = true
        DispatchQueue.global(qos: .userInitiated).async {
            self.eventDetailService?.hitService(completion: { [weak self] (success, title, message) in
                self?.isLoading = false
                self?.delegate?.showAlert(success: success, title: title, message: message)
            })
        }
    }
}

extension Int {
    var hours: Float {
        let floatValue: Float = abs(Float(self)) / Float(3600) // converting to Hours
        return floatValue
    }
}
