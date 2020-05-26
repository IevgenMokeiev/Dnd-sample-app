//
//  ViewFactory.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 13.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

/// Factory to construct SwiftUI views
class ViewFactory: ObservableObject {
    func createTabbarView() -> TabbarView {
        return TabbarView()
    }

    func createSpellListView() -> SpellListView {
        return SpellListView()
    }

    func createSpellDetailView(path: String) -> SpellDetailView {
        return SpellDetailView(spellPath: path)
    }

    func createFavoritesView() -> FavoritesView {
        return FavoritesView()
    }
}
