//
//  UIFont++.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/06.
//

import UIKit

extension UIFont {
    enum Family: String {
        case black, bold, medium, regular, light, thin
    }
    
    static func notoSansKR(ofSize size: CGFloat, weight family: Family = .regular) -> UIFont? {
        var familyValue = family.rawValue
        familyValue = familyValue.removeFirst().uppercased() + familyValue
        return UIFont(name: "NotoSansKR-\(familyValue)", size: size)
    }
}
