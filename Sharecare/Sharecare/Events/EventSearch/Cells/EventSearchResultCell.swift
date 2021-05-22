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
}

class EventSearchResultCell: UITableViewCell, TableCellAdaptable {
    // MARK: - IBOutlets
    @IBOutlet private var name: UILabel! {
        didSet {
            name.textColor = Theme.Color.greyColor
        }
    }
    
    // MARK: - DataType
    typealias CellData = EventSearchResult

    // MARK: - Configure
    func configure(with data: EventSearchResult) {
        self.name.text = data.eventName
    }
}
