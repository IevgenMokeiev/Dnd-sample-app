//
//  SpellListView.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 08.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import SwiftUI
import Combine

struct SpellListView: View {

    @EnvironmentObject var store: AppStore
    @State private var searchTerm: String = "" {
        didSet {
            store.send(.search(query: searchTerm))
        }
    }

    var body: some View {
        NavigationView {
            content
            .navigationBarTitle("Spell Book", displayMode: .inline)
            .navigationBarItems(trailing:
                Button("Sort by Level") {
                    self.store.send(.sort(by: .level))
                }.foregroundColor(.orange)
            )
        }.onAppear(perform: fetch)
    }

    private var content: AnyView {
        if !store.state.displayedSpells.isEmpty {
            return AnyView(loadedView(store.state.displayedSpells, searchTerm: $searchTerm))
        } else if store.state.error != nil {
            return AnyView(ErrorView())
        } else {
            return AnyView(ProgressView(isAnimating: true))
        }
    }

    private func fetch() {
        store.send(.requestSpellList)
    }
}

extension SpellListView {
   func loadedView(_ spellDTOs: [SpellDTO], searchTerm: Binding<String>) -> some View {
        VStack {
            SearchView(searchTerm: searchTerm)
            Divider().background(Color.orange)
            List(spellDTOs) { spell in
                NavigationLink(destination: self.store.factory.createSpellDetailView(path: spell.path)) {
                    Text(spell.name)
                }
            }
            .accessibility(label: Text("Spell Table View"))
            .accessibility(identifier: "SpellTableView")
        }
    }
}

struct SpellListView_Previews: PreviewProvider {
    static var previews: some View {
        return ViewFactory().createSpellListView()
    }
}
