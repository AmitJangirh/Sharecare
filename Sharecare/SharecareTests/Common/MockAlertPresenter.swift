//
//  MockAlertPresenter.swift
//  SharecareTests
//
//  Created by Amit Jangirh on 23/05/21.
//

import Foundation
@testable import Sharecare
import UIKit

class MockAlertPresenter: AlertPresentable {
    var alertData: Alert?
    
    func showAlert(alert: Alert, defaultActionHandler: (() -> Void)?, on alertActionHandler: UIViewController) {
        self.alertData = alert
        defaultActionHandler?()
    }
}
