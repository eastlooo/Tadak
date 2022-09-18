//
//  MyListTableView.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/17.
//

import UIKit
import RxSwift

final class MyListTableView: UITableView {
    
    // MARK: Properties
    var items: [Composition] = []
    
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
        
        self.backgroundColor = .customNavy
        self.showsVerticalScrollIndicator = false
        self.separatorStyle = .none
        self.rowHeight = 100
        self.register(
            MyListCell.self,
            forCellReuseIdentifier: MyListCell.reuseIdentifier
        )
    }
}

// MARK: - UITableViewDataSource
extension MyListTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: TadakListCell.reuseIdentifier,
            for: indexPath
        ) as! MyListCell
        cell.bind(with: items[indexPath.row])
        return cell
    }
}

// MARK: Binder
extension Reactive where Base: MyListTableView {
    var items: Binder<[Composition]> {
        return Binder(base) { base, element in
            base.items = element
            base.reloadData()
        }
    }
}
