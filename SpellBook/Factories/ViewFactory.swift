//
//  ViewFactory.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 13.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import SwiftUI

class ViewFactory: ObservableObject {
    let interactor: Interactor

    init(interactor: Interactor) {
        self.interactor = interactor
    }

    @MainActor
    func createTabbarView() -> TabbarView {
        return TabbarView()
    }

    @MainActor
    func createSpellListView() -> SpellListView {
        let viewModel = SpellListViewModel(
            interactor: interactor,
            refinementsClosure: { [weak self] in
                guard let self else { return [] }
                return self.interactor.refine(spells: $0, sort: $1, searchTerm: $2)
            }
        )
        return SpellListView(viewModel: viewModel)
    }

    @MainActor
    func createSpellDetailView(path: String) -> SpellDetailView {
        let viewModel = SpellDetailViewModel(
            interactor: interactor,
            path: path,
            saveClosure: { spellDTO in
                Task { [weak self] in
                    guard let self else { return }
                    await self.interactor.saveSpell(spellDTO)
                }
            }
        )
        return SpellDetailView(
            viewModel: viewModel
        )
    }

    @MainActor
    func createFavoritesView() -> FavoritesView {
        let viewModel = FavoritesViewModel(interactor: interactor)
        return FavoritesView(viewModel: viewModel)
    }
}
