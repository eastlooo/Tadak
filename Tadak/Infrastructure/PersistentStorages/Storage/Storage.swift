//
//  Storage.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/10.
//

import Foundation
import RxSwift

protocol Storage {
    func create<T: Storable>(_ model: T.Type) -> Observable<T>
    func save(object: Storable) -> Observable<Void>
    func update(block: @escaping() -> Void) -> Observable<Void>
    func delete(object: Storable) -> Observable<Void>
    func deleteAll<T: Storable>(_ model: T.Type) -> Observable<Void>
    func reset() -> Observable<Void>
    func fetch<T: Storable>(_ model: T.Type, predicate: NSPredicate?, sorted: Sorted?) -> Observable<[T]>
}
