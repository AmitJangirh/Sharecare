//
//  EventSearchViewController.swift
//  Sharecare
//
//  Created by Amit Jangirh on 21/05/21.
//

import Foundation
import UIKit

class EventSearchViewController: UIViewController, StoryboardGettable {
    // MARK: - IBOutlets
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var searchBar: UISearchBar!
    
    // MARK: - Vars
    let viewModel = EventSearchViewModel()

    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        viewModel.viewController = self
        viewModel.tableView = self.tableView
        viewModel.searchBar = self.searchBar
    }
    
    // MARK: - Searching
    private func search(text: String) {
        self.viewModel.search(string: text)
    }
}

extension EventSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.sections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.rows(at: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = viewModel[indexPath]
        guard let cell = EventSearchResultCell.dequeueCell(for: tableView, indexPath: indexPath) else {
            return UITableViewCell()
        }
        let result = EventSearchResult(eventName: cellData.title ?? "", isExpired: (cellData.timeToLive == 0))
        cell.configure(with: result)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = viewModel[indexPath]
        viewModel.navigateToEvenDetail(with: cellData)
    }
}

extension EventSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText.count > 2 else {
            viewModel.searchEvents = []
            return
        }
        search(text: searchText)
    }
}
