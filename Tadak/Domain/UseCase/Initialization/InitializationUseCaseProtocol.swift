//
//  InitializationUseCaseProtocol.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/28.
//

import Foundation
import RxSwift

protocol InitializationUseCaseProtocol: AnyObject {
    
    var user: Observable<TadakUser?> { get }
    
    func fetchUser() -> Observable<TadakUser?>
    func fetchCompositions() -> Observable<Void>
}
