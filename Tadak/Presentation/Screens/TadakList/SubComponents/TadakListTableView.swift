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
    var items: [TadakListCellItem] = [] {
        didSet {
            self.animatedList = self.items.map { _ in true }
            
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    
    var tableAnimation: TableAnimation = .moveUpWithFade(rowHeight: 100, duration: 0.4, delay: 0.03)
    
    private var animatedList: [Bool] = []
    
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

// MARK: - UITableViewDelegate
extension TadakListTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard animatedList[indexPath.row] else { return }
        
        let animation = tableAnimation.getAnimation()
        let animator = TableViewAnimator(animation: animation)
        animator.animate(tableView, cell: cell, at: indexPath)
        
        self.animatedList[indexPath.row] = false
    }
}

// MARK: - Rx+Extension
extension Reactive where Base: TadakListTableView {
    
    // MARK: Binder
    var items: Binder<[TadakListCellItem]> {
        return Binder(base) { base, element in
            base.items = element
        }
    }
}
