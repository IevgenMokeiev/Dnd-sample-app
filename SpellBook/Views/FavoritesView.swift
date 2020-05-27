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
    @EnvironmentObject var factory: ViewFactory

    var body: some View {
        NavigationView {
            content
        }
        .onAppear(perform: fetch)
    }

    private var content: AnyView {
        switch store.state.favoritesState {
        case let .favorites(spells):
            return AnyView(loadedView(spells))
        case .initial:
            return AnyView(Text("No Favorites Yet").foregroundColor(.orange))
        }
    }

    private func fetch() {
        store.send(.favorites(.requestFavorites))
    }
}

extension FavoritesView {
    func loadedView(_ spellDTOs: [SpellDTO]) -> some View {
        List(spellDTOs) { spell in
            NavigationLink(destination: self.factory.createSpellDetailView(path: spell.path)) {
                Text(spell.name)
            }
        }
        .accessibility(label: Text("Favorites Table"))
        .accessibility(identifier: "FavoritesTableView")
        .navigationBarTitle("Favorites", displayMode: .inline)
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        return ViewFactory().createFavoritesView()
    }
}




