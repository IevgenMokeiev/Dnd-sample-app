//
//  FavoritesReducer.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 27.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import Combine

func favoritesReducer(
  state: FavoritesState,
  action: FavoritesAction,
  environment: ServiceContainer
) -> ReducerResult<FavoritesState, FavoritesAction> {
  switch action {
  case .requestFavorites:
    return ReducerResult(
      effect: environment.spellProviderService
        .favoritesPublisher
        .map { FavoritesAction.showFavorites($0) }
        .eraseToAnyPublisher())
  case let .showFavorites(spells):
    return ReducerResult(state: .favorites(spells))
  }
}
