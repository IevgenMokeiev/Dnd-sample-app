//
//  ViewFactory.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 13.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import SwiftUI

@MainActor
class ViewFactory: ObservableObject {
    let interactor: Interactor

    init(interactor: Interactor) {
        self.interactor = interactor
    }

    func createTabbarView() -> TabbarView {
        return TabbarView()
    }

    func createSpellListView() -> SpellListView {
        let viewModel = SpellListViewModel(interactor: interactor)
        return SpellListView(viewModel: viewModel)
    }

    func createSpellDetailView(path: String) -> SpellDetailView {
        let viewModel = SpellDetailViewModel(
            interactor: interactor,
            path: path
        )
        return SpellDetailView(
            viewModel: viewModel
        )
    }

    func createFavoritesView() -> FavoritesView {
        let viewModel = FavoritesViewModel(interactor: interactor)
        return FavoritesView(viewModel: viewModel)
    }
}
