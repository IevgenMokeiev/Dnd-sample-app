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
    @State private var selectedPage = 0
    @State private var redraw = false

    var body: some View {
        TabView(selection: $selectedPage) {
            factory.createSpellListView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Spell Book")
                }
                .accessibility(identifier: "SpellTab")
                .tag(0)
            factory.createFavoritesView()
                .tabItem {
                    Image(systemName: "bookmark.fill")
                    Text("Favorites")
                }
                .accessibility(identifier: "FavoritesTab")
                .tag(1)
        }
        .accentColor(.orange)
        .onChange(of: selectedPage) { _ in
            // we want view to redraw each time different tab is selected
            redraw.toggle()
        }
    }
}

struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        return AppCoordinator().viewFactory.createTabbarView()
    }
}
