//
//  CompositionUseCaseProtocol.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/26.
//

import Foundation
import RxSwift

protocol CompositionUseCaseProtocol: AnyObject {
    
    var tadakComposition: BehaviorSubject<TadakComposition?> { get }
    var myComposition: BehaviorSubject<MyComposition?> { get }
    
    func selectedTadakComposition(index: Int) -> Observable<Composition?>
    func selectedMyComposition(index: Int) -> Observable<Composition?>
    func removeMyComposition(index: Int) -> Observable<Void>
}
