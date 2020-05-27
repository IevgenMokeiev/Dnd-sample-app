//
//  SpellDetailReducer.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 27.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import Combine

func spellDetailReducer(state: SpellDetailState, action: SpellDetaiAction, environment: ServiceContainer) -> (state: SpellDetailState?, effect: AnyPublisher<SpellDetaiAction, Never>?) {
    switch action {
    case let .requestSpell(path: path):
        return (.initial, environment.spellProviderService
            .spellDetailsPublisher(for: path)
            .map { SpellDetaiAction.showSpell($0) }
            .catch { Just(SpellDetaiAction.showSpellLoadError($0)) }
            .eraseToAnyPublisher())
    case let .showSpell(spell):
        return (.selectedSpell(spell), nil)
    case let .showSpellLoadError(error):
        return (.error(error), nil)
    case .toggleFavorite:
        guard case let .selectedSpell(spell) = state else { return (nil, nil) }
        let newSpell = spell.toggleFavorite(value: !spell.isFavorite)
        environment.spellProviderService.saveSpellDetails(newSpell)
        return (.selectedSpell(newSpell), nil)
    }    
}
