//
//  AppReducer.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 25.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import Combine

struct ReducerResult<State, Action> {
    let state: State?
    let effect: AnyPublisher<Action, Never>?

    init(state: State? = nil, effect: AnyPublisher<Action, Never>? = nil) {
        self.state = state
        self.effect = effect
    }
}

typealias Reducer<State, Action, Environment> = (State, Action, Environment) -> ReducerResult<State, Action>

func appReducer(state: AppState, action: AppAction, environment: ServiceContainer) -> ReducerResult<AppState, AppAction> {
    switch action {
    case let .spellList(action):
        let result = spellListReducer(state: state.spellListState, action: action, environment: environment)
        return mapReducerResult(result, stateMap: { AppState(spellListState: $0, spellDetailState: state.spellDetailState, favoritesState: state.favoritesState)
        }) { AppAction.spellList($0) }
    case let .spellDetail(action):
        let result = spellDetailReducer(state: state.spellDetailState, action: action, environment: environment)
        return mapReducerResult(result, stateMap: { AppState(spellListState: state.spellListState, spellDetailState: $0, favoritesState: state.favoritesState)
        }) { AppAction.spellDetail($0) }
    case let .favorites(action):
        let result = favoritesReducer(state: state.favoritesState, action: action, environment: environment)
        return mapReducerResult(result, stateMap: { AppState(spellListState: state.spellListState, spellDetailState: state.spellDetailState, favoritesState: $0)
        }) { AppAction.favorites($0) }
    case .toggleFavorite:
        guard case let .selectedSpell(spell) = state.spellDetailState else { return ReducerResult() }
        let newSpell = spell.toggleFavorite(value: !spell.isFavorite)
        environment.spellProviderService.saveSpellDetails(newSpell)
        return ReducerResult(state: AppState(spellListState: state.spellListState, spellDetailState: .selectedSpell(newSpell), favoritesState: state.favoritesState), effect: Just(AppAction.favorites(.requestFavorites)).eraseToAnyPublisher())
    case let .addSpell(spell):
        environment.spellProviderService.createSpell(spell)
        return ReducerResult(state: AppState(spellListState: .initial, spellDetailState: state.spellDetailState, favoritesState: state.favoritesState), effect: Just(AppAction.spellList(.requestSpellList)).eraseToAnyPublisher())
    }
}

private func mapReducerResult<InputState, InputAction, OutputState, OutputAction>(_ result: ReducerResult<InputState, InputAction>, stateMap: (InputState) -> OutputState, actionMap: @escaping (InputAction) -> OutputAction) -> ReducerResult<OutputState, OutputAction> {

    let resultState: OutputState? = {
        if let state = result.state {
            return stateMap(state)
        } else {
            return nil
        }
    }()

    let resultEffect = result.effect?
        .map { inputAction -> OutputAction in
            actionMap(inputAction)
    }
    .eraseToAnyPublisher()

    return ReducerResult(state: resultState, effect: resultEffect)
}
