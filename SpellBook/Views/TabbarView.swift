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
            }.accessibility(identifier: "SpellTab")
            factory.createFavoritesView()
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
        return ViewFactory().createTabbarView()
    }
}
