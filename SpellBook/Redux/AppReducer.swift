//
//  AppReducer.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 25.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import Combine

typealias ReducerResult<State, Action> = (state: State?, effect: AnyPublisher<Action, Never>?)
typealias Reducer<State, Action, Environment> = (State, Action, Environment) -> ReducerResult<State, Action>

func appReducer(state: AppState, action: AppAction, environment: ServiceContainer) -> (state: AppState?, effect: AnyPublisher<AppAction, Never>?) {

    switch action {
    case let .spellList(action):
        let output = spellListReducer(state: state.spellListState, action: action, environment: environment)
        return mapReducerOutput(output: output, stateMapper: { AppState(spellListState: $0, spellDetailState: state.spellDetailState, favoritesState: state.favoritesState)
        }) { AppAction.spellList($0) }
    case let .spellDetail(action):
        let output = spellDetailReducer(state: state.spellDetailState, action: action, environment: environment)
        return mapReducerOutput(output: output, stateMapper: { AppState(spellListState: state.spellListState, spellDetailState: $0, favoritesState: state.favoritesState)
               }) { AppAction.spellDetail($0) }
    case let .favorites(action):
        let output = favoritesReducer(state: state.favoritesState, action: action, environment: environment)
        return mapReducerOutput(output: output, stateMapper: { AppState(spellListState: state.spellListState, spellDetailState: state.spellDetailState, favoritesState: $0)
        }) { AppAction.favorites($0) }
    }
}

func mapReducerOutput<InputState, InputAction, OutputState, OutputAction>(output: ReducerResult<InputState, InputAction>, stateMapper: (InputState) -> OutputState, actionMapper: @escaping (InputAction) -> OutputAction) -> ReducerResult<OutputState, OutputAction> {

    let resultState: OutputState? = {
        if let state = output.state {
            return stateMapper(state)
        } else {
            return nil
        }
    }()

    let resultEffect = output.effect?
        .map { inputAction -> OutputAction in
            actionMapper(inputAction)
        }
        .eraseToAnyPublisher()

    return (resultState, resultEffect)
}
