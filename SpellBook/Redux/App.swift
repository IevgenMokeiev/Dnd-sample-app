//
//  App.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 25.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Combine

typealias AppStore = Store<AppState, AppAction, ServiceContainer>

struct ServiceContainer {

}

struct AppState {
    var spellList: [SpellDTO]
    var refinedSpellList: [SpellDTO]
    var favorites: [SpellDTO]
    var selectedSpell: SpellDTO?
}

enum Sort {
    case name
    case level
}

enum AppAction {
    case showSpellList
    case showFavorites
    case showDetails(path: String)
    case search(query: String)
    case sort(by: Sort)
}

func appReducer(state: inout AppState, action: AppAction, environment: ServiceContainer) -> AnyPublisher<AppAction, Never> {
    switch action {
    case .showSpellList:
        break
    case .showFavorites:
        break
    case let .showDetails(path):
        break
    case let .search(query):
        state.refinedSpellList = state.spellList
    case let .sort(sort):
        state.refinedSpellList = state.spellList
    }

    return Empty().eraseToAnyPublisher()
}

