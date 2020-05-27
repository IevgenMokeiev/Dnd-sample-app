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
    case .requestSpellList:
        return (nil, environment.spellProviderService
            .spellListPublisher()
            .map { AppAction.showSpellList($0) }
            .catch { Just(AppAction.showSpellListLoadError($0)) }
            .eraseToAnyPublisher())
    case .requestFavorites:
        return (nil, environment.spellProviderService
            .favoritesPublisher()
            .map { AppAction.showFavorites($0) }
            .catch { _ in Just(AppAction.showFavorites([])) }
            .eraseToAnyPublisher())
    case let .requestSpell(path):
        return (nil, environment.spellProviderService
            .spellDetailsPublisher(for: path)
            .map { AppAction.showSpell($0) }
            .catch { Just(AppAction.showSpellLoadError($0)) }
            .eraseToAnyPublisher())
    case let .search(query):
        guard case let .spellList(_, allSpells) = state.spellListState else { break }

        let refinedSpells = environment.refinementsService.filteredSpells(spells: allSpells, by: query)
        let spellListState: SpellListState = .spellList(displayedSpells: refinedSpells, allSpells: allSpells)

        return (AppState(spellListState: spellListState, spellDetailState: state.spellDetailState, favoriteSpells: state.favoriteSpells), nil)
    case let .sort(sort):
        guard case let .spellList(_, allSpells) = state.spellListState else { break }

        let refinedSpells = environment.refinementsService.sortedSpells(spells: allSpells, sort: sort)
        let spellListState: SpellListState = .spellList(displayedSpells: refinedSpells, allSpells: allSpells)

        return (AppState(spellListState: spellListState, spellDetailState: state.spellDetailState, favoriteSpells: state.favoriteSpells), nil)
    case .toggleFavorite:
        guard case let .selectedSpell(spell) = state.spellDetailState else { break }

        let newSpell = spell.toggleFavorite(value: !spell.isFavorite)
        environment.spellProviderService.saveSpellDetails(newSpell)
        let spellDetailState: SpellDetailState = .selectedSpell(newSpell)

        return (AppState(spellListState: state.spellListState, spellDetailState: spellDetailState, favoriteSpells: state.favoriteSpells), nil)
    case let .showSpellList(spells):
        let sortedSpells = environment.refinementsService.sortedSpells(spells: spells, sort: .name)
        let spellListState: SpellListState = .spellList(displayedSpells: sortedSpells, allSpells: sortedSpells)

        return (AppState(spellListState: spellListState, spellDetailState: state.spellDetailState, favoriteSpells: state.favoriteSpells), nil)
    case let .showFavorites(spells):
        return (AppState(spellListState: state.spellListState, spellDetailState: state.spellDetailState, favoriteSpells: spells), nil)
    case let .showSpell(spell):
        return (AppState(spellListState: state.spellListState, spellDetailState: .selectedSpell(spell), favoriteSpells: state.favoriteSpells), nil)
    case let .showSpellListLoadError(error):
        return (AppState(spellListState: .error(error), spellDetailState: state.spellDetailState, favoriteSpells: state.favoriteSpells), nil)
    case let .showSpellLoadError(error):
        return (AppState(spellListState: state.spellListState, spellDetailState: .error(error), favoriteSpells: state.favoriteSpells), nil)
    }

    return (nil, nil)
}

