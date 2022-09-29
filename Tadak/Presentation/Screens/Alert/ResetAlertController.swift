//
//  ResetAlertController.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/29.
//

import UIKit
import ReactorKit

final class ResetAlertController: AlertController {
    
    // MARK: Properties
    var disposeBag = DisposeBag()
    
    private let cancelAction = AlertAction(title: "취소", style: .cancel)
    private let okAction = AlertAction(title: "확인", style: .default)
    
    // MARK: Lifecycle
    init() {
        super.init(nibName: nil, bundle: nil)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        self.autoDismissMode = false
        
        let title = "데이터 초기화"
        let message = "사용자 정보, 기록 정보 등\n해당 기기에 저장된 앱 데이터를\n모두 삭제합니다."
        
        self.alertTitle = title
        self.alertMessage = message
        self.addAction(cancelAction)
        self.addAction(okAction)
    }
}

extension ResetAlertController: View {
    
    func bind(reactor: ResetAlertReactor) {
        
        // MARK: Action
        self.rx.defaultButtonTapped
            .map(ResetAlertReactor.Action.defaultButtonTapped)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.rx.cancelButtonTapped
            .map(ResetAlertReactor.Action.cancelButtonTapped)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: State
    }
}
