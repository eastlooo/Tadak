//
//  CompositionUseCaseProtocol.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/26.
//

import Foundation
import RxSwift

protocol CompositionUseCaseProtocol: AnyObject {
    
    var titleMaxLength: Int { get }
    var artistMaxLength: Int { get }
    
    var title: AnyObserver<String> { get }
    var artist: AnyObserver<String> { get }
    var contents: AnyObserver<String> { get }
    
    var tadakCompositionPage: BehaviorSubject<TadakCompositionPage?> { get }
    var myCompositionPage: BehaviorSubject<MyCompositionPage?> { get }
    
    func checkValidate() -> Observable<Bool>
    func saveMyComposition() -> Observable<Void>
    func selectedTadakComposition(index: Int) -> Observable<TadakComposition?>
    func selectedMyComposition(index: Int) -> Observable<MyComposition?>
    func removeMyComposition(index: Int) -> Observable<Void>
}
