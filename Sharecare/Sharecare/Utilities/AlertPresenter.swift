//
//  AlertPresenter.swift
//  Sharecare
//
//  Created by Amit Jangirh on 22/05/21.
//

import Foundation
import UIKit

struct Alert {
    var title: String
    var message: String
}

protocol AlertPresentable {
    func showAlert(alert: Alert, defaultActionHandler: (() -> Void)?, on alertActionHandler: UIViewController)
}

extension AlertPresentable {
    func showAlert(alert: Alert, on alertActionHandler: UIViewController) {
        showAlert(alert: alert, defaultActionHandler: nil, on: alertActionHandler)
    }
}

struct AlertPresenter: AlertPresentable {
    func showAlert(alert: Alert, defaultActionHandler: (() -> Void)? = nil, on alertActionHandler: UIViewController) {
        let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
            defaultActionHandler?()
        }))
        alertActionHandler.present(alertController, animated: true, completion: nil)
    }
}
