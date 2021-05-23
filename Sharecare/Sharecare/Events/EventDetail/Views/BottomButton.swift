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
        }
    }
    
    private func setup() {
        self.backgroundColor = Theme.Color.greyColor
        self.tintColor = Theme.Color.tintColor
        self.layer.cornerRadius = Constant.cornerRadius
    }
}
