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
                .navigationBarTitle("Favorites", displayMode: .inline)
        }
        .onAppear(perform: fetch)
    }
    
    @ViewBuilder private var content: some View {
        switch store.state.favoritesState {
        case let .favorites(spells) where spells.count > 0:
            loadedView(spells)
        case .favorites:
            Image("no-spells")
                .resizable()
                .padding()
        case .initial:
            Text("No Favorites Yet").foregroundColor(.orange)
        }
    }
    
    private func fetch() {
        store.send(.favorites(.requestFavorites))
    }
}

extension FavoritesView {
    func loadedView(_ spellDTOs: [SpellDTO]) -> some View {
        List(spellDTOs) { spell in
            NavigationLink(destination: factory.createSpellDetailView(path: spell.path)) {
                Text(spell.name)
            }
        }
        .listStyle(.plain)
        .accessibility(label: Text("Favorites Table"))
        .accessibility(identifier: "FavoritesTableView")
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        let store = AppStore(
            initialState: AppState(
                spellListState: .initial,
                spellDetailState: .initial,
                favoritesState: .initial
            ), reducer: appReducer, environment: ServiceContainerImpl())
        let factory = ViewFactory()
        return factory.createFavoritesView().environmentObject(store).environmentObject(factory)
    }
}

