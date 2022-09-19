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
    
    func getComposition(index: Int) -> Observable<Composition?>
}

final class TadakListUseCase {
    
    var tadakComposition: BehaviorSubject<TadakComposition?>
    
    init(
        compositionRepository: CompositionRepositoryProtocol
    ) {
        self.tadakComposition = compositionRepository.tadakComposition
    }
}

extension TadakListUseCase: TadakListUseCaseProtocol {
    
    func getComposition(index: Int) -> Observable<Composition?> {
        return tadakComposition.map { $0?.compositions[index] }
    }
}
