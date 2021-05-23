//
//  DTOExtensions.swift
//  SharecareTests
//
//  Created by Amit Jangirh on 23/05/21.
//

import Foundation
@testable import Events
import UIKit

extension Event {
    static var events: [Event] {
        return [event1, event2]
    }
    static var event1: Event {
        Event(id: 119281, title: "Movie Night", createdAt: -1451, timeToLive: 7200, participants: 4)
    }
    static var event2: Event {
        Event(id: 2019285, title: "Cocoa Heads Meetup", createdAt: -10, timeToLive: 7200, participants: 67)
    }
}

class MockNavigationController: UINavigationController {
    weak var navigateVC: UIViewController?
    var didPop = false

    override func show(_ vc: UIViewController, sender: Any?) {
        super.show(vc, sender: sender)
        navigateVC = vc
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        self.didPop = true
        return super.popViewController(animated: animated)
    }
}
