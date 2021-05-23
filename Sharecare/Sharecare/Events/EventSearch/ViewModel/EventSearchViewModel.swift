//
//  EventSearchViewModel.swift
//  Sharecare
//
//  Created by Amit Jangirh on 21/05/21.
//

import Foundation
import Events
import UIKit

class EventSearchViewModel {
    // MARK: - UIComponent
    struct Constant {
        static let rowHeight: CGFloat = 20
        static let SearchTitle = "Search Event"
    }
    
    // MARK: - UIComponent
    weak var viewController: UIViewController? {
        didSet {
            guard let viewController = self.viewController else {
                return
            }
            viewController.title = Constant.SearchTitle
            viewController.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Theme.Color.tintColor]
            viewController.navigationController?.navigationBar.barTintColor = Theme.Color.greyColor
        }
    }
    weak var tableView: UITableView? {
        didSet {
            guard let tableView = self.tableView else {
                return
            }
            tableView.allowsMultipleSelection = false
            tableView.estimatedRowHeight = Constant.rowHeight
            tableView.rowHeight = Constant.rowHeight
            tableView.tableFooterView = UIView()
            EventSearchResultCell.register(for: tableView)
        }
    }
    weak var searchBar: UISearchBar? {
        didSet {
            guard let searchBar = self.searchBar else {
                return
            }
            searchBar.barTintColor = Theme.Color.greyColor
            searchBar.tintColor = Theme.Color.tintColor
            let searchTextField = searchBar.searchTextField
            searchTextField.textColor = Theme.Color.greyColor
            searchTextField.tintColor = Theme.Color.greyColor
            searchTextField.clearButtonMode = .always
            searchTextField.backgroundColor = Theme.Color.tintColor
            if let glassIconView = searchTextField.leftView as? UIImageView {
                glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
                glassIconView.tintColor = Theme.Color.greyColor
            }
        }
    }
    // MARK: - Vars
    var eventsAPI: EventsInterface = events
    var searchEvents: [Event] {
        didSet {
            self.tableView?.reloadData()
        }
    }
    var isLoading: Bool = false
    var alertPresenter: AlertPresentable = AlertPresenter()
    
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
    
    func navigateToEvenDetail(with event: Event) {
        guard let navViewControler = self.viewController?.navigationController else {
            return
        }
        let eventDetailVC = EventDetailViewController.getVC()
        eventDetailVC.viewModel.event = event
        navViewControler.show(eventDetailVC, sender: nil)
    }
}

extension EventSearchViewModel {
    // MARK: - API Interaction
    func search(string: String) {
        self.isLoading = true
        DispatchQueue.global(qos: .userInitiated).async {
            self.eventsAPI.searchEvents(event: string) { [weak self] (result: Result<[Event], EventsError>) in
                DispatchQueue.main.async {
                    self?.handleSearchResult(result: result)
                }
            }
        }
    }
    
    private func handleSearchResult(result: Result<[Event], EventsError>) {
        self .isLoading = false
        switch result {
        case .success(let searchEvents):
            self.searchEvents = searchEvents
        case .failure(let eventsError):
            self.showAlert(title: eventsError.title, message: eventsError.message)
        }
    }
    
    private func showAlert(title: String, message: String) {
        guard let viewController = self.viewController else {
            return
        }
        self.alertPresenter.showAlert(alert: Alert(title: title, message: message),
                                      on: viewController)
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
