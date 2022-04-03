//
//  Favorites.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 27.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation

enum FavoritesState {
  case initial
  case favorites([SpellDTO])
}

enum FavoritesAction {
  case requestFavorites
  case showFavorites([SpellDTO])
}
