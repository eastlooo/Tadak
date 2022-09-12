//
//  FirebaseRemoteConfigService.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/12.
//

import Foundation
import FirebaseRemoteConfig
import RxSwift

protocol FirebaseRemoteConfigServiceProtocol {
    
    func fetchRemoteConfig<T: Decodable>(_ key: String, type: T.Type) -> Observable<Result<T, Error>>
    func fetchRemoteConfig<T: Decodable>(_ models: [String: T.Type]) -> Observable<Result<[String: T], Error>>
}

final class FirebaseRemoteConfigService {
    
    private let remoteConfig: RemoteConfig
    
    init(remoteConfig: RemoteConfig = RemoteConfig.remoteConfig()) {
        self.remoteConfig = remoteConfig
        
        // Remote Config Fetch Interval
        #if DEBUG
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        #endif
        
        remoteConfig.setDefaults(fromPlist: "RemoteConfigValue")
    }
}

extension FirebaseRemoteConfigService: FirebaseRemoteConfigServiceProtocol {
    
    func fetchRemoteConfig<T: Decodable>(_ key: String, type: T.Type) -> Observable<Result<T, Error>> {
        return fetchRemoteConfig([key: type])
            .flatMapOnSuccess { dictionary -> Observable<Result<T, Error>> in
                guard let value = dictionary[key] else {
                    return .just(.failure(FirebaseError.decodeError))
                }
                return .just(.success(value))
            }
    }
    
    func fetchRemoteConfig<T: Decodable>(_ models: [String: T.Type]) -> Observable<Result<[String: T], Error>> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            self.remoteConfig.fetch { status, error in
                if let error = error {
                    observer.onNext(.failure(error))
                    return
                }
                
                if status == .success {
                    self.remoteConfig.activate()
                    
                    var dictionary = [String: T]()
                    for model in models {
                        let key = model.key
                        let type = model.value
                        
                        var value: T?
                        if type is String.Type {
                            let stringValue = self.remoteConfig[key].stringValue
                                .map { $0.replacingOccurrences(of: "\\n", with: "\n") }
                            value = stringValue as? T
                        } else if type is Bool.Type {
                            value = self.remoteConfig[key].boolValue as? T
                        } else if type is NSNumber.Type {
                            value = self.remoteConfig[key].numberValue as? T
                        } else {
                            let data = self.remoteConfig[key].dataValue
                            value = try? JSONDecoder().decode(type, from: data)
                        }
                        
                        guard let value = value else {
                            observer.onNext(.failure(FirebaseError.decodeError))
                            return
                        }
                        
                        dictionary[key] = value
                    }
                    
                    observer.onNext(.success(dictionary))
                    
                } else {
                    observer.onNext(.failure(FirebaseError.failedFetchRemoteConfig))
                    return
                }
            }
            
            return Disposables.create()
        }
    }
}
