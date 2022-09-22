//
//  ComposeParticipantsTableView.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/17.
//

import UIKit
import RxSwift

final class ComposeParticipantsTableView: UITableView {
    
    // MARK: Properties
    var items: [ComposeParticipantsCellReactor] = []
    
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
        self.rowHeight = 60
        self.register(ComposeParticipantsCell.self)
    }
}

// MARK: - UITableViewDataSource
extension ComposeParticipantsTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeReusableCell(ComposeParticipantsCell.self, for: indexPath)
        cell.reactor = items[indexPath.row]
        return cell
    }
}

// MARK: Binder
extension Reactive where Base: ComposeParticipantsTableView {
    var items: Binder<[ComposeParticipantsCellReactor]> {
        return Binder(base) { base, element in
            base.items = element
            base.reloadData()
        }
    }
}
