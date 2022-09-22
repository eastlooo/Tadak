//
//  Hangul.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/16.
//

import Foundation

struct Hangul {
    
    private static var hangulSet: CharacterSet {
        CharacterSet(
            charactersIn: ("ㄱ".unicodeScalars.first!)...("ㅎ".unicodeScalars.first!)
        ).union(
            CharacterSet(
                charactersIn: ("가".unicodeScalars.first!)...("힣".unicodeScalars.first!)
            )
        )
    }
    
    private static let jongsungs = [
        "", "ㄱ", "ㄲ", "ㄳ", "ㄴ", "ㄵ", "ㄶ",
        "ㄷ", "ㄹ", "ㄺ", "ㄻ", "ㄼ", "ㄽ", "ㄾ",
        "ㄿ", "ㅀ", "ㅁ", "ㅂ", "ㅄ", "ㅅ", "ㅆ",
        "ㅇ", "ㅈ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"
    ]
    
    private static let divisibleJongsung: [String: [String]] = [
        "ㄳ": ["ㄱ", "ㅅ"], "ㄵ": ["ㄴ", "ㅈ"], "ㄶ": ["ㄴ", "ㅎ"],
        "ㄺ": ["ㄹ", "ㄱ"], "ㄻ": ["ㄹ", "ㅁ"], "ㄼ": ["ㄹ", "ㅂ"],
        "ㄽ": ["ㄹ", "ㅅ"], "ㄾ": ["ㄹ", "ㅌ"], "ㄿ": ["ㄹ", "ㅍ"],
        "ㅀ": ["ㄹ", "ㅎ"], "ㅄ": ["ㅂ", "ㅅ"]
    ]
    
    static func decompose(_ char: Character) -> [String] {
        guard checkHangul(char) else { return [String(char)] }
        return char.unicodeScalars.flatMap(examineHangulScalar)
    }
}

private extension Hangul {
    
    static func checkHangul(_ char: Character) -> Bool {
        guard let scalar = char.unicodeScalars.first,
           hangulSet.contains(scalar) else {
            return false
        }
        
        return true
    }
    
    static func examineHangulScalar(_ scalar: UnicodeScalar) -> [String] {
        let value = scalar.value
        guard value >= "가".unicodeScalars.first!.value else { return ["\(scalar)"] }
        
        let chosungOrder = (value - 0xac00) / 28 / 21
        let jungsungOrder = ((value - 0xac00) / 28) % 21
        let jongsungOrder = (value - 0xac00) % 28
        
        let chosung = ["\(UnicodeScalar(0x1100 + chosungOrder)!)"]
        let jungsung = ["\(UnicodeScalar(0x1161 + jungsungOrder)!)"]
        var jongsung = [String]()
        
        if jongsungOrder > 0 {
            
            let jongString = jongsungs[Int(jongsungOrder)]
            jongsung = [jongString]
            
            divisibleJongsung[jongString].map { jongsung = $0 }
        }
        
        return chosung + jungsung + jongsung
    }
}
