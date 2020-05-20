//
//  ViewFactory.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 13.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import SwiftUI

typealias SpellListViewConstructor = () -> SpellListView
typealias FavoritesViewConstructor = () -> FavoritesView
typealias SpellDetailViewConstructor = (_ path: String) -> SpellDetailView

/// Factory to construct SwiftUI views
protocol ViewFactory {
    func createTabbarView() -> TabbarView
    func createSpellListView() -> SpellListView
    func createSpellDetailView(path: String) -> SpellDetailView
    func createFavoritesView() -> FavoritesView
}

class ViewFactoryImpl: ViewFactory {

    let dataLayer: DataLayer

    init(dataLayer: DataLayer) {
        self.dataLayer = dataLayer
    }

    func createTabbarView() -> TabbarView {
        let viewModel = TabbarViewModel(spellListConstructor: { self.createSpellListView()
        }) { self.createFavoritesView()
        }
        return TabbarView(viewModel: viewModel)
    }

    func createSpellListView() -> SpellListView {
        let viewModel = SpellListViewModel(publisher: dataLayer.spellListPublisher(), refinementsBlock: { self.dataLayer.refineSpells(spells: $0, sort: $1, searchTerm: $2)
        }) { self.createSpellDetailView(path: $0) }
        return SpellListView(viewModel: viewModel)
    }

    func createSpellDetailView(path: String) -> SpellDetailView {
        let viewModel = SpellDetailViewModel(publisher: dataLayer.spellDetailsPublisher(for: path))
        return SpellDetailView(viewModel: viewModel)
    }

    func createFavoritesView() -> FavoritesView {
        let viewModel = FavoritesViewModel(publisher: dataLayer.favoritesPublisher()) { self.createSpellDetailView(path: $0) }
        return FavoritesView(viewModel: viewModel)
    }
}
