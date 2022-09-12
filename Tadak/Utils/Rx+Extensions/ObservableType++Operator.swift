//
//  ObservableType++Operator.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/12.
//

import Foundation
import RxSwift

public extension ObservableType where Element: AnyResult {
    
    func mapOnSuccess<Success, T>(_ transform: @escaping(Success) throws -> T) -> Observable<Result<T, Error>> where Element == Result<Success, Error> {
        return self.map { result -> Result<T, Error> in
            switch result {
            case .success(let value):
                return .success(try transform(value))
                
            case .failure(let error):
                return .failure(error)
            }
        }
    }
    
    func flatMapOnSuccess<Success, T>(_ transform: @escaping(Success) throws -> Observable<Result<T, Error>>)  -> Observable<Result<T, Error>> where Element == Result<Success, Error> {
        return self.flatMap { result -> Observable<Result<T, Error>> in
            switch result {
            case .success(let value):
                return try transform(value)
                
            case .failure(let error):
                return .just(.failure(error))
            }
        }
    }
    
    func doOnSuccess<Success>(_ onSuccess: @escaping(Success) throws -> Void) -> Observable<Result<Success, Error>> where Element == Result<Success, Error> {
        return self.do { result in
            if case let .success(value) = result {
                try onSuccess(value)
            }
        }
    }
    
    
    func doAnotherOnSuccess<Success, A>(_ observable: @escaping(Success) throws -> Observable<A>) -> Observable<Result<Success, Error>> where Element == Result<Success, Error> {
        return self.flatMap { result -> Observable<Result<Success, Error>> in
            switch result {
            case .success(let value):
                return try observable(value)
                    .map { _ -> Result<Success, Error> in
                        return .success(value)
                    }
                
            case .failure(let error):
                return .just(.failure(error))
            }
        }
    }
    
    func doOnFailure<T>(_ onFailure: @escaping() throws -> Void) -> Observable<Result<T, Error>> where Element == Result<T, Error> {
        return self.do { result in
            if case .failure = result {
                try onFailure()
            }
        }
    }
    
    func doAnotherOnFailure<T, A>(_ observable: @escaping() throws -> Observable<A>) rethrows -> Observable<Result<T, Error>> where Element == Result<T, Error> {
        return self.flatMap { result -> Observable<Result<T, Error>> in
            switch result {
            case .success(let value):
                return .just(.success(value))
                
            case .failure(let error):
                return try observable()
                    .map { _ -> Result<T, Error> in
                        return .failure(error)
                    }
            }
        }
    }
    
    func justReturnOnFailure<E> (_ element: E) -> Observable<E> where Element == Result<E, Error> {
        return self.flatMap { result -> Observable<E> in
            switch result {
            case .success(let value): return .just(value)
            case .failure: return .just(element)
            }
        }
    }
}

public protocol AnyResult {}
extension Result: AnyResult {}
