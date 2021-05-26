//
//  EventSearchViewModel.swift
//  Sharecare
//
//  Created by Amit Jangirh on 21/05/21.
//

import Foundation
import Events
import UIKit

protocol EventSearchViewModelDelegate: class {
    func shouldReloadData()
    func showAlert(title: String, message: String)
}

class EventSearchViewModel {
    // MARK: - Constants
    struct Constant {
        static let searchDelay = 250
    }
    
    // MARK: - Vars
    var eventsAPI: EventsInterface = events
    var isLoading: Bool = false
    // We keep track of the pending work item as a property
    private var pendingSearchWorkItem: DispatchWorkItem?
    private var searchEvents: [Event] {
        didSet {
            self.delegate?.shouldReloadData()
        }
    }
    weak var delegate: EventSearchViewModelDelegate?

    // MARK: - Init
    init() {
        self.searchEvents = []
    }
    
    // MARK: - Table getters
    func sections() -> Int {
        return 1
    }
    
    func rows(at section: Int) -> Int {
        return searchEvents.count
    }
    
    subscript(event indexPath: IndexPath) -> Event {
        return searchEvents[indexPath.row]
    }
    
    subscript(result indexPath: IndexPath) -> EventSearchResult {
        return self[event: indexPath].cellData
    }
}

extension EventSearchViewModel {
    // MARK: - API Interaction
    func search(string: String) {
        guard string.count > 2 else {
            self.searchEvents = []
            return
        }
        // Cancel the currently pending item
        if let pendingItem = pendingSearchWorkItem {
            pendingItem.cancel()
            print("***** Previous Searching cancelled \(string)")
        }
        
        // Wrap our API request in a work item
        let requestWorkItem = DispatchWorkItem { [weak self] in
            self?.hitSearchAPI(string: string)
        }
        
        // Save the new work item and execute it after 250 ms
        pendingSearchWorkItem = requestWorkItem
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + .milliseconds(Constant.searchDelay), execute: requestWorkItem)
    }
    
    private func hitSearchAPI(string: String) {
        guard string.count > 2 else {
            return
        }
        print("***** New Search Started \(string)")
        self.isLoading = true
        self.eventsAPI.searchEvents(event: string) { [weak self] (result: Result<[Event], EventsError>) in
            DispatchQueue.main.async {
                self?.handleSearchResult(result: result)
            }
        }
    }
    
    private func handleSearchResult(result: Result<[Event], EventsError>) {
        self .isLoading = false
        switch result {
        case .success(let searchEvents):
            self.searchEvents = searchEvents
        case .failure(let eventsError):
            self.searchEvents = []
            delegate?.showAlert(title: eventsError.title, message: eventsError.message)
        }
    }
}

extension EventsError {
    var title: String {
        return "Error"
    }
    var message: String {
        return "Network Error"
    }
}

extension Event {
    var cellData: EventSearchResult{
        EventSearchResult(eventName: title ?? "", isExpired: isExpired)
    }
    var isExpired: Bool {
        return timeToLive == 0
    }
}
