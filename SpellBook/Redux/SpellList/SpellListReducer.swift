//
//  SpellListReducer.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 27.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import Combine

func spellListReducer(
  state: SpellListState,
  action: SpellListAction,
  environment: ServiceContainer
) -> ReducerResult<SpellListState, SpellListAction> {
  switch action {
  case .requestSpellList:
    return ReducerResult(
      effect: environment.spellProviderService
        .spellListPublisher()
        .map { SpellListAction.showSpellList($0) }
        .catch { Just(SpellListAction.showSpellListLoadError($0)) }
        .eraseToAnyPublisher()
    )
  case let .showSpellList(spells):
    let sortedSpells = environment.refinementsService.sortedSpells(
      spells: spells,
      sort: .name
    )
    return ReducerResult(
      state: .spellList(
        displayedSpells: sortedSpells,
        allSpells: sortedSpells
      )
    )
  case let .showSpellListLoadError(error):
    return ReducerResult(state: .error(error))
  case let .search(query):
    guard case let .spellList(_, allSpells) = state else { return ReducerResult() }
    let refinedSpells = environment.refinementsService.filteredSpells(
      spells: allSpells,
      by: query
    )
    return ReducerResult(
      state: .spellList(
        displayedSpells: refinedSpells,
        allSpells: allSpells
      )
    )
  case let .sort(by: sort):
    guard case let .spellList(_, allSpells) = state else { return ReducerResult() }
    let refinedSpells = environment.refinementsService.sortedSpells(
      spells: allSpells,
      sort: sort
    )
    return ReducerResult(state: .spellList(
      displayedSpells: refinedSpells,
      allSpells: allSpells
    ))
  }
}
