//
//  TabbarView.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 20.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import SwiftUI

struct TabbarView: View {

    @EnvironmentObject var store: AppStore
    
    var body: some View {
        TabView() {
            store.factory.spellListView
            .tabItem {
                Image(systemName: "book.fill")
                Text("Spell Book")
            }.accessibility(identifier: "SpellTab")
            store.factory.favoritesView
            .tabItem {
                Image(systemName: "bookmark.fill")
                Text("Favorites")
            }.accessibility(identifier: "FavoritesTab")
        }
        .accentColor(.orange)
    }
}

struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        return ViewFactory().tabbarView
    }
}
