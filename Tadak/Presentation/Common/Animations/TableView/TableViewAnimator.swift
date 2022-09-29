//
//  TableViewAnimator.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/30.
//

import UIKit

typealias TableCellAnimation = (UITableView, UITableViewCell, IndexPath) -> Void

final class TableViewAnimator {
    
    private let animation: TableCellAnimation
    
    init(animation: @escaping TableCellAnimation) {
        self.animation = animation
    }
}

extension TableViewAnimator {
    
    func animate(_ tableView: UITableView, cell: UITableViewCell, at indexPath: IndexPath) {
        animation(tableView, cell, indexPath)
    }
}
