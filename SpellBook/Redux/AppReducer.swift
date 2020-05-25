//
//  AppReducer.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 25.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import Combine

typealias Reducer<State, Action, Environment> = (inout State, Action, Environment) -> AnyPublisher<Action, Never>?

func appReducer(state: inout AppState, action: AppAction, environment: ServiceContainer) -> AnyPublisher<AppAction, Never> {
    switch action {
    case .requestSpellList:
        return environment
            .spellListPublisher()
            .map { AppAction.showSpellList(spells: $0) }
            .catch { Just(AppAction.showError(error: $0)) }
            .eraseToAnyPublisher()
    case .requestFavorites:
        return environment
            .favoritesPublisher()
            .map { AppAction.showFavorites(spells: $0) }
            .catch { Just(AppAction.showError(error: $0)) }
            .eraseToAnyPublisher()
    case let .requestSpell(path):
        return environment
            .spellDetailsPublisher(for: path)
            .map { AppAction.showSpell(spell: $0) }
            .catch { Just(AppAction.showError(error: $0)) }
            .eraseToAnyPublisher()
    case let .search(query):
        state.refinedSpellList = environment.refinementsService.filteredSpells(spells: state.spellList, by: query)
    case let .sort(sort):
        state.refinedSpellList = environment.refinementsService.sortedSpells(spells: state.spellList, sort: sort)
    case let .showSpellList(spells):
        state.spellList = spells
    case let .showFavorites(spells):
        state.favorites = spells
    case let .showSpell(spell):
        state.selectedSpell = spell
    case let .showError(error):
        state.error = error
    }

    return Empty().eraseToAnyPublisher()
}

