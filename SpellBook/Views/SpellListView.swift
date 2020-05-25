//
//  SpellListView.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 08.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import SwiftUI
import Combine

class SearchStore: ObservableObject {
    @Published var query: String = ""
}

struct SpellListView: View {
    @EnvironmentObject var store: AppStore
    @ObservedObject var searchStore = SearchStore()

    var body: some View {
        NavigationView {
            content
            .navigationBarTitle("Spell Book", displayMode: .inline)
            .navigationBarItems(trailing:
                Button("Sort by Level") {
                    self.store.send(.sort(by: .level))
                }.foregroundColor(.orange)
            )
        }
        .onAppear(perform: fetch)
        .onReceive(searchStore.$query.removeDuplicates(), perform: search)
    }

    private var content: AnyView {
        if !store.state.displayedSpells.isEmpty {
            return AnyView(loadedView(store.state.displayedSpells, query: $searchStore.query))
        } else if store.state.error != nil {
            return AnyView(ErrorView())
        } else {
            return AnyView(ProgressView(isAnimating: true))
        }
    }

    private func fetch() {
        store.send(.requestSpellList)
    }

    private func search(query: String) {
        if !query.isEmpty {
            store.send(.search(query: query))
        }
    }
}

extension SpellListView {
    func loadedView(_ spellDTOs: [SpellDTO], query: Binding<String>) -> some View {
        VStack {
            SearchView(query: query)
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
