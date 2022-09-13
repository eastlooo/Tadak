//
//  TadakListUseCase.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/13.
//

import Foundation
import RxSwift

protocol TadakListUseCaseProtocol: AnyObject {
    
    var tadakComposition: BehaviorSubject<TadakComposition?> { get }
    
    func getComposition(index: Int) -> Composition?
}

final class TadakListUseCase {
    
    var tadakComposition: BehaviorSubject<TadakComposition?> { tadakComposition$ }
    
    private let tadakComposition$: BehaviorSubject<TadakComposition?>
    
    init(
        compositionRepository: CompositionRepositoryProtocol
    ) {
        self.tadakComposition$ = compositionRepository.tadakComposition
    }
}

extension TadakListUseCase: TadakListUseCaseProtocol {
    
    func getComposition(index: Int) -> Composition? {
        guard let tadakComposition = try? tadakComposition.value() else {
            return nil
        }
        
        return tadakComposition.compositions[index]
    }
}
