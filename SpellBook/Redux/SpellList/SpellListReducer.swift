//
//  SpellListReducer.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 27.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import Combine

func spellListReducer(state: SpellListState, action: SpellListAction, environment: ServiceContainer) -> ReducerResult<SpellListState, SpellListAction> {
    switch action {
    case .requestSpellList:
        return (nil, environment.spellProviderService
            .spellListPublisher()
            .map { SpellListAction.showSpellList($0) }
            .catch { Just(SpellListAction.showSpellListLoadError($0)) }
            .eraseToAnyPublisher())
    case let .showSpellList(spells):
        let sortedSpells = environment.refinementsService.sortedSpells(spells: spells, sort: .name)
        return (.spellList(displayedSpells: sortedSpells, allSpells: sortedSpells), nil)
    case let .showSpellListLoadError(error):
        return (.error(error), nil)
    case let .search(query):
        guard case let .spellList(_, allSpells) = state else { return (nil, nil) }
        let refinedSpells = environment.refinementsService.filteredSpells(spells: allSpells, by: query)
        return (.spellList(displayedSpells: refinedSpells, allSpells: allSpells), nil)
    case let .sort(by: sort):
        guard case let .spellList(_, allSpells) = state else { return (nil, nil) }
        let refinedSpells = environment.refinementsService.sortedSpells(spells: allSpells, sort: sort)
        return (.spellList(displayedSpells: refinedSpells, allSpells: allSpells), nil)
    }
}
