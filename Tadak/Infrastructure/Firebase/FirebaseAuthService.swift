//
//  FirebaseAuthService.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/12.
//

import Foundation
import FirebaseAuth
import RxSwift

protocol FirebaseAuthServiceProtocol {
    
    var userID: String? { get }
    
    func signOut() -> Observable<Result<Void, Error>>
    func signInAnonymously() -> Observable<Result<String, Error>>
    func deleteUser() -> Observable<Result<Void, Error>>
}

final class FirebaseAuthService {
    
    var userID: String? { auth.currentUser?.uid }
    
    private let auth: Auth
    
    init(auth: Auth = Auth.auth()) {
        self.auth = auth
    }
}

extension FirebaseAuthService: FirebaseAuthServiceProtocol {
    
    func signOut() -> Observable<Result<Void, Error>> {
        return .create { [weak self] observer in
            do {
                try self?.auth.signOut()
                observer.onNext(.success(Void()))
            } catch {
                observer.onNext(.failure(error))
            }
            
            return Disposables.create()
        }
    }
    
    func signInAnonymously() -> Observable<Result<String, Error>> {
        return .create { [weak self] observer in
            self?.auth.signInAnonymously { authResult, error in
                if let error = error {
                    observer.onNext(.failure(error))
                    return
                }
                
                guard let uid = authResult?.user.uid else {
                    observer.onNext(.failure(FirebaseError.emptyResult))
                    return
                }
                
                observer.onNext(.success(uid))
            }
            
            return Disposables.create()
        }
    }
    
    func deleteUser() -> Observable<Result<Void, Error>> {
        return .create { [weak self] observer in
            self?.auth.currentUser?.delete(completion: { error in
                if let error = error {
                    observer.onNext(.failure(error))
                    return
                }
                
                observer.onNext(.success(Void()))
            })
            
            return Disposables.create()
        }
    }
}
