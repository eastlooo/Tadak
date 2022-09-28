//
//  TypingDetail.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/13.
//

struct TypingDetail {
    
    let typingMode: TypingMode
    let composition: any Composition
    var names: [String]
    
    init(
        typingMode: TypingMode,
        composition: any Composition
    ) {
        self.typingMode = typingMode
        self.composition = composition
        self.names = []
    }
    
    init(
        typingMode: TypingMode,
        composition: any Composition,
        names: [String]
    ) {
        self.typingMode = typingMode
        self.composition = composition
        self.names = names
    }
    
    func setParticipants(_ names: [String]) -> TypingDetail {
        return TypingDetail(
            typingMode: typingMode,
            composition: composition,
            names: names
        )
    }
}
