//
//  MakeCompositionViewReactor.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/24.
//

import Foundation
import ReactorKit
import RxFlow
import RxRelay

final class MakeCompositionViewReactor: Reactor, Stepper {
    
    enum Action {
        case listButtonTapped(Void)
        case saveButtonTapped(Void)
        case titleText(String)
        case artistText(String)
        case contentsText(String)
    }
    
    enum Mutation {
        case setValidate(Bool)
    }
    
    struct State {
        @Pulse var isValidate: Bool = false
    }
    
    private let disposeBag = DisposeBag()
    var steps = PublishRelay<Step>()
    
    let initialState: State
    
    init() {
        self.initialState = State()
    }
    
    deinit { print("DEBUG: \(type(of: self)) \(#function)") }
}

extension MakeCompositionViewReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .listButtonTapped:
            steps.accept(TadakStep.makeCompositionIsComplete)
            return .empty()
            
        case .saveButtonTapped:
            return .empty()
            
        case .titleText(let title):
            _ = title
            return .empty()
            
        case .artistText(let artist):
            _ = artist
            return .empty()
            
        case .contentsText(let contents):
            _ = contents
            return .empty()
        }
    }
}
