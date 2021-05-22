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
    }
    
    // MARK: - UIComponent
    weak var viewController: UIViewController?
    weak var tableView: UITableView? {
        didSet {
            guard let tableView = self.tableView else {
                return
            }
            tableView.allowsMultipleSelection = false
            tableView.estimatedRowHeight = Constant.rowHeight
            tableView.rowHeight = Constant.rowHeight
            EventSearchResultCell.register(for: tableView)
        }
    }
    weak var searchBar: UISearchBar? {
        didSet {
            guard let searchBar = self.searchBar else {
                return
            }
            searchBar.showsCancelButton = true
            let searchTextField = searchBar.searchTextField
            searchTextField.textColor = UIColor.white
            searchTextField.clearButtonMode = .never
            searchTextField.backgroundColor = UIColor.black
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
