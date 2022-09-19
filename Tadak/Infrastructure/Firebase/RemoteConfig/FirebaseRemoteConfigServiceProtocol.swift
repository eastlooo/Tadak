//
//  FirebaseRemoteConfigServiceProtocol.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/19.
//

import Foundation
import RxSwift

protocol FirebaseRemoteConfigServiceProtocol {
    
    func fetchRemoteConfig<T: Decodable>(_ key: String, type: T.Type) -> Observable<T>
    func fetchRemoteConfig<T: Decodable>(_ models: [String: T.Type]) -> Observable<[String: T]>
}
