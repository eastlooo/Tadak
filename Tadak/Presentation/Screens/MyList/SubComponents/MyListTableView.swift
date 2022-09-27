//
//  MyListTableView.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/17.
//

import UIKit
import RxSwift
import RxCocoa

final class MyListTableView: UITableView {
    
    // MARK: Properties
    var items: [Composition] = []
    
    fileprivate let _delete = PublishRelay<IndexPath>()
    
    // MARK: Lifecycle
    init() {
        super.init(frame: .zero, style: .plain)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        self.dataSource = self
        self.delegate = self
        
        self.backgroundColor = .customNavy
        self.showsVerticalScrollIndicator = false
        self.separatorStyle = .none
        self.rowHeight = 100
        self.register(MyListCell.self)
    }
}

// MARK: - UITableViewDataSource
extension MyListTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeReusableCell(MyListCell.self, for: indexPath)
        cell.bind(with: items[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MyListTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "지우기") { [weak self] action, view, completion in
            self?.items.remove(at: indexPath.row)
            self?._delete.accept(indexPath)
            self?.deleteRows(at: [indexPath], with: .fade)
            
            completion(true)
        }
        
        delete.image = UIImage(named: "trash")
        delete.backgroundColor = .customNavy
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
}

// MARK: Binder
extension Reactive where Base: MyListTableView {
    
    var items: Binder<[Composition]> {
        return Binder(base) { base, items in
            base.items = items
            base.reloadData()
        }
    }
    
    var deleteItem: ControlEvent<IndexPath> {
        return ControlEvent(events: base._delete)
    }
}
