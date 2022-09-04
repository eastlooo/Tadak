//
//  ReusableCell.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/05.
//

import UIKit

protocol ReusableCell {
    static var reuseIdentifier: String { get }
}

extension ReusableCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableCell {}
extension UICollectionReusableView: ReusableCell {}
