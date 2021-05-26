//
//  EventDetailViewController.swift
//  Sharecare
//
//  Created by Amit Jangirh on 22/05/21.
//

import Foundation
import UIKit

class EventDetailViewController: UIViewController, StoryboardGettable {
    // MARK: - Constants
    struct Constant {
        static let rowHeight: CGFloat = 20
    }
    
    // MARK: - IBOutlets
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var bottomButton: BottomButton!

    // MARK: - Vars
    let viewModel = EventDetailViewModel()
    var alertPresenter: AlertPresentable = AlertPresenter()

    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        viewModel.delegate = self
        setupViewController()
        setupTableView()
        setupBottomButton()
    }
    
    // MARK: - UIComponent
    private func setupViewController() {
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Theme.Color.tintColor]
        self.navigationController?.navigationBar.barTintColor = Theme.Color.greyColor
        self.navigationController?.navigationBar.tintColor = Theme.Color.tintColor
        self.title = viewModel.event.title
    }
    
    private func setupTableView() {
        tableView.allowsMultipleSelection = false
        tableView.estimatedRowHeight = Constant.rowHeight
        tableView.rowHeight = Constant.rowHeight
        tableView.tableFooterView = UIView()
        EventDetailCell.register(for: tableView)
    }
    
    private func setupBottomButton() {
        bottomButton.titleState = viewModel.event.isExpired ? .disable : .join
    }
    
    // MARK: - Actions
    @IBAction func bottomButtonAction(_ sender: BottomButton) {
        switch sender.titleState {
        case .join: viewModel.joinEvent()
        case .leave: viewModel.leaveEvent()
        default: // DO nothing
            print("button action nothing")
        }
    }
}

extension EventDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.sections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.rows(at: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellData = viewModel[indexPath],
              let cell = EventDetailCell.dequeueCell(for: tableView, indexPath: indexPath) else {
            return UITableViewCell()
        }
        cell.configure(with: EventDetail(content: cellData))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension EventDetailViewController: EventDetailViewModelDelegate {
    func showAlert(success: Bool, title: String, message: String) {
        DispatchQueue.main.async {
            if success {
                self.showAlert(title: title, message: "") {
                    self.shouldPop()
                }
            } else {
                self.showAlert(title: title, message: "")
            }
        }
    }
    
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        self.alertPresenter.showAlert(alert: Alert(title: title, message: message),
                                      defaultActionHandler: completion,
                                      on: self)
    }
    
    private func shouldPop() {
        self.navigationController?.popViewController(animated: true)
    }
}
