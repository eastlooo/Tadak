//
//  OnboardingNicknameViewReactor.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/08.
//

import Foundation
import ReactorKit
import RxFlow
import RxRelay

final class OnboardingNicknameViewReactor: Reactor, Stepper {
    
    enum Action {
        case characterButtonTapped(Void)
        case nicknameText(String)
        case registerButtonTapped(Void)
    }
    
    enum Mutation {
        case correctText(String)
        case validateText(Bool)
        case checkNicknameDuplication(Result<Bool, Error>)
        case register(Result<Void, Error>)
    }
    
    struct State {
        let characterID: Int
        var validate: Bool = false
        var correctedText: String = ""
    }
    
    var steps = PublishRelay<Step>()
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
            steps.accept(OnboardingStep.onboardingCharacterReselected)
            return .empty()
            
        case .nicknameText(let text):
            let correctedText = useCase.correctText(text)
            let validation = useCase.checkValidate(correctedText)
            return .of(
                .correctText(correctedText),
                .validateText(validation)
            )
             
        case .registerButtonTapped:
            return useCase.checkNicknameDuplication().map(Mutation.checkNicknameDuplication)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .correctText(let text):
            state.correctedText = text
            
        case .validateText(let validation):
            state.validate = validation
            
        case .checkNicknameDuplication(let result):
            print("DEBUG: result \(result)")
            
        default:
            break
        }
        
        return state
    }
}
