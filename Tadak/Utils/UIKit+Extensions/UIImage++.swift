//
//  UIImage++.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/05.
//

import UIKit.UIImage

extension UIImage {
    static func character(_ id: Int) -> UIImage? {
        let character = AnimalCharacter(rawValue: id)
        return character.flatMap { UIImage(named: "\($0.name).png") }
    }
    
    static func reward(score: Int) -> UIImage? {
        
        switch score {
        case 0..<100: return image(.clover)
        case 100..<200: return UIImage(named: "bronze-medal.png")
        case 200..<350: return UIImage(named: "silver-medal.png")
        case 350..<500: return UIImage(named: "gold-medal.png")
        case 500..<650: return UIImage(named: "gold-trophy.png")
        case 650..<800: return UIImage(named: "diamond.png")
        case 800...: return UIImage(named: "crown.png")
        default: return nil
        }
        
        func image(_ reward: Reward) -> UIImage? {
            return UIImage(named: reward.rawValue)
        }
    }
}
