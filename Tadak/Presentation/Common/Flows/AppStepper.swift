//
//  AppStepper.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/08.
//

import Foundation
import RxSwift
import RxRelay
import RxFlow

final class AppStepper: Stepper {
    
    let steps = PublishRelay<Step>()
    
    private let disposeBog = DisposeBag()
    
    init() { }
}
