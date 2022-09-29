//
//  TableAnimation.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/30.
//

import UIKit

enum TableAnimation {
    
    case fadeIn(duration: TimeInterval, delay: TimeInterval)
    case moveUpWithFade(rowHeight: CGFloat, duration: TimeInterval, delay: TimeInterval)
    
    func getAnimation() -> TableCellAnimation {
        switch self {
        case .fadeIn(let duration, let delay):
            return TableAnimationProvider.makeFadeAnimation(
                duration: duration,
                delay: delay
            )
            
        case .moveUpWithFade(let rowHeight, let duration, let delay):
            return TableAnimationProvider.makeMoveUpWithFadeAnimation(
                rowHeight: rowHeight,
                duration: duration,
                delay: delay
            )
        }
    }
}
