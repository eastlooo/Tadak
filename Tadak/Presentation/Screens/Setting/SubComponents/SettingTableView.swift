//
//  SettingTableView.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/29.
//

import UIKit
import RxSwift

final class SettingTableView: UITableView {
    
    // MARK: Properties
    var items: [[Setting]] = []
    
    private let headerView = SettingTableHeaderView()
    private let footerView = SettingTableFooterView()
    
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
        self.register(SettingCell.self)
        self.backgroundColor = .customDarkNavy
        self.rowHeight = 70
        self.sectionFooterHeight = 15
        self.separatorStyle = .none
        self.separatorColor = .customDarkNavy
        self.dataSource = self
        self.delegate = self
        
        self.tableHeaderView = headerView
        headerView.frame.size.height = 0
        
        self.tableFooterView = footerView
        footerView.frame.size.height = 30
    }
}

// MARK: - UITableViewDataSource
extension SettingTableView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeReusableCell(SettingCell.self, for: indexPath)
        let sectionItems = items[indexPath.section]
        let item = sectionItems[indexPath.row]
        cell.bind(with: item)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SettingTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
}

// MARK: Binder
extension Reactive where Base: SettingTableView {
    
    var items: Binder<[[Setting]]> {
        return Binder(base) { base, element in
            base.items = element
            base.reloadData()
        }
    }
}
