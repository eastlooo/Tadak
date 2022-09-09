//
//  AnyArray.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/09.
//

import Foundation

protocol AnyArray {}

extension Array: AnyArray {}
extension NSArray: AnyArray {}
