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
    var items: [(String, String)] = [
        ("메밀꽃 필 무렵", "메밀꽃 핀 무렵"),
        ("여름장이란 애시당초에 글러서,", "여름장이란 애시당초에 글러서,"),
        ("해는 아직 중천에 있건만", "햬는 아직 중천에 있건만"),
        ("장판은 벌써 쓸쓸하고 더운", "장판은 벌서 쓸쓸하고 더운"),
        ("햇발이 벌여 녾은 전 휘장 밑", "햇발이 벌여 녾은 전 휘장 밑"),
        ("으로 등줄기를 훅훅 볶는다.", "으로 등줄기를 훅훅 볶는다.")
    ]
    
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
        let originalText = items[indexPath.row].0
        let userText = items[indexPath.row].1
        cell.bind(originalText: originalText, userText: userText)
        return cell
    }
}

// MARK: Binder
extension Reactive where Base: PracticeResultTableView {
    var items: Binder<[(String, String)]> {
        return Binder(base) { base, element in
            base.items = element
            base.reloadData()
        }
    }
}
