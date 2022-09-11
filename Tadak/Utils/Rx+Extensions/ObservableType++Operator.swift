//
//  ObservableType++Operator.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/12.
//

import Foundation
import RxSwift

public extension ObservableType where Element: AnyResult {
    
    func mapSuccessCase<Success, T>(_ transform: @escaping(Success) throws -> T) rethrows -> Observable<Result<T, Error>> where Element == Result<Success, Error> {
        return self.map { result -> Result<T, Error> in
            switch result {
            case .success(let value):
                return .success(try transform(value))
                
            case .failure(let error):
                return .failure(error)
            }
        }
    }
    
    func flatMapSuccessCase<Success, T>(_ transform: @escaping(Success) throws -> Observable<Result<T, Error>>) rethrows -> Observable<Result<T, Error>> where Element == Result<Success, Error> {
        return self.flatMap { result -> Observable<Result<T, Error>> in
            switch result {
            case .success(let value):
                return try transform(value)
                
            case .failure(let error):
                return .just(.failure(error))
            }
        }
    }
    
    func doFailureCase<T>(_ transform: @escaping() throws -> Observable<Result<T, Error>>) rethrows -> Observable<Result<T, Error>> where Element == Result<T, Error> {
        return self.flatMap { result -> Observable<Result<T, Error>> in
            switch result {
            case .success(let value):
                return .just(.success(value))
                
            case .failure(let error):
                return try transform()
                    .map { _ -> Result<T, Error> in
                        return .failure(error)
                    }
            }
        }
    }
}

public protocol AnyResult {}
extension Result: AnyResult {}
