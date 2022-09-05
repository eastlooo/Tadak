//
//  OnboardingCharacterCollectionView.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/05.
//

import UIKit

final class OnboardingCharacterCollectionView: UICollectionView {
    
    // MARK: Lifecycle
    init() {
        super.init(frame: .zero, collectionViewLayout: .init())
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .customNavy
        self.showsVerticalScrollIndicator = false
        self.collectionViewLayout = createCompositionalLayout()
        
        self.register(
            OnboardingCharacterHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: OnboardingCharacterHeaderView.reuseIdentifier)
        self.register(
            OnboardingCharacterCell.self,
            forCellWithReuseIdentifier: OnboardingCharacterCell.reuseIdentifier
        )
        self.register(OnboardingCharacterFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: OnboardingCharacterFooterView.reuseIdentifier)
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let cellWidth = (UIScreen.main.bounds.width - 70) / 3
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = .init(width: cellWidth, height: cellWidth)
        flowLayout.minimumLineSpacing = 16
        flowLayout.sectionInset = .zero
        let width = UIScreen.main.bounds.width
        flowLayout.headerReferenceSize = .init(width: width, height: 280)
        flowLayout.footerReferenceSize = .init(width: width, height: 30)
        return flowLayout
    }
}
