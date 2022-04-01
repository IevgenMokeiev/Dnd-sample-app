//
//  SpellDetailReducer.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 27.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import Combine

func spellDetailReducer(state: SpellDetailState, action: SpellDetaiAction, environment: ServiceContainer) -> ReducerResult<SpellDetailState, SpellDetaiAction> {
  switch action {
  case let .requestSpell(path: path):
    return ReducerResult(state: .initial, effect: environment.spellProviderService
                          .spellDetailsPublisher(for: path)
                          .map { SpellDetaiAction.showSpell($0) }
                          .catch { Just(SpellDetaiAction.showSpellLoadError($0)) }
                          .eraseToAnyPublisher())
  case let .showSpell(spell):
    return ReducerResult(state: .selectedSpell(spell))
  case let .showSpellLoadError(error):
    return ReducerResult(state: .error(error))
  }
}
