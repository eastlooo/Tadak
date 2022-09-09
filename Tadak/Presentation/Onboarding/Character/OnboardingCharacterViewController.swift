//
//  OnboardingCharacterViewController.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/04.
//

import UIKit
import SnapKit
import ReactorKit
import RxCocoa

final class OnboardingCharacterViewController: UIViewController {
    
    // MARK: Properties
    var disposeBag = DisposeBag()
    
    private let collectionView = OnboardingCharacterCollectionView()
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        layout()
    }
    
    // MARK: Helpers
    private func configure() {
        view.backgroundColor = .customNavy
    }
    
    private func layout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview().inset(20.0)
            $0.bottom.equalToSuperview()
        }
    }
}

// MARK: - Bind
extension OnboardingCharacterViewController: View {
    func bind(reactor: OnboardingCharacterViewReactor) {
        collectionView.rx.itemSelected
            .map(OnboardingCharacterViewReactor.Action.itemSelected)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map(\.items)
            .bind(to: collectionView.rx.items)
            .disposed(by: disposeBag)
    }
}
