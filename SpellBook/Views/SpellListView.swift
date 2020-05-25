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
    }

    private var content: AnyView {
        if !store.state.displayedSpells.isEmpty {
            return AnyView(loadedView(store.state.displayedSpells, onReceive: search(query:)))
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
    func loadedView(_ spellDTOs: [SpellDTO], onReceive: @escaping (String) -> Void) -> some View {
        VStack {
            SearchView(onReceive: onReceive)
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
