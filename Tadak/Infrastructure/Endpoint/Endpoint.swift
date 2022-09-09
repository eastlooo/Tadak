//
//  Endpoint.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/09.
//

import Foundation

final class Endpoint<R>: RequestResponsable {
    
    typealias Response = R
    
    var path: String
    var crud: CRUD
    var bodyParameters: Encodable?
    var sampleData: Data?
    
    init(
        path: String,
        crud: CRUD,
        bodyParameters: Encodable? = nil,
        sampleData: Data? = nil
    ) {
        self.path = path
        self.crud = crud
        self.bodyParameters = bodyParameters
        self.sampleData = sampleData
    }
}

enum CRUD {
    case create, read, update, delete
}
