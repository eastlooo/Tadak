//
//  FirebaseAuthService.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/12.
//

import Foundation
import FirebaseAuth
import RxSwift

final class FirebaseAuthService {
    
    var userID: String? { auth.currentUser?.uid }
    
    private let auth: Auth
    
    init(auth: Auth = Auth.auth()) {
        self.auth = auth
    }
}

extension FirebaseAuthService: FirebaseAuthServiceProtocol {
    
    func signOut() -> Observable<Void> {
        return .create { [weak self] observer in
            do {
                try self?.auth.signOut()
                observer.onNext(())
            } catch {
                observer.onError(error)
            }
            
            return Disposables.create()
        }
    }
    
    func signInAnonymously() -> Observable<String> {
        return .create { [weak self] observer in
            self?.auth.signInAnonymously { authResult, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                guard let uid = authResult?.user.uid else {
                    observer.onError(FirebaseError.emptyResult)
                    return
                }
                
                observer.onNext(uid)
            }
            
            return Disposables.create()
        }
    }
    
    func deleteUser() -> Observable<Void> {
        return .create { [weak self] observer in
            self?.auth.currentUser?.delete(completion: { error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                observer.onNext(Void())
            })
            
            return Disposables.create()
        }
    }
}
