//
//  PracticeResultTableView.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/23.
//

import UIKit
import RxSwift

final class PracticeResultTableView: UITableView {
    
    // MARK: Properties
    var items: [TypingText] = []
    
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
        
        self.backgroundColor = .white
        self.separatorStyle = .none
        self.rowHeight = 100
        self.register(PracticeResultCell.self)
        
        self.tableFooterView = UIView()
        self.tableFooterView?.frame.size.height = 50
    }
}

// MARK: - UITableViewDataSource
extension PracticeResultTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeReusableCell(PracticeResultCell.self, for: indexPath)
        cell.bind(with: items[indexPath.row])
        return cell
    }
}

// MARK: Binder
extension Reactive where Base: PracticeResultTableView {
    var items: Binder<[TypingText]> {
        return Binder(base) { base, element in
            base.items = element
            base.reloadData()
        }
    }
}
