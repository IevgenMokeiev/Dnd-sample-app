//
//  FavoritesReducer.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 27.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import Combine

func favoritesReducer(state: FavoritesState, action: FavoritesAction, environment: ServiceContainer) -> (state: FavoritesState?, effect: AnyPublisher<FavoritesAction, Never>?) {
    switch action {
    case .requestFavorites:
        return (nil, environment.spellProviderService
            .favoritesPublisher()
            .map { FavoritesAction.showFavorites($0) }
            .catch { _ in Just(FavoritesAction.showFavorites([])) }
            .eraseToAnyPublisher())
    case let .showFavorites(spells):
        return (.favorites(spells), nil)
    }
}
