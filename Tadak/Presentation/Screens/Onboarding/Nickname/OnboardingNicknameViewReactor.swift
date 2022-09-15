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
        case checkNicknameDuplication(Bool)
        case registerUser(TadakUser)
        case showLoader(Bool)
        case debugError(String)
    }
    
    struct State {
        let characterID: Int
        let nicknameMaxLength: Int
        var validate: Bool = false
        var correctedText: String = ""
        var loaderAppear: Bool?
        var nicknameIsDuplicated: Bool?
    }
    
    var steps = PublishRelay<Step>()
    let initialState: State
    private let useCase: OnboardingNicknameUseCaseProtocol
    
    init(useCase: OnboardingNicknameUseCaseProtocol) {
        self.useCase = useCase
        self.initialState = State(
            characterID: useCase.characterID,
            nicknameMaxLength: useCase.maxLength
        )
    }
}

extension OnboardingNicknameViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .characterButtonTapped:
            steps.accept(TadakStep.onboardingCharacterReselected)
            return .empty()
            
        case .nicknameText(let text):
            let correctedText = useCase.correctText(text)
            let validation = useCase.checkValidate(correctedText)
            return .of(
                .correctText(correctedText),
                .validateText(validation)
            )
             
        case .registerButtonTapped:
            return Observable.concat([
                .just(.showLoader(true)),
                self.flowWithregisterButtonTapped()
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .correctText(let text):
            state.correctedText = text
            
        case .validateText(let validation):
            state.validate = validation
            
        case .checkNicknameDuplication(let duplication):
            if duplication {
                steps.accept(TadakStep.nicknameDuplicated)
            }
            
        case .showLoader(let appear):
            state.loaderAppear = appear
            
        case .debugError(let description):
            print("ERROR: \(description)")
            
        case .registerUser:
            steps.accept(TadakStep.onboardingIsComplete)
        }
        
        return state
    }
}

private extension OnboardingNicknameViewReactor {
    func flowWithregisterButtonTapped() -> Observable<Mutation> {
        let checkNicknameDuplication = useCase.checkNicknameDuplication().share()
        let registerUser = checkNicknameDuplication.compactMap(Self.getValue).filter { !$0 }
            .map { _ in }.flatMap(useCase.startOnboardingFlow).share()
        
        return Observable.merge(
            checkNicknameDuplication.compactMap(Self.getValue).filter { $0 }.flatMap { _ in
                Observable.of(.showLoader(false), .checkNicknameDuplication(true))
            },
            checkNicknameDuplication.compactMap(Self.getErrorDescription).flatMap { description in
                Observable.of(.showLoader(false), .debugError(description))
            },
            registerUser.compactMap(Self.getErrorDescription).flatMap { description in
                Observable.of(.showLoader(false), .debugError(description))
            },
            registerUser.compactMap(Self.getValue).flatMap { user in
                Observable.of(.showLoader(false), .registerUser(user))
            }
        )
    }
}
