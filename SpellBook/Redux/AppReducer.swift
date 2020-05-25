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
        return environment.spellProviderService
            .spellListPublisher()
            .map { AppAction.showSpellList(spells: $0) }
            .catch { Just(AppAction.showError(error: $0)) }
            .eraseToAnyPublisher()
    case .requestFavorites:
        return environment.spellProviderService
            .favoritesPublisher()
            .map { AppAction.showFavorites(spells: $0) }
            .catch { Just(AppAction.showError(error: $0)) }
            .eraseToAnyPublisher()
    case let .requestSpell(path):
        return environment.spellProviderService
            .spellDetailsPublisher(for: path)
            .map { AppAction.showSpell(spell: $0) }
            .catch { Just(AppAction.showError(error: $0)) }
            .eraseToAnyPublisher()
    case let .search(query):
        state.displayedSpells = environment.refinementsService.filteredSpells(spells: state.allSpells, by: query)
    case let .sort(sort):
        state.displayedSpells = environment.refinementsService.sortedSpells(spells: state.allSpells, sort: sort)
    case .toggleFavorite:
        guard let spellDTO = state.selectedSpell else { break }
        let newSpellDTO = spellDTO.toggleFavorite(value: !spellDTO.isFavorite)
        environment.spellProviderService.saveSpellDetails(newSpellDTO)
        state.selectedSpell = newSpellDTO
    case let .showSpellList(spells):
        let sortedSpells = environment.refinementsService.sortedSpells(spells: spells, sort: .name)
        state.allSpells = sortedSpells
        state.displayedSpells = sortedSpells
    case let .showFavorites(spells):
        state.favoriteSpells = spells
    case let .showSpell(spell):
        state.selectedSpell = spell
    case let .showError(error):
        state.error = error
    }

    return Empty().eraseToAnyPublisher()
}

