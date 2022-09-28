//
//  RecordRepository.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/28.
//

import Foundation
import RxSwift
import RxRelay

final class RecordRepository {
    
    var records: Observable<[Record]> { _records.asObservable() }
    
    private let _records = BehaviorRelay<[Record]>(value: [])
    
    private var storage: Storage?
    
    init (
        storage: Storage? = try? RealmStorage()
    ) {
        self.storage = storage
    }
}

extension RecordRepository: RecordRepositoryProtocol {
    
    func fetchRecords() -> Observable<[Record]> {
        do {
            let storage = try unwrapStorage(storage)
            
            return storage.fetch(RecordObject.self, predicate: nil, sorted: nil)
                .map { $0.map { $0.toDomain() } }
                .do { [weak self] records in self?._records.accept(records) }
            
        } catch { return .error(RealmError.failedInitialization) }
    }
    
    func updateRecord(_ record: Record) -> Observable<Void> {
        do {
            let storage = try unwrapStorage(storage)
            
            let id = record.compositionID
            let recordObject = RecordObject(record: record)
            
            return storage.fetch(RecordObject.self, predicate: nil, sorted: nil)
                .map { $0.filter { $0.compositionID == id }.first }
                .flatMap { object -> Observable<Void> in
                    if let object = object {
                        return storage.update {
                            object.update(record: record)
                        }
                    }
                    
                    return storage.save(object: recordObject)
                }
                .withLatestFrom(_records)
                .map { [weak self] records in
                    if let index = records.firstIndex(where: {
                        $0.compositionID == id
                    }) {
                        var records = records
                        records[index] = record
                        self?._records.accept(records)
                    }
                }
            
        } catch { return .error(RealmError.failedInitialization) }
    }
}

private extension RecordRepository {
    
    func unwrapStorage(_ storage: Storage?) throws -> Storage {
        if let storage = storage {
            return storage
        }
        
        let newStorage = try RealmStorage()
        self.storage = newStorage
        return newStorage
    }
}
