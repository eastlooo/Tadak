//
//  Storage.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/10.
//

import Foundation
import RxSwift

protocol Storage {
    func create<T: Storable>(_ model: T.Type) -> Observable<Result<T, Error>>
    func save(object: Storable) -> Observable<Result<Void, Error>>
    func update(block: @escaping() -> Void) -> Observable<Result<Void, Error>>
    func delete(object: Storable) -> Observable<Result<Void, Error>>
    func deleteAll<T: Storable>(_ model: T.Type) -> Observable<Result<Void, Error>>
    func reset() -> Observable<Result<Void, Error>>
    func fetch<T: Storable>(_ model: T.Type, predicate: NSPredicate?, sorted: Sorted?) -> Observable<[T]>
}
