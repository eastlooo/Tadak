//
//  FirebaseAuthServiceProtocol.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/18.
//

import Foundation
import RxSwift

protocol FirebaseAuthServiceProtocol {
    
    var userID: String? { get }
    
    func signOut() -> Observable<Void>
    func signInAnonymously() -> Observable<String>
    func deleteUser() -> Observable<Void>
}
