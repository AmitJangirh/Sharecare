//
//  EventSearchViewController.swift
//  Sharecare
//
//  Created by Amit Jangirh on 21/05/21.
//

import Foundation
import Events
import UIKit

class EventSearchViewController: UIViewController, StoryboardGettable {
    // MARK: - IBOutlets
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var searchBar: UISearchBar!
    
    // MARK: - Constants
    struct Constant {
        static let rowHeight: CGFloat = 20
        static let SearchTitle = "Search Event"
    }
    
    // MARK: - Vars
    let viewModel = EventSearchViewModel()
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
        setupSearchBar()
    }
    
    private func setupViewController() {
        self.title = Constant.SearchTitle
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Theme.Color.tintColor]
        self.navigationController?.navigationBar.barTintColor = Theme.Color.greyColor
    }
    
    private func setupTableView() {
        tableView.allowsMultipleSelection = false
        tableView.estimatedRowHeight = Constant.rowHeight
        tableView.rowHeight = Constant.rowHeight
        tableView.tableFooterView = UIView()
        EventSearchResultCell.register(for: tableView)
    }
    
    private func setupSearchBar() {
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
    
    // MARK: - Searching
    private func search(text: String) {
        self.viewModel.search(string: text)
    }
    
    private func navigateToEvenDetail(with event: Event) {
        guard let navViewControler = self.navigationController else {
            return
        }
        let eventDetailVC = EventDetailViewController.getVC()
        eventDetailVC.viewModel.event = event
        navViewControler.show(eventDetailVC, sender: nil)
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
        let cellData = viewModel[result: indexPath]
        guard let cell = EventSearchResultCell.dequeueCell(for: tableView, indexPath: indexPath) else {
            return UITableViewCell()
        }
        cell.configure(with: cellData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = viewModel[event: indexPath]
        self.navigateToEvenDetail(with: cellData)
    }
}

extension EventSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search(text: searchText)
    }
}

extension EventSearchViewController: EventSearchViewModelDelegate {
    func shouldReloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            self.alertPresenter.showAlert(alert: Alert(title: title, message: message), on: self)
        }
    }
}

