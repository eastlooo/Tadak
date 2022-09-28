//
//  TadakListUseCase.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/13.
//

import Foundation
import RxSwift

final class CompositionUseCase: CompositionUseCaseProtocol {
    
    var tadakComposition: BehaviorSubject<TadakComposition?>
    var myComposition: BehaviorSubject<MyComposition?>
    
    private let compositionRepository: CompositionRepositoryProtocol
    
    init(
        compositionRepository: CompositionRepositoryProtocol
    ) {
        self.compositionRepository = compositionRepository
        self.tadakComposition = compositionRepository.tadakComposition
        self.myComposition = compositionRepository.myComposition
    }
}

extension CompositionUseCase {
    
    func selectedTadakComposition(index: Int) -> Observable<Composition?> {
        return tadakComposition.map { $0?.compositions[index] }
    }
    
    func selectedMyComposition(index: Int) -> Observable<Composition?> {
        return myComposition.map { $0?.compositions[index] }
    }
    
    func removeMyComposition(index: Int) -> Observable<Void> {
        return myComposition
            .compactMap(\.?.compositions)
            .filter { $0.count > index }
            .map { $0[index] }
            .flatMapFirst(compositionRepository.removeMyComposition)
            .retry(2)
    }
}
