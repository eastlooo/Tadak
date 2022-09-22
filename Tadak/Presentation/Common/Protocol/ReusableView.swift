//
//  ReusableView.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/05.
//

import UIKit

protocol ReusableView: AnyObject {
    static var reuseIdentifier: String { get }
}

extension ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableView {}
extension UICollectionReusableView: ReusableView {}

extension UITableView {
    
    func register<T: UITableViewCell>(_ cellClass: T.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    func dequeReusableCell<T>(_ cellClass: T.Type,
                              for indexPath: IndexPath) -> T where T: UITableViewCell {
        
        guard let cell = dequeueReusableCell(
            withIdentifier: cellClass.reuseIdentifier,
            for: indexPath) as? T else { fatalError() }
        
        return cell
    }
}

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_ cellClass: T.Type) {
        register(cellClass, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
        
    }
    
    func register<T: UICollectionReusableView>(_ viewClass: T.Type, kind: SupplementaryViewType) {
        register(viewClass, forSupplementaryViewOfKind: kind.elementKind, withReuseIdentifier: viewClass.reuseIdentifier)
    }
    
    func dequeueReusableCell<T>(_ cellClass: T.Type,
                                for indexPath: IndexPath) -> T where T: UICollectionViewCell {
        guard let cell = dequeueReusableCell(
            withReuseIdentifier: cellClass.reuseIdentifier,
            for: indexPath) as? T else { fatalError() }
        
        return cell
    }
    
    func dequeueReusableSectionHeaderView<T>(_ viewClass: T.Type,
                                             for indexPath: IndexPath) -> T where T: UICollectionReusableView {
        guard let view = dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: viewClass.reuseIdentifier,
            for: indexPath) as? T else { fatalError() }
        
        return view
    }
    
    func dequeueReusableSectionFooterView<T>(_ viewClass: T.Type,
                                             for indexPath: IndexPath) -> T where T: UICollectionReusableView {
        guard let view = dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: viewClass.reuseIdentifier,
            for: indexPath) as? T else { fatalError() }
        
        return view
    }
}

extension UICollectionView {
    
    enum SupplementaryViewType {
        case header, footer
        
        var elementKind: String {
            switch self {
            case .header: return UICollectionView.elementKindSectionHeader
            case .footer: return UICollectionView.elementKindSectionFooter
            }
        }
    }
}
