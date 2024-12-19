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
    @ViewBuilder func createTabbarView() -> some View {
        TabbarView()
    }
    
    @ViewBuilder func createSpellListView() -> some View {
        SpellListView()
    }
    
    @ViewBuilder func createSpellDetailView(path: String) -> some View {
        SpellDetailView(spellPath: path)
    }
    
    @ViewBuilder func createFavoritesView() -> some View {
        FavoritesView()
    }
    
    @ViewBuilder func createAddSpellView() -> some View {
        AddSpellView()
    }
}

