//
//  OnboardingCharacterViewController.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/04.
//

import UIKit
import SnapKit

final class OnboardingCharacterViewController: UIViewController {
    
    // MARK: Properties
    private var dataSource = (1...20).shuffled().shuffled().shuffled().map { $0 }
    
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
        collectionView.dataSource = self
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

// MARK: - UICollectionViewDataSource
extension OnboardingCharacterViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: OnboardingCharacterCell.reuseIdentifier,
            for: indexPath
        ) as! OnboardingCharacterCell
        cell.bind(dataSource[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: OnboardingCharacterHeaderView.reuseIdentifier,
                for: indexPath
            ) as! OnboardingCharacterHeaderView
            return headerView
            
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: OnboardingCharacterFooterView.reuseIdentifier,
                for: indexPath
            ) as! OnboardingCharacterFooterView
            return footerView
            
        default: return UICollectionReusableView()
        }
    }
}
