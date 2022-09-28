//
//  BettingResultTableView.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/23.
//

import UIKit
import RxSwift

final class BettingResultTableView: UITableView {
    
    // MARK: Properties
    var items: [Rank] = []
    
    // MARK: Lifecycle
    init() {
        super.init(frame: .zero, style: .plain)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        self.dataSource = self
        
        self.backgroundColor = .white
        self.showsVerticalScrollIndicator = false
        self.separatorStyle = .none
        self.rowHeight = 68
        self.register(BettingResultCell.self)
        
        self.tableHeaderView = UIView()
        self.tableHeaderView?.frame.size.height = 22
    }
    
    private func layout() {
        self.layer.cornerRadius = 45
        self.layer.cornerCurve = .continuous
        self.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
    }
}

// MARK: - UITableViewDataSource
extension BettingResultTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeReusableCell(BettingResultCell.self, for: indexPath)
        cell.bind(with: items[indexPath.row])
        return cell
    }
}

// MARK: Binder
extension Reactive where Base: BettingResultTableView {
    var items: Binder<[Rank]> {
        return Binder(base) { base, element in
            base.items = element
            base.reloadData()
        }
    }
}