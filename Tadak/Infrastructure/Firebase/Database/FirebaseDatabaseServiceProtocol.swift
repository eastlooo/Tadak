//
//  FirebaseDatabaseServiceProtocol.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/18.
//

import Foundation
import RxSwift

protocol FirebaseDatabaseServiceProtocol {
    
    func request<R: Decodable, E: RequestResponsable>(with endpoint: E) -> Observable<R> where E.Response == R
    func request<R: Decodable, E: RequestResponsable>(with endpoint: E) -> Observable<[R]> where E.Response == [R]
    func request<E>(with endpoint: E) -> Observable<Void> where E : RequestResponsable, E.Response == Void
    func request<E>(with endpoints: [E]) -> Observable<Void> where E : RequestResponsable, E.Response == Void
}
