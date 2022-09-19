//
//  ObservableType++Operator.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/12.
//

import Foundation
import RxSwift

public extension ObservableType {
    
    func debugError<E>() -> Observable<E> where E == Element {
        return self.catch { error -> Observable<E> in
            print("ERROR: \(error)")
            return .error(error)
        }
    }
}
