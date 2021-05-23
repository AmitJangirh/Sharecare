//
//  TableCellRegisterable.swift
//  Sharecare
//
//  Created by Amit Jangirh on 22/05/21.
//

import Foundation
import UIKit

protocol TableCellAdaptable where Self: UITableViewCell {
    associatedtype CellData
    static var reusableIdentifier: String { get }
    static func register(for tableView: UITableView)
    static func dequeueCell(for tableView: UITableView, indexPath: IndexPath) -> Self?
    
    func configure(with data: CellData)
}

extension TableCellAdaptable {
    static var reusableIdentifier: String {
        return String(describing: self)
    }

    static func register(for tableView: UITableView) {
        let nib = UINib(nibName: reusableIdentifier, bundle: Bundle(for: Self.self))
        tableView.register(nib, forCellReuseIdentifier: reusableIdentifier)
    }
    
    static func dequeueCell(for tableView: UITableView, indexPath: IndexPath) -> Self? {
        return tableView.dequeueReusableCell(withIdentifier: reusableIdentifier, for: indexPath) as? Self
    }
}
