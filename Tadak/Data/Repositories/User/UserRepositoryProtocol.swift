//
//  UserRepositoryProtocol.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/19.
//

import Foundation
import RxSwift

protocol UserRepositoryProtocol {
    
    var user: Observable<TadakUser?> { get }
    
    func checkNickname(nickname: String) -> Observable<Void>
    func signInUserAnonymously() -> Observable<String>
    func createUser(uid: String, nickname: String, characterID: Int) -> Observable<TadakUser>
    func deleteUser(uid: String, nickname: String) -> Observable<Void>
    func fetchUser() -> Observable<TadakUser?>
}
