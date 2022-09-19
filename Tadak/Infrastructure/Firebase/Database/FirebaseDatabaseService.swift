//
//  FirebaseFirestoreService.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/08.
//

import Foundation
import FirebaseDatabase
import RxSwift

final class FirebaseDatabaseService {
    
    private let reference: DatabaseReference
    
    init(reference: DatabaseReference = Database.database().reference()) {
        self.reference = reference
    }
}

extension FirebaseDatabaseService: FirebaseDatabaseServiceProtocol {
    
    func request<R: Decodable, E: RequestResponsable>(with endpoint: E) -> Observable<R> where E.Response == R {
        
        switch endpoint.crud {
        case .read:
            return readObject(path: endpoint.path)
            
        default:
            return .error(FirebaseError.invalidRequest)
        }
    }
    
    func request<R: Decodable, E: RequestResponsable>(with endpoint: E) -> Observable<[R]> where E.Response == [R] {
        
        switch endpoint.crud {
        case .read:
            return readObjects(path: endpoint.path)
            
        default:
            return .error(FirebaseError.invalidRequest)
        }
    }
    
    func request<E>(with endpoint: E) -> Observable<Void> where E : RequestResponsable, E.Response == Void {
        
        switch endpoint.crud {
        case .read:
            return readObject(path: endpoint.path)
            
        case .delete:
            return deleteObject(path: endpoint.path)
            
        case .create:
            guard let dictionary = try? endpoint.object?.toDictionary() else {
                return .error(FirebaseError.failedCastToDictionary)
            }
            return createObject(dictionary, path: endpoint.path)
            
        case .update:
            guard let dictionary = try? endpoint.object?.toDictionary() else {
                return .error(FirebaseError.failedCastToDictionary)
            }
            return updateObject(dictionary, path: endpoint.path)
        }
    }
    
    func request<E>(with endpoints: [E]) -> Observable<Void> where E : RequestResponsable, E.Response == Void {
        
        let reference = self.reference
        
        guard !endpoints.contains(where: { $0.crud == .read }) else {
            return .error(FirebaseError.invalidRequest)
        }
        
        var newDictionary = [String: Any]()
        for endpoint in endpoints {
            switch endpoint.crud {
            case .create, .update:
                guard let dictionary = try? endpoint.object?.toDictionary() else {
                    return .error(FirebaseError.failedCastToDictionary)
                }
                newDictionary[endpoint.path] = dictionary
                
            case .delete:
                newDictionary[endpoint.path] = NSNull()
                
            default:
                break
            }
        }
        
        return Observable<Void>.create { observer in
            reference.updateChildValues(newDictionary) { error, _ in
                if let error = error {
                    observer.onError(error)
                    return
                }

                observer.onNext(())
            }
            
            return Disposables.create()
        }
    }
}

private extension FirebaseDatabaseService {
    
    static func isArray<T>(type: T.Type) -> Bool {
        return T.self is AnyArray.Type
    }
    
    func readObject<R: Decodable>(path: String) -> Observable<R> {
        let reference = reference.child(path)

        return Observable<R>.create { observer in
            reference.getData { error, snapshot in
                if let error = error {
                    observer.onError(error)
                    return
                }

                guard let snapshot = snapshot, !(snapshot.value is NSNull) else {
                    observer.onError(FirebaseError.emptyResult)
                    return
                }
                
                let data = snapshot.valueToJSON

                guard let value = try? Self.decode(R.self, from: data) else {
                    guard var value = snapshot.value as? R else {
                        observer.onError(FirebaseError.decodeError)
                        return
                    }
                    
                    if value is String, let stringValue = value as? String {
                        value = stringValue.replacingOccurrences(of: "\\n", with: "\n") as! R
                    }
                    
                    observer.onNext(value)
                    return
                }

                observer.onNext(value)
            }

            return Disposables.create()
        }
    }
    
    func readObjects<R: Decodable>(path: String) -> Observable<[R]> {
        let reference = reference.child(path)
        
        return Observable<[R]>.create { observer in
            reference.getData { error, snapshot in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                guard let snapshot = snapshot, !(snapshot.value is NSNull) else {
                    observer.onError(FirebaseError.emptyResult)
                    return
                }
                
                let data = snapshot.listToJSON
                
                guard let value = try? Self.decode([R].self, from: data) else {
                    observer.onError(FirebaseError.decodeError)
                    return
                }
                
                observer.onNext(value)
            }
            
            return Disposables.create()
        }
    }
    
    func readObject(path: String) -> Observable<Void> {
        let reference = reference.child(path)
        
        return Observable<Void>.create { observer in
            reference.getData { error, snapshot in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                guard let snapshot = snapshot, !(snapshot.value is NSNull) else {
                    observer.onError(FirebaseError.emptyResult)
                    return
                }
                
                observer.onNext(())
            }
            
            return Disposables.create()
        }
    }
    
    func deleteObject(path: String) -> Observable<Void> {
        let reference = reference.child(path)
        
        return Observable<Void>.create { observer in
            reference.removeValue { error, _ in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                observer.onNext(())
            }
            
            return Disposables.create()
        }
    }
    
    func createObject(_ dictionary: [String: Any], path: String) -> Observable<Void> {
        let reference = reference.child(path)
        
        return Observable<Void>.create { observer in
            reference.setValue(dictionary) { error, _ in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                observer.onNext(())
            }
            
            return Disposables.create()
        }
    }
    
    func updateObject(_ dictionary: [String: Any], path: String) -> Observable<Void> {
        let reference = reference.child(path)

        return Observable<Void>.create { observer in
            reference.updateChildValues(dictionary) { error, _ in
                if let error = error {
                    observer.onError(error)
                    return
                }

                observer.onNext(())
            }
            
            return Disposables.create()
        }
    }
    
    func updateObjects(_ dictionarys: [[String: Any]], paths: [String]) -> Observable<Void> {
        let reference = self.reference
        
        var newDictionary = [String: Any]()
        for index in 0..<paths.count {
            newDictionary[paths[index]] = dictionarys[index]
        }
        
        return Observable<Void>.create { observer in
            reference.updateChildValues(newDictionary) { error, _ in
                if let error = error {
                    observer.onError(error)
                    return
                }

                observer.onNext(())
            }
            
            return Disposables.create()
        }
    }
    
    // Firebase String 줄바꿈 처리
    static func decode<T>(_ type: T.Type, from data: Data) throws -> T  where T: Decodable {
        var jsonObject = try JSONSerialization.jsonObject(with: data)
        
        if type.self is AnyArray.Type {
            guard let dictionaryList = jsonObject as? [[String: Any]] else { throw FirebaseError.failedCastToDictionary }
            
            var objectList = [[String: Any]]()
            
            for dictionary in dictionaryList {
                var object = [String: Any]()
                
                for element in dictionary {
                    if element.value is String, let value = element.value as? String {
                        object[element.key] = value.replacingOccurrences(of: "\\n", with: "\n")
                    } else {
                        object[element.key] = element.value
                    }
                }
                
                objectList.append(object)
            }
            
            jsonObject = objectList
            
        } else {
            guard let dictionary = jsonObject as? [String: Any] else { throw FirebaseError.failedCastToDictionary }
            
            var object = [String: Any]()
            
            for element in dictionary {
                if element.value is String, let value = element.value as? String {
                    object[element.key] = value.replacingOccurrences(of: "\\n", with: "\n")
                } else {
                    object[element.key] = element.value
                }
            }
            
            jsonObject = object
        }
        
        
        let data = try JSONSerialization.data(withJSONObject: jsonObject)
        return try JSONDecoder().decode(type, from: data)
    }
}
