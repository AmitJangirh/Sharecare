//
//  EventDetailViewControllerTests.swift
//  SharecareTests
//
//  Created by Amit Jangirh on 23/05/21.
//

import Foundation
import XCTest
@testable import Sharecare
@testable import Events


class EventDetailViewControllerTests: XCTestCase {
    var eventDetailVC: EventDetailViewController!
    var mockNavigationVC: MockNavigationController!
    var mockAlertPresenter = MockAlertPresenter()
    var tableView: UITableView!
    var bottomButton: BottomButton!
    
    override func tearDownWithError() throws {
        mockAlertPresenter.alertData = nil
        mockNavigationVC.navigateVC = nil
        mockNavigationVC.didPop = false
    }
    
    func test_tableView_sectionRowsCount_shouldBe1() {
        // Setup
        initialSetup(with: Event.event1, testData: MockData())
        // Test
        let sections = eventDetailVC.numberOfSections(in: tableView)
        let rows = eventDetailVC.tableView(tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(sections, 1)
        XCTAssertEqual(rows, 4)
    }
    
    func test_tableViewCell_cellData_shouldShowValidData() {
        // Setup
        initialSetup(with: Event.event1, testData: MockData())
        // Test first row
        let cell = createCell(at: IndexPath(row: 0, section: 0))
        let contentLabel = try! XCTUnwrap(cell.contentLabel)
        XCTAssertEqual(contentLabel.text, "Movie Night")
        
        // Test 2nd row
        let cell2 = createCell(at: IndexPath(row: 1, section: 0))
        let contentLabel2 = try! XCTUnwrap(cell2.contentLabel)
        XCTAssertEqual(contentLabel2.text, "Created Before 0.4 Hr")
        
        // Test 3rd row
        let cell3 = createCell(at: IndexPath(row: 2, section: 0))
        let contentLabel3 = try! XCTUnwrap(cell3.contentLabel)
        XCTAssertEqual(contentLabel3.text, "Active till 2.0 Hr")
        
        // Test 4th row
        let cell4 = createCell(at: IndexPath(row: 3, section: 0))
        let contentLabel4 = try! XCTUnwrap(cell4.contentLabel)
        XCTAssertEqual(contentLabel4.text, "Number of Participants: 4")
    }
    
    func test_buttonAction_join_success_shouldNavigateBack() {
        // Setup
        let expectation = self.expectation(description: "Wait for API Call")
        initialSetup(with: Event.event1, testData: MockData(response: .success(true), expectation: expectation))
        // Action
        bottomButton.titleState = .join
        eventDetailVC.bottomButtonAction(bottomButton)
        waitForExpectations(timeout: 1, handler: nil)
        // Test
        XCTAssertEqual(mockAlertPresenter.alertData?.title, "Was able to successfully join event")
        XCTAssertEqual(mockNavigationVC.didPop, true)
    }
    
    func test_buttonAction_join_failure_shouldNotNavigateBack() {
        // Setup
        let expectation = self.expectation(description: "Wait for API Call")
        initialSetup(with: Event.event1, testData: MockData(response: .failure(EventsError.invalidAccessToken), expectation: expectation))
        // Action
        bottomButton.titleState = .join
        eventDetailVC.bottomButtonAction(bottomButton)
        waitForExpectations(timeout: 1, handler: nil)
        // Test
        XCTAssertEqual(mockAlertPresenter.alertData?.title, "Error")
        XCTAssertEqual(mockNavigationVC.didPop, false)
    }
    
    func test_buttonAction_leave_success_shouldNavigateBack() {
        // Setup
        let expectation = self.expectation(description: "Wait for API Call")
        initialSetup(with: Event.event1, testData: MockData(response: .success(true), expectation: expectation))
        // Action
        bottomButton.titleState = .leave
        eventDetailVC.bottomButtonAction(bottomButton)
        waitForExpectations(timeout: 1, handler: nil)
        // Test
        XCTAssertEqual(mockAlertPresenter.alertData?.title, "Was able to successfully leave event")
        XCTAssertEqual(mockNavigationVC.didPop, true)
    }
}

// MARK: - Utilites
extension EventDetailViewControllerTests {
    private func initialSetup(with event: Event, testData: MockData) {
        eventDetailVC = EventDetailViewController.getVC()
        mockNavigationVC = MockNavigationController(rootViewController: eventDetailVC)
        eventDetailVC.viewModel.event = event
        eventDetailVC.viewModel.alertPresenter = mockAlertPresenter
        eventDetailVC.viewModel.eventsAPI = MockAPI(mockData: testData)
        eventDetailVC.loadViewIfNeeded()
        // mirror
        let mirrorVC = ViewControllerMirror(viewController: eventDetailVC)
        tableView = try! XCTUnwrap(mirrorVC.tableView)
        bottomButton = try! XCTUnwrap(mirrorVC.bottomButton)
    }
    
    private func createCell(at indexPath: IndexPath) -> TableViewCellMirror {
        let cell = eventDetailVC.tableView(tableView, cellForRowAt: indexPath)
        return TableViewCellMirror(cell: cell)
    }
}

extension ViewControllerMirror {
    fileprivate var tableView: UITableView? { extract() }
    fileprivate var bottomButton: BottomButton? { extract() }
}

extension TableViewCellMirror {
    var contentLabel: UILabel? { extract() }
}
