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
    private var dataSource = (1...20).shuffled().map { $0 }
    
    private lazy var collectionView: UICollectionView = {
        let cellWidth = (UIScreen.main.bounds.width - 70) / 3
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = .init(width: cellWidth, height: cellWidth)
        flowLayout.minimumLineSpacing = 16
        flowLayout.sectionInset = .zero
        let headerWidth = UIScreen.main.bounds.width
        flowLayout.headerReferenceSize = .init(width: headerWidth, height: 200)
        let collectionView = UICollectionView(
            frame: .zero, collectionViewLayout: flowLayout
        )
        collectionView.register(
            OnboardingCharacterHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: OnboardingCharacterHeaderView.reuseIdentifier)
        collectionView.register(
            OnboardingCharacterCell.self,
            forCellWithReuseIdentifier: OnboardingCharacterCell.reuseIdentifier
        )
        collectionView.dataSource = self
        collectionView.backgroundColor = .customNavy
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
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
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: OnboardingCharacterHeaderView.reuseIdentifier,
            for: indexPath
        ) as! OnboardingCharacterHeaderView
        return headerView
    }
}
