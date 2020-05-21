//
//  TabbarView.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 20.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import SwiftUI

struct TabbarView: View {

    var viewModel: TabbarViewModel
    
    var body: some View {
        TabView() {
            viewModel.spellListConstructor()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Spell Book")
            }
            viewModel.favoritesConstructor()
                .tabItem {
                    Image(systemName: "bookmark.fill")
                    Text("Favorites")
            }
        }
        .accentColor(.orange)
    }
}

struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        return AppCoordinator().viewFactory.createTabbarView()
    }
}
