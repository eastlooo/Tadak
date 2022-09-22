//
//  OnboardingCharacterCollectionView.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/05.
//

import UIKit
import RxSwift

final class OnboardingCharacterCollectionView: UICollectionView {
    
    // MARK: Properties
    var items: [Int] = []
    
    // MARK: Lifecycle
    init() {
        super.init(frame: .zero, collectionViewLayout: .init())
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Helpers
    private func configure() {
        self.dataSource = self
        self.backgroundColor = .customNavy
        self.showsVerticalScrollIndicator = false
        self.collectionViewLayout = createCompositionalLayout()
        
        self.register(OnboardingCharacterCell.self)
        self.register(OnboardingCharacterHeaderView.self, kind: .header)
        self.register(OnboardingCharacterFooterView.self, kind: .footer)
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

// MARK: - UICollectionViewDataSource
extension OnboardingCharacterCollectionView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(OnboardingCharacterCell.self, for: indexPath)
        cell.bind(items[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSectionHeaderView(
                OnboardingCharacterHeaderView.self,
                for: indexPath
            )
            
            return headerView
            
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSectionFooterView(
                OnboardingCharacterFooterView.self,
                for: indexPath
            )
            
            return footerView
            
        default: return UICollectionReusableView()
        }
    }
}

// MARK: - Binder
extension Reactive where Base: OnboardingCharacterCollectionView {
    var items: Binder<[Int]> {
        Binder(base) { base, items in
            base.items = items
            base.reloadData()
        }
    }
}
