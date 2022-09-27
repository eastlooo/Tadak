//
//  CompositionRepositoryProtocol.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/26.
//

import Foundation
import RxSwift

protocol CompositionRepositoryProtocol {
    
    var tadakComposition: BehaviorSubject<TadakComposition?> { get }
    var myComposition: BehaviorSubject<MyComposition?> { get }
    
    func fetchTadakComposition() -> Observable<TadakComposition>
    func fetchMyComposition() -> Observable<MyComposition?>
    func appendMyComposition(_ compostion: Composition) -> Observable<Void>
    func removeMyComposition(_ compostion: Composition) -> Observable<Void>
}
