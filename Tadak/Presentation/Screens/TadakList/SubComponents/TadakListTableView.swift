//
//  TadakListTableView.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/13.
//

import UIKit
import RxSwift

final class TadakListTableView: UITableView {
    
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
        self.register(TadakListCell.self)
    }
}

// MARK: - UITableViewDataSource
extension TadakListTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeReusableCell(TadakListCell.self, for: indexPath)
        cell.bind(with: items[indexPath.row])
        return cell
    }
}

// MARK: Binder
extension Reactive where Base: TadakListTableView {
    var items: Binder<[Composition]> {
        return Binder(base) { base, element in
            base.items = element
            base.reloadData()
        }
    }
}
