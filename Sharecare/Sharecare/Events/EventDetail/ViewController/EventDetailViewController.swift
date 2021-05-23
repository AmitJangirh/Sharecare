//
//  EventDetailViewController.swift
//  Sharecare
//
//  Created by Amit Jangirh on 22/05/21.
//

import Foundation
import UIKit

class EventDetailViewController: UIViewController, StoryboardGettable {
    // MARK: - IBOutlets
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var bottomButton: BottomButton!

    // MARK: - Vars
    let viewModel = EventDetailViewModel()

    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        viewModel.viewController = self
        viewModel.tableView = self.tableView
        viewModel.bottomButton = self.bottomButton
    }
    
    // MARK: - Actions
    @IBAction func bottomButtonAction(_ sender: BottomButton) {
        switch sender.titleState {
        case .join: viewModel.joinEvent()
        case .leave: viewModel.leaveEvent()
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
