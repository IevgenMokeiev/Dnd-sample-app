//
//  TabbarView.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 20.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import SwiftUI

struct TabbarView: View {

    @EnvironmentObject var factory: ViewFactory

    var body: some View {
        TabView() {
            factory.createSpellListView()
            .tabItem {
                Image(systemName: "book.fill")
                Text("Spell Book")
            }.accessibility(identifier: "SpellsTab")
            factory.createFavoritesView()
            .tabItem {
                Image(systemName: "bookmark.fill")
                Text("Favorites")
            }.accessibility(identifier: "FavoritesTab")
            factory.createAddSpellView()
            .tabItem {
                Image(systemName: "plus.circle.fill")
                Text("Add Spell")
            }.accessibility(identifier: "AddSpellTab")
        }
        .accentColor(.orange)
    }
}

struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        let store = AppStore(initialState: AppState(spellListState: .initial, spellDetailState: .initial, favoritesState: .initial), reducer: appReducer, environment: ServiceContainerImpl())
        let factory = ViewFactory()
        return factory.createTabbarView().environmentObject(store).environmentObject(factory)
    }
}
