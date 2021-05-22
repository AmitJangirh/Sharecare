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
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
    }
    var isLoading: Bool = false
    var alertPresnter: AlertPresentable = AlertPresenter()

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
   
    subscript(indexPath: IndexPath) -> Event {
        return searchEvents[indexPath.row]
    }
}

extension EventSearchViewModel {
    // MARK: - API Interaction
    func search(string: String) {
        self.isLoading = true
        eventsAPI.searchEvents(event: string) { (result: Result<[Event], EventsError>) in
            self.isLoading = false
            switch result {
            case .success(let searchEvents):
                self.searchEvents = searchEvents
            case .failure(let eventsError):
                DispatchQueue.main.async {
                    if let viewCntrlr = self.viewController {
                        self.alertPresnter.showAlert(alert: Alert(title: eventsError.title, message: eventsError.message), on: viewCntrlr)
                    }
                }
            }
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
