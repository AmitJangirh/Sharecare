//
//  EventSearchResultCell.swift
//  Sharecare
//
//  Created by Amit Jangirh on 22/05/21.
//

import Foundation
import UIKit

struct EventSearchResult {
    var eventName: String
    var isExpired: Bool
}

class EventSearchResultCell: UITableViewCell, TableCellAdaptable {
    // MARK: - DataType
    typealias CellData = EventSearchResult
    
    struct Constant {
        static let expiredText = "Expired"
    }
    
    // MARK: - IBOutlets
    @IBOutlet private var nameLabel: UILabel! {
        didSet {
            nameLabel.textColor = Theme.Color.greyColor
        }
    }
    @IBOutlet private var expiredLabel: UILabel! {
        didSet {
            expiredLabel.textColor = Theme.Color.redColor
            expiredLabel.text = Constant.expiredText
        }
    }
    
    // MARK: - Configure
    func configure(with data: EventSearchResult) {
        self.nameLabel.text = data.eventName
        self.expiredLabel.isHidden = !data.isExpired
    }
}
