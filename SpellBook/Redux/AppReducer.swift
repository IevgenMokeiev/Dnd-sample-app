//
//  AppReducer.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 25.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import Combine

typealias Reducer<State, Action, Environment> = (State, Action, Environment) -> (state: State?, effect: AnyPublisher<Action, Never>?)

func appReducer(state: AppState, action: AppAction, environment: ServiceContainer) -> (state: AppState?, effect: AnyPublisher<AppAction, Never>?) {

    switch action {
    case let .spellList(action):
        let (newState, effect) = spellListReducer(state: state.spellListState, action: action, environment: environment)
        if let newState = newState {
            return (AppState(spellListState: newState, spellDetailState: state.spellDetailState, favoritesState: state.favoritesState), nil)
        } else if let effect = effect {
            return (nil, effect.map { AppAction.spellList($0) }.eraseToAnyPublisher())
        }
    case let .spellDetail(action):
        let (newState, effect) = spellDetailReducer(state: state.spellDetailState, action: action, environment: environment)
        if let newState = newState {
            return (AppState(spellListState: state.spellListState, spellDetailState: newState, favoritesState: state.favoritesState), nil)
        } else if let effect = effect {
            return (nil, effect.map { AppAction.spellDetail($0) }.eraseToAnyPublisher())
        }
    case let .favorites(action):
        let (newState, effect) = favoritesReducer(state: state.favoritesState, action: action, environment: environment)
        if let newState = newState {
            return (AppState(spellListState: state.spellListState, spellDetailState: state.spellDetailState, favoritesState: newState), nil)
        } else if let effect = effect {
            return (nil, effect.map { AppAction.favorites($0) }.eraseToAnyPublisher())
        }
    }

    return (nil, nil)
}
