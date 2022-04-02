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

  let interactor: Interactor

  init(interactor: Interactor) {
    self.interactor = interactor
  }

  func createTabbarView() -> TabbarView {
    return TabbarView()
  }

  func createSpellListView() -> SpellListView {
    let viewModel = SpellListViewModel(
      publisher: interactor.spellListPublisher,
      refinementsBlock: { self.interactor.refine(spells: $0, sort: $1, searchTerm: $2)}
    )
    return SpellListView(viewModel: viewModel)
  }

  func createSpellDetailView(path: String) -> SpellDetailView {
    let viewModel = SpellDetailViewModel(publisher: interactor.spellDetailsPublisher(for: path), saveBlock: { self.interactor.saveSpell($0) })
    return SpellDetailView(viewModel: viewModel)
  }

  func createFavoritesView() -> FavoritesView {
    let viewModel = FavoritesViewModel(publisher: interactor.favoritesPublisher)
    return FavoritesView(viewModel: viewModel)
  }
}
