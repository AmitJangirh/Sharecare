//
//  EventDetailCell.swift
//  Sharecare
//
//  Created by Amit Jangirh on 23/05/21.
//

import Foundation
import UIKit

struct EventDetail {
    var content: String
}

class EventDetailCell: UITableViewCell, TableCellAdaptable {
    // MARK: - DataType
    typealias CellData = EventDetail
    
    // MARK: - IBOutlets
    @IBOutlet private var contentLabel: UILabel! {
        didSet {
            contentLabel.textColor = Theme.Color.greyColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.isUserInteractionEnabled = false
    }
    
    // MARK: - Configure
    func configure(with data: EventDetail) {
        self.contentLabel.text = data.content
    }
}
