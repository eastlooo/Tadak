//
//  RecordUseCase.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/28.
//

import Foundation
import RxSwift
import RxRelay

final class RecordUseCase: RecordUseCaseProtocol {
    
    private let _records = BehaviorRelay<[Record]>(value: [])
    
    private let disposeBag = DisposeBag()
    
    private let recordRepository: RecordRepositoryProtocol
    
    init(recordRepository: RecordRepositoryProtocol) {
        self.recordRepository = recordRepository
        
        bind()
    }
}

extension RecordUseCase {
    
    func fetchRecords() -> Observable<[Record]> {
        return recordRepository.fetchRecords()
            .retry(2)
    }
    
    func updateRecord(_ record: Record) -> Observable<Void> {
        return recordRepository.updateRecord(record)
            .retry(2)
    }
    
    func getTypingSpeed(compositionID: String) -> Observable<Int> {
        return _records
            .map { $0.filter { $0.compositionID == compositionID }.first }
            .map { $0?.typingSpeed ?? 0 }
    }
}

private extension RecordUseCase {
    
    func bind() {
        recordRepository.records
            .bind(to: _records)
            .disposed(by: disposeBag)
    }
}
