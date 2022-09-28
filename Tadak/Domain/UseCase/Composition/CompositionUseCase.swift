//
//  TadakListUseCase.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/13.
//

import Foundation
import RxSwift

final class CompositionUseCase: CompositionUseCaseProtocol {
    
    let titleMaxLength: Int = 12
    let artistMaxLength: Int = 12
    
    var title: AnyObserver<String> { _title.asObserver() }
    var artist: AnyObserver<String> { _artist.asObserver() }
    var contents: AnyObserver<String> { _contents.asObserver() }
    
    var tadakCompositionPage: BehaviorSubject<TadakCompositionPage?>
    var myCompositionPage: BehaviorSubject<MyCompositionPage?>
    
    private let _title = BehaviorSubject<String>(value: "")
    private let _artist = BehaviorSubject<String>(value: "")
    private let _contents = BehaviorSubject<String>(value: "")
    
    private let compositionRepository: CompositionRepositoryProtocol
    
    init(
        compositionRepository: CompositionRepositoryProtocol
    ) {
        self.compositionRepository = compositionRepository
        self.tadakCompositionPage = compositionRepository.tadakCompositionPage
        self.myCompositionPage = compositionRepository.myCompositionPage
    }
}

extension CompositionUseCase {
    
    func checkValidate() -> Observable<Bool> {
        return Observable
            .combineLatest(_title, _artist, _contents)
            .map { !$0.0.isEmpty && !$0.1.isEmpty && !$0.2.isEmpty }
    }
    
    func saveMyComposition() -> Observable<Void> {
        let repository = compositionRepository
        
        let composition = Observable
            .combineLatest(_title, _artist, _contents)
            .map { (UUID().uuidString, $0.0, $0.1, $0.2) }
            .map(MyComposition.init)
        
        return composition
            .flatMap { composition -> Observable<Void> in
                return repository.addMyComposition(composition)
                    .do { _ in
                        AnalyticsManager.log(CompositionEvent.create(composition: composition))
                    }
            }
            .retry(2)            
    }
    
    func selectedTadakComposition(index: Int) -> Observable<TadakComposition?> {
        return tadakCompositionPage.map { $0?.compositions[index] }
    }
    
    func selectedMyComposition(index: Int) -> Observable<MyComposition?> {
        return myCompositionPage.map { $0?.compositions[index] }
    }
    
    func removeMyComposition(index: Int) -> Observable<Void> {
        return myCompositionPage
            .compactMap(\.?.compositions)
            .filter { $0.count > index }
            .map { $0[index] }
            .flatMapFirst(compositionRepository.removeMyComposition)
            .do { _ in AnalyticsManager.log(CompositionEvent.delete) }
            .retry(2)
    }
}
