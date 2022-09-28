//
//  CompositionRepositoryProtocol.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/26.
//

import Foundation
import RxSwift

protocol CompositionRepositoryProtocol {
    
    var tadakCompositionPage: BehaviorSubject<TadakCompositionPage?> { get }
    var myCompositionPage: BehaviorSubject<MyCompositionPage?> { get }
    
    func fetchTadakComposition() -> Observable<TadakCompositionPage>
    func fetchMyComposition() -> Observable<MyCompositionPage?>
    func addMyComposition(_ compostion: MyComposition) -> Observable<Void>
    func removeMyComposition(_ compostion: MyComposition) -> Observable<Void>
}
