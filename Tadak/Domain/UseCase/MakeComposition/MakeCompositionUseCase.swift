//
//  MakeCompositionUseCase.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/24.
//

import Foundation
import RxSwift

final class MakeCompositionUseCase {
    
    let titleMaxLength: Int = 12
    let artistMaxLength: Int = 12
    
    var title: AnyObserver<String> { _title.asObserver() }
    var artist: AnyObserver<String> { _artist.asObserver() }
    var contents: AnyObserver<String> { _contents.asObserver() }
    
    private let _title = BehaviorSubject<String>(value: "")
    private let _artist = BehaviorSubject<String>(value: "")
    private let _contents = BehaviorSubject<String>(value: "")
    
    private let compositionRepository: CompositionRepositoryProtocol
    init(compositionRepository: CompositionRepositoryProtocol) {
        self.compositionRepository = compositionRepository
    }
}

extension MakeCompositionUseCase: MakeCompositionUseCaseProtocol {
    
    func checkValidate() -> Observable<Bool> {
        return Observable
            .combineLatest(_title, _artist, _contents)
            .map { !$0.0.isEmpty && !$0.1.isEmpty && !$0.2.isEmpty }
    }
    
    func saveComposition() -> Observable<Void> {
        let composition = Observable
            .combineLatest(_title, _artist, _contents)
            .map { (UUID().uuidString, $0.0, $0.1, $0.2) }
            .map(Composition.init)
        
        return composition
            .flatMap(compositionRepository.appendMyComposition)
            .retry(2)
    }
}
