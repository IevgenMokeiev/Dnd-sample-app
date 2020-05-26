//
//  SpellDetailView.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 12.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import SwiftUI
import Combine

struct SpellDetailView: View {
    var spellPath: String
    @EnvironmentObject var store: AppStore

    var body: some View {
        content
        .padding(.top, 5)
        .onAppear(perform: fetch)
        .navigationBarTitle("Spell Detail")
        .navigationBarItems(trailing:
            Button(favoriteButtonText) {
                self.store.send(.toggleFavorite)
            }.foregroundColor(.orange)
            .accessibility(identifier: "FavoritesButton")
        )
    }

    private var content: AnyView {
        if let spellDTO = store.state.selectedSpell {
            return AnyView(loadedView(spellDTO))
        } else if store.state.error != nil {
            return AnyView(ErrorView())
        } else {
            return AnyView(ProgressView(isAnimating: true))
        }
    }

    private var favoriteButtonText: String {
        if let spellDTO = store.state.selectedSpell {
            return spellDTO.isFavorite ? "Remove from Favorites" : "Add to Favorites"
        } else {
            return ""
        }
    }

    private func fetch() {
        store.send(.requestSpell(path: spellPath))
    }
}

extension SpellDetailView {
   func loadedView(_ spellDTO: SpellDTO) -> some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("\(spellDTO.name)")
                .fontWeight(.bold)
                .font(.system(size: 30))
                .foregroundColor(.orange)
                .frame(maxWidth: .infinity, alignment: .center)
                Image("scroll")
                .padding()
                .frame(maxWidth: .infinity, alignment: .center)
                Text("Level: \(spellDTO.level ?? 0)")
                .fontWeight(.bold)
                .padding(.vertical, 5)
                .padding(.horizontal)
                Text("Casting time: \(spellDTO.castingTime ?? "")")
                .padding(.vertical, 5)
                .padding(.horizontal)
                Text("Concentration: \(spellDTO.concentration ?? false ? "true" : "false")")
                .padding(.vertical, 5)
                .padding(.horizontal)
                Text("Classes: \(spellDTO.classes ?? "")")
                .padding(.vertical, 5)
                .padding(.horizontal)
                Divider().background(Color.orange)
                Text("\(spellDTO.description ?? "")").padding()
            }
        }
    }
}

struct SpellDetailView_Previews: PreviewProvider {
    static var previews: some View {
        return ViewFactory().createSpellDetailView(path: "path")
    }
}
