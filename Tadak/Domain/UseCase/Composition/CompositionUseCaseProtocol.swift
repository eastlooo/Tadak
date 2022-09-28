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
    
    var tadakComposition: BehaviorSubject<TadakComposition?> { get }
    var myComposition: BehaviorSubject<MyComposition?> { get }
    
    func checkValidate() -> Observable<Bool>
    func saveComposition() -> Observable<Void>
    func selectedTadakComposition(index: Int) -> Observable<Composition?>
    func selectedMyComposition(index: Int) -> Observable<Composition?>
    func removeMyComposition(index: Int) -> Observable<Void>
}
