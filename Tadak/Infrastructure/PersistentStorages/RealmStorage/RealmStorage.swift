//
//  RealmStorage.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/10.
//

import Foundation
import RxSwift
import RealmSwift

final class RealmStorage {
    
    var realm: Realm?
    
    required init(
        configuration: RealmConfigurationType = .basic(url: nil)
    ) throws {
        var realmConfiguration = Realm.Configuration()
        realmConfiguration.readOnly = true
        
        switch configuration {
        case .basic:
            realmConfiguration = Realm.Configuration.defaultConfiguration
            if let url = configuration.associated {
                realmConfiguration.fileURL = NSURL(string: url) as URL?
            }
            
        case .inMemory:
            realmConfiguration = Realm.Configuration()
            if let identifier = configuration.associated {
                realmConfiguration.inMemoryIdentifier = identifier
            } else {
                throw RealmError.emptyInMemoryIdentifier
            }
        }
        
        try self.realm = Realm(configuration: realmConfiguration)
    }
    
    private func safeWrite(_ block: (() throws -> Void)) throws {
        guard let realm = realm else { throw RealmError.failedInitialization }
        
        if realm.isInWriteTransaction {
            try block()
        } else {
            try realm.write(block)
        }
    }
}

extension RealmStorage: Storage {
    func create<T>(_ model: T.Type) -> Observable<T> where T : Storable {
        guard let realm = self.realm else {
            return .error(RealmError.failedInitialization)
        }
        
        return Observable.create { [weak self] observer in
            do {
                try self?.safeWrite {
                    let newObject = realm.create(model as! Object.Type, value: [], update: .error) as! T
                    observer.onNext(newObject)
                }
            } catch {
                observer.onError(RealmError.failedSafeWriting)
            }
            
            return Disposables.create()
        }
    }
    
    func save(object: Storable) -> Observable<Void> {
        guard let realm = self.realm else {
            return .error(RealmError.failedInitialization)
        }
        
        return .create { [weak self] observer in
            do {
                try self?.safeWrite {
                    realm.add(object as! Object)
                    observer.onNext(())
                }
            } catch {
                observer.onError(RealmError.failedSafeWriting)
            }
            
            return Disposables.create()
        }
    }
    
    func update(block: @escaping () -> Void) -> Observable<Void> {
        return .create { [weak self] observer in
            do {
                try self?.safeWrite {
                    block()
                    observer.onNext(())
                }
            } catch {
                observer.onError(RealmError.failedSafeWriting)
            }
            
            return Disposables.create()
        }
    }
    
    func delete(object: Storable) -> Observable<Void> {
        guard let realm = self.realm else {
            return .error(RealmError.failedInitialization)
        }
        
        return .create { [weak self] observer in
            do {
                try self?.safeWrite {
                    realm.delete(object as! Object)
                    observer.onNext(())
                }
            } catch {
                observer.onError(RealmError.failedSafeWriting)
            }
            
            return Disposables.create()
        }
    }
    
    func deleteAll<T>(_ model: T.Type) -> Observable<Void> where T : Storable {
        guard let realm = self.realm else {
            return .error(RealmError.failedInitialization)
        }
        
        return .create { [weak self] observer in
            do {
                try self?.safeWrite {
                    let objects = realm.objects(model as! Object.Type)
                    
                    for object in objects {
                        realm.delete(object)
                    }
                    
                    observer.onNext(())
                }
            } catch {
                observer.onError(RealmError.failedSafeWriting)
            }
            
            return Disposables.create()
        }
    }
        
    func reset() -> Observable<Void> {
        guard let realm = self.realm else {
            return .error(RealmError.failedInitialization)
        }
        
        return .create { [weak self] observer in
            do {
                try self?.safeWrite {
                    realm.deleteAll()
                    
                    observer.onNext(())
                }
            } catch {
                observer.onError(RealmError.failedSafeWriting)
            }
            
            return Disposables.create()
        }
    }
    
    func fetch<T>(_ model: T.Type, predicate: NSPredicate?, sorted: Sorted?) -> Observable<[T]> where T : Storable {
        var objects = self.realm?.objects(model as! Object.Type)
        
        if let predicate = predicate {
            objects = objects?.filter(predicate)
        }
        
        if let sorted = sorted {
            objects = objects?.sorted(byKeyPath: sorted.key, ascending: sorted.ascending)
        }
        
        var accumulate = [T]()
        for object in objects! {
            accumulate.append(object as! T)
        }
        
        return .just(accumulate)
    }
}
