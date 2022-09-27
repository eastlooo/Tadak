//
//  Character.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/27.
//

import Foundation

enum AnimalCharacter: Int {
    
    case axolotl = 1
    case bear
    case chameleon
    case chick
    case deer
    case dinosaur
    case dog
    case frog
    case giraffe
    case hedgehog
    case lion
    case llama
    case mouse
    case octopus
    case prawn
    case rabbit
    case raccoon
    case sheep
    case tiger
    case turtle
    
    var name: String {
        switch self {
        case .axolotl: return "axolotl"
        case .bear: return "bear"
        case .chameleon: return "chameleon"
        case .chick: return "chick"
        case .deer: return "deer"
        case .dinosaur: return "dinosaur"
        case .dog: return "dog"
        case .frog: return "frog"
        case .giraffe: return "giraffe"
        case .hedgehog: return "hedgehog"
        case .lion: return "lion"
        case .llama: return "llama"
        case .mouse: return "mouse"
        case .octopus: return "octopus"
        case .prawn: return "prawn"
        case .rabbit: return "rabbit"
        case .raccoon: return "raccoon"
        case .sheep: return "sheep"
        case .tiger: return "tiger"
        case .turtle: return "turtle"
        }
    }
}
