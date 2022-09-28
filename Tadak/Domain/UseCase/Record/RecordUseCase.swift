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
        let id = record.compositionID
        let prevScore = self.getTypingSpeed(compositionID: id) ?? 0
        
        guard record.typingSpeed > prevScore else { return .just(Void()) }
        
        return recordRepository.updateRecord(record).retry(2)
    }
    
    func getTypingSpeed(compositionID: String) -> Int? {
        return _records.value
            .filter { $0.compositionID == compositionID }
            .first
            .map(\.typingSpeed)
    }
}

private extension RecordUseCase {
    
    func bind() {
        recordRepository.records
            .bind(to: _records)
            .disposed(by: disposeBag)
    }
}
