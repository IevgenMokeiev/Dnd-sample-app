//
//  FavoritesView.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 20.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import SwiftUI

struct FavoritesView: View {

    @EnvironmentObject var store: AppStore

    var body: some View {
        NavigationView {
            List(store.state.favorites) { spell in
                NavigationLink(destination: self.store.factory.createSpellDetailView(path: spell.path)) {
                    Text(spell.name)
                }
            }
            .accessibility(label: Text("Favorites Table"))
            .accessibility(identifier: "FavoritesTableView")
            .navigationBarTitle("Favorites", displayMode: .inline)
            .onAppear(perform: fetch)
        }
    }

    private func fetch() {
        store.send(.requestFavorites)
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        return ViewFactory().createFavoritesView()
    }
}




