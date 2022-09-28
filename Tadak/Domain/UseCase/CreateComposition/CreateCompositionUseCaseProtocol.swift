//
//  CreateCompositionUseCaseProtocol.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/24.
//

import Foundation
import RxSwift

protocol CreateCompositionUseCaseProtocol {
    
    var titleMaxLength: Int { get }
    var artistMaxLength: Int { get }
    
    var title: AnyObserver<String> { get }
    var artist: AnyObserver<String> { get }
    var contents: AnyObserver<String> { get }
    
    func checkValidate() -> Observable<Bool>
    func saveComposition() -> Observable<Void>
}
