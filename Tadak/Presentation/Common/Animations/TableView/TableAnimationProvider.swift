//
//  TableAnimationProvider.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/30.
//

import UIKit

enum TableAnimationProvider {
    
    static func makeFadeAnimation(duration: TimeInterval,
                                  delay: TimeInterval) -> TableCellAnimation {
        return { _, cell, indexPath in
            cell.alpha = 0
            
            UIView.animate(withDuration: duration,
                           delay: delay * Double(indexPath.row),
                           options: [.curveEaseInOut]) {
                cell.alpha = 1
            }
        }
    }
    
    static func makeMoveUpWithFadeAnimation(rowHeight: CGFloat,
                                            duration: TimeInterval,
                                            delay: TimeInterval) -> TableCellAnimation {
        return { _, cell, indexPath in
            cell.transform = CGAffineTransform(translationX: 0, y: rowHeight * 1.4)
            cell.alpha = 0
            
            UIView.animate(withDuration: duration,
                           delay: delay * Double(indexPath.row),
                           options: [.curveEaseInOut]) {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
                cell.alpha = 1
            }
        }
    }
}
