//
//  FirebaseFirestoreService.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/08.
//

import Foundation
import FirebaseDatabase
import RxSwift

protocol FirebaseDatabaseServiceProtocol {
    func request<R: Decodable, E: RequestResponsable>(with endpoint: E) -> Observable<Result<R, Error>> where E.Response == R
    func request<E>(with endpoint: E) -> Observable<Result<Void, Error>> where E : RequestResponsable, E.Response == Void
}

final class FirebaseDatabaseService {
    
    private let reference: DatabaseReference
    
    init(reference: DatabaseReference = Database.database().reference()) {
        self.reference = reference
    }
    
    private static func isArray<T>(type: T.Type) -> Bool {
        return T.self is AnyArray.Type
    }
    
    private func readData<R: Decodable>(path: String) -> Observable<Result<R, Error>> {
        let reference = reference.child(path)
        
        return Observable<Result<R, Error>>.create { observer in
            reference.getData { error, snapshot in
                if let error = error {
                    observer.onNext(.failure(error))
                    return
                }
                
                guard let snapshot = snapshot, !(snapshot.value is NSNull) else {
                    observer.onNext(.failure(FirebaseError.emptyResult))
                    return
                }
                let data = Self.isArray(type: R.self)
                ? snapshot.listToJSON
                : snapshot.valueToJSON
                
                guard let value = try? JSONDecoder().decode(R.self, from: data) else {
                    observer.onNext(.failure(FirebaseError.decodeError))
                    return
                }
                
                observer.onNext(.success(value))
            }
            
            return Disposables.create()
        }
    }
    
    private func deleteData(path: String) -> Observable<Result<Void, Error>> {
        let reference = reference.child(path)
        
        return Observable<Result<Void, Error>>.create { observer in
            reference.removeValue { error, _ in
                if let error = error {
                    observer.onNext(.failure(error))
                    return
                }
                
                observer.onNext(.success(Void()))
            }
            
            return Disposables.create()
        }
    }
    
    private func createData(_ dictionary: [String: Any], path: String) -> Observable<Result<Void, Error>> {
        let reference = reference.child(path)
        
        return Observable<Result<Void, Error>>.create { observer in
            reference.setValue(dictionary) { error, _ in
                if let error = error {
                    observer.onNext(.failure(error))
                    return
                }
                
                observer.onNext(.success(Void()))
            }
            
            return Disposables.create()
        }
    }
    
    private func updateData(_ dictionary: [String: Any], path: String) -> Observable<Result<Void, Error>> {
        let reference = reference.child(path)

        return Observable<Result<Void, Error>>.create { observer in
            reference.updateChildValues(dictionary) { error, _ in
                if let error = error {
                    observer.onNext(.failure(error))
                    return
                }

                observer.onNext(.success(Void()))
            }
            
            return Disposables.create()
        }
    }
}

extension FirebaseDatabaseService: FirebaseDatabaseServiceProtocol {
    
    func request<R: Decodable, E: RequestResponsable>(with endpoint: E) -> Observable<Result<R, Error>> where E.Response == R {
        
        switch endpoint.crud {
        case .read:
            return readData(path: endpoint.path)
            
        default:
            return .just(.failure(FirebaseError.invalidRequest))
        }
    }
    
    func request<E>(with endpoint: E) -> Observable<Result<Void, Error>> where E : RequestResponsable, E.Response == Void {
        
        switch endpoint.crud {
        case .delete:
            return deleteData(path: endpoint.path)
            
        case .create:
            guard let dictionary = try? endpoint.bodyParameters?.toDictionary() else {
                return .just(.failure(FirebaseError.failedToDictionary))
            }
            return createData(dictionary, path: endpoint.path)
            
        case .update:
            guard let dictionary = try? endpoint.bodyParameters?.toDictionary() else {
                return .just(.failure(FirebaseError.failedToDictionary))
            }
            return updateData(dictionary, path: endpoint.path)
            
        default:
            return .just(.failure(FirebaseError.invalidRequest))
        }
    }
}
