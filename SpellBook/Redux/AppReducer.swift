//
//  AppReducer.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 25.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import Combine

typealias Reducer<State, Action, Environment> = (inout State, Action, Environment) -> AnyPublisher<Action, Never>

func appReducer(state: inout AppState, action: AppAction, environment: ServiceContainer) -> AnyPublisher<AppAction, Never> {
    switch action {
    case .requestSpellList:
        return environment.spellProviderService
            .spellListPublisher()
            .map { AppAction.showSpellList($0) }
            .catch { Just(AppAction.showSpellListLoadError($0)) }
            .eraseToAnyPublisher()
    case .requestFavorites:
        return environment.spellProviderService
            .favoritesPublisher()
            .map { AppAction.showFavorites($0) }
            .catch { _ in Just(AppAction.showFavorites([])) }
            .eraseToAnyPublisher()
    case let .requestSpell(path):
        return environment.spellProviderService
            .spellDetailsPublisher(for: path)
            .map { AppAction.showSpell($0) }
            .catch { Just(AppAction.showSpellLoadError($0)) }
            .eraseToAnyPublisher()
    case let .search(query):
        guard case let .spellList(_, allSpells) = state.spellListState else { break }

        let refinedSpells = environment.refinementsService.filteredSpells(spells: allSpells, by: query)
        state.spellListState = .spellList(displayedSpells: refinedSpells, allSpells: allSpells)
    case let .sort(sort):
        guard case let .spellList(_, allSpells) = state.spellListState else { break }

        let refinedSpells = environment.refinementsService.sortedSpells(spells: allSpells, sort: sort)
        state.spellListState = .spellList(displayedSpells: refinedSpells, allSpells: allSpells)
    case .toggleFavorite:
        guard case let .selectedSpell(spell) = state.spellDetailState else { break }

        let newSpell = spell.toggleFavorite(value: !spell.isFavorite)
        environment.spellProviderService.saveSpellDetails(newSpell)
        state.spellDetailState = .selectedSpell(newSpell)
    case let .showSpellList(spells):
        let sortedSpells = environment.refinementsService.sortedSpells(spells: spells, sort: .name)
        state.spellListState = .spellList(displayedSpells: sortedSpells, allSpells: sortedSpells)
    case let .showFavorites(spells):
        state.favoriteSpells = spells
    case let .showSpell(spell):
        state.spellDetailState = .selectedSpell(spell)
    case let .showSpellListLoadError(error):
        state.spellListState = .error(error)
    case let .showSpellLoadError(error):
        state.spellDetailState = .error(error)
    }

    return Empty().eraseToAnyPublisher()
}

