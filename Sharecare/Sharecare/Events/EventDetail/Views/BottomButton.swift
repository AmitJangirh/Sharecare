//
//  BottomButton.swift
//  Sharecare
//
//  Created by Amit Jangirh on 23/05/21.
//

import Foundation
import UIKit

class BottomButton: UIButton {
    // MARK: - Constants
    struct Constant {
        static let cornerRadius: CGFloat = 20
    }
    
    enum State: String {
        case join = "Join"
        case leave = "Leave"
        case disable = "Expired"
        
        var backgroundColor: UIColor {
            switch self {
            case .join, .leave: return Theme.Color.greyColor
            case .disable: return Theme.Color.disableGreyColor
            }
        }
        var textColor: UIColor {
            switch self {
            case .join, .leave: return Theme.Color.tintColor
            case .disable: return Theme.Color.disableTintColor
            }
        }
    }
    
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Vars
    var titleState: State = .join {
        didSet {
            self.setTitle(titleState.rawValue, for: .normal)
            self.backgroundColor = titleState.backgroundColor
            self.tintColor = titleState.textColor
            self.isUserInteractionEnabled = titleState == .disable ? false : true
        }
    }
    
    private func setup() {
        self.backgroundColor = Theme.Color.greyColor
        self.tintColor = Theme.Color.tintColor
        self.layer.cornerRadius = Constant.cornerRadius
    }
}
