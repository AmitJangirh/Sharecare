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
    // MARK: - UIComponent
    struct Constant {
        static let joinSuccessTitle = "Was able to successfully join"
        static let unableToJoinTitle = "Was unable to join"
        static let leaveSuccessTitle = "Was able to successfully join"
        static let unableToLeaveTitle = "Was unable to leave"
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
            bottomButton.titleState = .join
        }
    }
    
    // MARK: - Vars
    var eventsAPI: EventsInterface = events
    var isLoading: Bool = false
    var alertPresenter: AlertPresentable = AlertPresenter()
    var event: Event! {
        didSet {
            self.viewController?.title = event.title
        }
    }
    
    // MARK: - Init
    init() { } // Do nothing
    
    // MARK: - Functions
    private func showAlert(title: String, message: String) {
        showAlert(title: title, message: message, completion: nil)
    }
    
    private func showAlert(title: String, message: String, completion: (() -> Void)?) {
        guard let viewController = self.viewController else {
            return
        }
        DispatchQueue.main.async {
            self.alertPresenter.showAlert(alert: Alert(title: title, message: message),
                                          defaultActionHandler: completion,
                                          on: viewController)
        }
    }
    
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

// MARK: - Join API Interaction
extension EventDetailViewModel {
    func joinEvent() {
        self.isLoading = true
        eventsAPI.joinEvent(event: self.event) { [weak self] (result: Result<Bool, EventsError>) in
            guard let weakSelf = self else {
                return
            }
            weakSelf.isLoading = false
            switch result {
            case .success(let response):
                weakSelf.handleJoinResponse(response: response)
            case .failure(let eventsError):
                weakSelf.showAlert(title: eventsError.title, message: eventsError.message)
            }
        }
    }
    
    private func handleJoinResponse(response: Bool) {
        if response {
            self.showAlert(title: Constant.joinSuccessTitle, message: "") {
                self.pop()
            }
        } else {
            self.showAlert(title: Constant.unableToJoinTitle, message: "")
        }
    }
}

// MARK: - Leave API Interaction
extension EventDetailViewModel {
    func leaveEvent() {
        self.isLoading = true
        eventsAPI.leaveEvent(event: self.event) { [weak self] (result: Result<Bool, EventsError>) in
            guard let weakSelf = self else {
                return
            }
            weakSelf.isLoading = false
            switch result {
            case .success(let response):
                weakSelf.handleLeaveResponse(response: response)
            case .failure(let eventsError):
                weakSelf.showAlert(title: eventsError.title, message: eventsError.message)
            }
        }
    }
    
    private func handleLeaveResponse(response: Bool) {
        if response {
            self.showAlert(title: Constant.leaveSuccessTitle, message: "") {
                self.pop()
            }
        } else {
            self.showAlert(title: Constant.unableToLeaveTitle, message: "")
        }
    }
}

extension Int {
    var hours: Float {
        let floatValue: Float = abs(Float(self)) / Float(3600) // converting to Hours
        return floatValue
    }
}
