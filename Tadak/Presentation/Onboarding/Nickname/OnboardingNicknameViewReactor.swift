//
//  OnboardingNicknameViewReactor.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/08.
//

import Foundation
import ReactorKit

final class OnboardingNicknameViewReactor: Reactor {
    
    enum Action {
        case characterButtonTapped(Void)
        case nicknameText(String)
        case registerButtonTapped(Void)
    }
    
    enum Mutation {
        case popToRootView
        case correctText(String)
        case validateText(Bool)
        case register(Result<Void, Error>)
    }
    
    struct State {
        let characterID: Int
        var viewShouldPopToRootView: Bool = false
        var validate: Bool = false
        var correctedText: String = ""
    }
    
    let initialState: State
    private let useCase: OnboardingNicknameUseCaseProtocol
    
    init(useCase: OnboardingNicknameUseCaseProtocol) {
        self.useCase = useCase
        self.initialState = State(characterID: useCase.characterID)
    }
}

extension OnboardingNicknameViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .characterButtonTapped:
            return .just(.popToRootView)
            
        case .nicknameText(let text):
            let correctedText = useCase.correctText(text)
            let validation = useCase.checkValidate(correctedText)
            return .of(
                .correctText(correctedText),
                .validateText(validation)
            )
             
        case .registerButtonTapped:
            return useCase.register().map(Mutation.register)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .popToRootView:
            state.viewShouldPopToRootView = true
            
        case .correctText(let text):
            state.correctedText = text
            
        case .validateText(let validation):
            state.validate = validation
            
        case .register(let result):
            print("DEBUG: result \(result)")
        }
        
        return state
    }
}
