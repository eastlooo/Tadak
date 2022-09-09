//
//  Result++.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/08.
//

import Foundation
import ReactorKit

extension Reactor {
    static func getValue<T: Any>(_ result: Result<T, Error>) -> T? {
        guard case .success(let value) = result else { return nil }
        return value
    }

    static func getErrorDescription<T: Any>(_ result: Result<T, Error>) -> String? {
        guard case .failure(let error) = result else { return nil }
        return error.localizedDescription
    }
}
