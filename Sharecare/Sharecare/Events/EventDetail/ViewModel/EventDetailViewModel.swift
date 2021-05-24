//
//  EventDetailViewModel.swift
//  Sharecare
//
//  Created by Amit Jangirh on 22/05/21.
//

import Foundation
import Events
import UIKit

class EventDetailViewModel {
    // MARK: - Constants
    struct Constant {
        static let rowHeight: CGFloat = 20
    }
   
    // MARK: - UIComponent
    weak var viewController: UIViewController? {
        didSet {
            guard let viewController = self.viewController else {
                return
            }
            viewController.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Theme.Color.tintColor]
            viewController.navigationController?.navigationBar.barTintColor = Theme.Color.greyColor
            viewController.navigationController?.navigationBar.tintColor = Theme.Color.tintColor
            viewController.title = event.title
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
            EventDetailCell.register(for: tableView)
        }
    }
    weak var bottomButton: BottomButton? {
        didSet {
            guard let bottomButton = self.bottomButton else {
                return
            }
            bottomButton.titleState = event.isExpired ? .disable : .join
        }
    }
    
    // MARK: - Vars
    var eventDetailService: EventDetailService?
    var isLoading: Bool = false
    var alertPresenter: AlertPresentable = AlertPresenter()
    var event: Event! 
    
    // MARK: - Init
    init() { } // Do nothing
    
    private func pop() {
        self.viewController?.navigationController?.popViewController(animated: true)
    }
    
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
    
    func hitService() {
        self.isLoading = true
        DispatchQueue.global(qos: .userInitiated).async {
            self.eventDetailService?.hitService(completion: { [weak self] (success, title, message) in
                self?.showAlert(success: success, title: title, message: message)
            })
        }
    }
    
    private func showAlert(success: Bool, title: String, message: String) {
        DispatchQueue.main.async {
            self.isLoading = false
            if success {
                self.showAlert(title: title, message: "") {
                    self.pop()
                }
            } else {
                self.showAlert(title: title, message: "")
            }
        }
    }
    
    // MARK: - Functions
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        guard let viewController = self.viewController else {
            return
        }
        self.alertPresenter.showAlert(alert: Alert(title: title, message: message),
                                      defaultActionHandler: completion,
                                      on: viewController)
    }
}

extension Int {
    var hours: Float {
        let floatValue: Float = abs(Float(self)) / Float(3600) // converting to Hours
        return floatValue
    }
}
