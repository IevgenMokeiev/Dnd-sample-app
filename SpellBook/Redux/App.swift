//
//  App.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 25.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Combine

typealias AppStore = Store<AppState, AppAction, ServiceContainer>

struct AppState {
  let spellListState: SpellListState
  let spellDetailState: SpellDetailState
  let favoritesState: FavoritesState
}

enum AppAction {
  case spellList(SpellListAction)
  case spellDetail(SpellDetaiAction)
  case favorites(FavoritesAction)
  case toggleFavorite
  case addSpell(SpellDTO)
}
