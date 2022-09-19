//
//  FirebaseRemoteConfigService.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/12.
//

import Foundation
import FirebaseRemoteConfig
import RxSwift

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
    
    func fetchRemoteConfig<T: Decodable>(_ key: String, type: T.Type) -> Observable<T> {
        return fetchRemoteConfig([key: type])
            .flatMap { dictionary -> Observable<T> in
                guard let value = dictionary[key] else {
                    return .error(FirebaseError.decodeError)
                }
                return .just(value)
            }
    }
    
    func fetchRemoteConfig<T: Decodable>(_ models: [String: T.Type]) -> Observable<[String: T]> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            
            self.remoteConfig.fetch { status, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                guard status == .success else {
                    observer.onError(FirebaseError.failedFetchRemoteConfig)
                    return
                }
                
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
                        observer.onError(FirebaseError.decodeError)
                        return
                    }
                    
                    dictionary[key] = value
                }
                
                observer.onNext(dictionary)
            }
            
            return Disposables.create()
        }
    }
}
