//
//  UIImage++.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/05.
//

import UIKit.UIImage

extension UIImage {
    static func character(_ number: Int) -> UIImage? {
        switch number {
        case 1: return UIImage(named: "axolotl.png")
        case 2: return UIImage(named: "bear.png")
        case 3: return UIImage(named: "chameleon.png")
        case 4: return UIImage(named: "chick.png")
        case 5: return UIImage(named: "deer.png")
        case 6: return UIImage(named: "dinosaur.png")
        case 7: return UIImage(named: "dog.png")
        case 8: return UIImage(named: "frog.png")
        case 9: return UIImage(named: "giraffe.png")
        case 10: return UIImage(named: "hedgehog.png")
        case 11: return UIImage(named: "lion.png")
        case 12: return UIImage(named: "llama.png")
        case 13: return UIImage(named: "mouse.png")
        case 14: return UIImage(named: "octopus.png")
        case 15: return UIImage(named: "prawn.png")
        case 16: return UIImage(named: "rabbit.png")
        case 17: return UIImage(named: "raccoon.png")
        case 18: return UIImage(named: "sheep.png")
        case 19: return UIImage(named: "tiger.png")
        case 20: return UIImage(named: "turtle.png")
        default: return nil
        }
    }
}
