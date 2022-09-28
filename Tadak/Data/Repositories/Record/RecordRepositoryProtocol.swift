//
//  RecordRepositoryProtocol.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/28.
//

import Foundation
import RxSwift

protocol RecordRepositoryProtocol {
    
    var records: Observable<[Record]> { get }
    
    func fetchRecords() -> Observable<[Record]>
    func updateRecord(_ record: Record) -> Observable<Void>
}
