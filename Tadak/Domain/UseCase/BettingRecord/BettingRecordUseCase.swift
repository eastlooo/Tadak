//
//  BettingRecordUseCase.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/22.
//

import Foundation
import RxSwift
import RxRelay

final class BettingRecordUseCase: BettingRecordUseCaseProtocol {
    
    var participant: Observable<String> {
        return _currentIndex
            .withLatestFrom(_participants) { (index: $0, participants: $1) }
            .filter { $0.participants.count > $0.index }
            .map { $0.participants[$0.index] }
    }
    
    var finished: Observable<Void> {
        return _currentIndex
            .withLatestFrom(_participants) { (index: $0, participants: $1) }
            .filter { $0.participants.count > 0 }
            .filter { $0.participants.count <= $0.index }
            .map { _ in }
    }
    
    let numOfParticipants: Int
    
    private let disposeBag = DisposeBag()
    
    private let _participants: BehaviorRelay<[String]>
    private let _records = BehaviorRelay<[(participant: String, record: Record)]>(value: [])
    private let _currentIndex = BehaviorRelay<Int>(value: 0)
    private let _newRecord = PublishRelay<(participant: String, record: Record)>()
    
    init(participants: [String]) {
        let shuffled = participants.shuffled().shuffled().shuffled()
        self.numOfParticipants = participants.count
        self._participants = .init(value: shuffled)
        
        bind()
    }
}

extension BettingRecordUseCase {
    
    func updateRecord(participant: String, record: Record) {
        _newRecord.accept((participant, record))
    }
    
    func getRankingTable() -> Observable<[Rank]> {
        return _records
            .map { records -> [Rank] in
                records
                    .sorted { lhs, rhs in
                        if lhs.record.accuracy == rhs.record.accuracy {
                            return lhs.record.typingSpeed > rhs.record.typingSpeed
                        }
                        return lhs.record.accuracy > rhs.record.accuracy
                    }
                    .enumerated()
                    .map { ($0.offset+1, $0.element.participant, $0.element.record) }
                    .map(Rank.init)
            }
    }
}

private extension BettingRecordUseCase {
    
    func bind() {
        // Update Record
        let newRecord = _newRecord
            .withLatestFrom(_records) { $1 + [$0] }
            .share()
        
        newRecord
            .bind(to: _records)
            .disposed(by: disposeBag)
        
        newRecord
            .withLatestFrom(_currentIndex) { $1 + 1 }
            .bind(to: _currentIndex)
            .disposed(by: disposeBag)
    }
}
