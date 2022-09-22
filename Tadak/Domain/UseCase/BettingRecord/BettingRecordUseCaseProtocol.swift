//
//  BettingRecordUseCaseProtocol.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/22.
//

import Foundation
import RxSwift

protocol BettingRecordUseCaseProtocol {
    
    var participant: Observable<String> { get }
    var finished: Observable<Void> { get }
    
    func updateRecord(participant: String, record: Record)
    func getRankingTable() -> Observable<[Ranking]>
}
