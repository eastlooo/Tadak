//
//  TypingAttributes.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/14.
//

import Foundation

struct TypingAttributes {
    
    let width: CGFloat
    let attributes: [NSAttributedString.Key: Any]
}

extension TypingAttributes {
    
    func seperateContents(_ contents: String) -> [String] {
        let maxWidth = self.width
        
        return contents.replacingOccurrences(of: "\n\n", with: "\n")
            .split(separator: "\n")
            .map(String.init)
            .flatMap { element -> [String] in
                var string = element
                var array = [String]()
                
                while true {
                    let width = NSAttributedString(string: string, attributes: attributes).size().width
                    guard width > maxWidth, !string.isEmpty else {
                        array.append(string)
                        break
                    }
                    
                    for index in 0..<string.count {
                        let lastIndex = string.index(string.startIndex, offsetBy: index)
                        let fragment = String(string[...lastIndex])
                        let fragmentWidth = NSAttributedString(string: fragment, attributes: attributes).size().width
                        
                        guard fragmentWidth > maxWidth else { continue }
                        
                        array.append(String(string[..<lastIndex]))
                        string = String(string[lastIndex...])
                        break
                    }
                }
                
                array = array.map { $0.trimmingCharacters(in: .whitespaces) }
                return array
            }
    }
}
