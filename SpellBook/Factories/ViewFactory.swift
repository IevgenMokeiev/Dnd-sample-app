//
//  ViewFactory.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 13.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import SwiftUI

/// Factory to construct SwiftUI views
class ViewFactory: ObservableObject {
  func createTabbarView() -> AnyView {
    return AnyView(TabbarView())
  }

  func createSpellListView() -> AnyView {
    return AnyView(SpellListView())
  }

  func createSpellDetailView(path: String) -> AnyView {
    return AnyView(SpellDetailView(spellPath: path))
  }

  func createFavoritesView() -> AnyView {
    return AnyView(FavoritesView())
  }

  func createAddSpellView() -> AnyView {
    return AnyView(AddSpellView())
  }
}
