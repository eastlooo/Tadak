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
    func request<E>(with endpoints: [E]) -> Observable<Result<Void, Error>> where E : RequestResponsable, E.Response == Void
}

final class FirebaseDatabaseService {
    
    private let reference: DatabaseReference
    
    init(reference: DatabaseReference = Database.database().reference()) {
        self.reference = reference
    }
}

extension FirebaseDatabaseService: FirebaseDatabaseServiceProtocol {
    
    func request<R: Decodable, E: RequestResponsable>(with endpoint: E) -> Observable<Result<R, Error>> where E.Response == R {
        
        switch endpoint.crud {
        case .read:
            return readObject(path: endpoint.path)
            
        default:
            return .just(.failure(FirebaseError.invalidRequest))
        }
    }
    
    func request<E>(with endpoint: E) -> Observable<Result<Void, Error>> where E : RequestResponsable, E.Response == Void {
        
        switch endpoint.crud {
        case .read:
            return readObject(path: endpoint.path)
            
        case .delete:
            return deleteObject(path: endpoint.path)
            
        case .create:
            guard let dictionary = try? endpoint.object?.toDictionary() else {
                return .just(.failure(FirebaseError.failedToDictionary))
            }
            return createObject(dictionary, path: endpoint.path)
            
        case .update:
            guard let dictionary = try? endpoint.object?.toDictionary() else {
                return .just(.failure(FirebaseError.failedToDictionary))
            }
            return updateObject(dictionary, path: endpoint.path)
        }
    }
    
    func request<E>(with endpoints: [E]) -> Observable<Result<Void, Error>> where E : RequestResponsable, E.Response == Void {
        
        let reference = self.reference
        
        guard !endpoints.contains(where: { $0.crud == .read }) else {
            return .just(.failure(FirebaseError.invalidRequest))
        }
        
        var newDictionary = [String: Any]()
        for endpoint in endpoints {
            switch endpoint.crud {
            case .create, .update:
                guard let dictionary = try? endpoint.object?.toDictionary() else {
                    return .just(.failure(FirebaseError.failedToDictionary))
                }
                newDictionary[endpoint.path] = dictionary
                
            case .delete:
                newDictionary[endpoint.path] = NSNull()
                
            default:
                break
            }
        }
        
        return Observable<Result<Void, Error>>.create { observer in
            reference.updateChildValues(newDictionary) { error, _ in
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

private extension FirebaseDatabaseService {
    static func isArray<T>(type: T.Type) -> Bool {
        return T.self is AnyArray.Type
    }
    
    func readObject<R: Decodable>(path: String) -> Observable<Result<R, Error>> {
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
    
    func readObject(path: String) -> Observable<Result<Void, Error>> {
        let reference = reference.child(path)
        
        return Observable<Result<Void, Error>>.create { observer in
            reference.getData { error, snapshot in
                if let error = error {
                    observer.onNext(.failure(error))
                    return
                }
                
                guard let snapshot = snapshot, !(snapshot.value is NSNull) else {
                    observer.onNext(.failure(FirebaseError.emptyResult))
                    return
                }
                
                observer.onNext(.success(Void()))
            }
            
            return Disposables.create()
        }
    }
    
    func deleteObject(path: String) -> Observable<Result<Void, Error>> {
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
    
    func createObject(_ dictionary: [String: Any], path: String) -> Observable<Result<Void, Error>> {
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
    
    func updateObject(_ dictionary: [String: Any], path: String) -> Observable<Result<Void, Error>> {
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
    
    func updateObjects(_ dictionarys: [[String: Any]], paths: [String]) -> Observable<Result<Void, Error>> {
        let reference = self.reference
        
        var newDictionary = [String: Any]()
        for index in 0..<paths.count {
            newDictionary[paths[index]] = dictionarys[index]
        }
        
        return Observable<Result<Void, Error>>.create { observer in
            reference.updateChildValues(newDictionary) { error, _ in
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
