//
//  EventSearchViewControllerTest.swift
//  SharecareTests
//
//  Created by Amit Jangirh on 23/05/21.
//

import Foundation
import XCTest
@testable import Sharecare
@testable import Events

class EventSearchViewControllerTest: XCTestCase {
    var eventSearchVC: EventSearchViewController!
    var mockNavigationVC: MockNavigationController!
    var tableView: UITableView!
    var searchBar: UISearchBar!

    func test_tableView_itemCount_withNoData_Shouldzero() {
        // Setup
        initialSetup(with: MockData())
        // NO action
        // Tests
        let sections = eventSearchVC.numberOfSections(in: tableView)
        let rows = eventSearchVC.tableView(tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(sections, 1)
        XCTAssertEqual(rows, 0)
    }
    
    func test_tableView_searchingText_lessThanTwo_shouldDoNothing() {
        // Setup
        let expectation = XCTestExpectation(description: "Wait for API Call")
        initialSetup(with: MockData(response: .success([]), expectation: expectation))
        // Action
        eventSearchVC.searchBar(searchBar, textDidChange: "q")
        // Test
        let sections = eventSearchVC.numberOfSections(in: tableView)
        let rows = eventSearchVC.tableView(tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(sections, 1)
        XCTAssertEqual(rows, 0)
    }
    
    func test_tableView_searchingText_moreThanTwo_shouldShowData() {
        // Setup
        let expectation = self.expectation(description: "Wait for API Call")
        initialSetup(with: MockData(response: .success(Event.events), expectation: expectation))
        // Action
        eventSearchVC.searchBar(searchBar, textDidChange: "Mock")
        waitForExpectations(timeout: 1, handler: nil)
        // Test
        let sections = eventSearchVC.numberOfSections(in: tableView)
        let rows = eventSearchVC.tableView(tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(sections, 1)
        XCTAssertEqual(rows, 2)
    }
    
    func test_tableViewCell_searchingText_moreThanTwo_shouldShowCellData() {
        // Setup
        let expectation = self.expectation(description: "Wait for API Call")
        initialSetup(with: MockData(response: .success(Event.events), expectation: expectation))
        // Action
        eventSearchVC.searchBar(searchBar, textDidChange: "Mock")
        waitForExpectations(timeout: 1, handler: nil)
        // Test
        checkCellWithData(at: IndexPath(row: 0, section: 0), array: Event.events)
        checkCellWithData(at: IndexPath(row: 1, section: 0), array: Event.events)
    }
    
    func test_tableView_didSelect_shouldNavigate() {
        // Setup
        let expectation = self.expectation(description: "Wait for API Call")
        initialSetup(with: MockData(response: .success(Event.events), expectation: expectation))
        // Action
        eventSearchVC.searchBar(searchBar, textDidChange: "Mock")
        waitForExpectations(timeout: 1, handler: nil)
        eventSearchVC.tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        // Test
        XCTAssertNotNil(mockNavigationVC.navigateVC)
    }
}

// MARK: - Utilites
extension EventSearchViewControllerTest {
    private func initialSetup(with testData: MockData) {
        eventSearchVC = EventSearchViewController.getVC()
        mockNavigationVC = MockNavigationController(rootViewController: eventSearchVC)
        eventSearchVC.viewModel.eventsAPI = MockAPI(mockData: testData)
        eventSearchVC.loadViewIfNeeded()
        // mirror
        let mirrorVC = ViewControllerMirror(viewController: eventSearchVC)
        tableView = try! XCTUnwrap(mirrorVC.tableView)
        searchBar = try! XCTUnwrap(mirrorVC.searchBar)
    }
    
    private func createCell(at indexPath: IndexPath) -> TableViewCellMirror {
        let cell = eventSearchVC.tableView(tableView, cellForRowAt: indexPath)
        return TableViewCellMirror(cell: cell)
    }
    
    private func checkCellWithData(at indexPath: IndexPath, array: [Event]) {
        let data = array[indexPath.row]
        let cell = createCell(at: indexPath)
        let nameLabel = try! XCTUnwrap(cell.nameLabel)
        let expiredLabel = try! XCTUnwrap(cell.expiredLabel)
        XCTAssertEqual(nameLabel.text, data.title)
        XCTAssertEqual(expiredLabel.text, "Expired")
    }
}

extension ViewControllerMirror {
    fileprivate var tableView: UITableView? { extract() }
    fileprivate var searchBar: UISearchBar? { extract() }
}

extension TableViewCellMirror {
    var nameLabel: UILabel? { extract() }
    var expiredLabel: UILabel? { extract() }
}
