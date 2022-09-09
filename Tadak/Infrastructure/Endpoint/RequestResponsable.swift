//
//  RequestResponsable.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/09.
//

import Foundation
import FirebaseDatabase

protocol Requestable {
    var path: String { get }
    var crud: CRUD { get }
    var bodyParameters: Encodable? { get }
    var sampleData: Data? { get }
}

protocol Responsable {
    associatedtype Response
}

protocol RequestResponsable: Requestable, Responsable {}
