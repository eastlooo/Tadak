//
//  RecordUseCaseProtocol.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/28.
//

import Foundation
import RxSwift

protocol RecordUseCaseProtocol {
    
    func fetchRecords() -> Observable<[Record]>
    func updateRecord(_ record: Record) -> Observable<Void>
    func getTypingSpeed(compositionID: String) -> Observable<Int>
}
