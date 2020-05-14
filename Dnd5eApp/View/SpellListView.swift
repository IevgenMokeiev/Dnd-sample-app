//
//  SpellListView.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 08.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import SwiftUI
import Combine

struct SpellListView: View {

    var dataLayer: DataLayer?
    var viewFactory: ViewFactory?
    @State var spells: [SpellDTO] = []

    @State var bag = Set<AnyCancellable>()

    var body: some View {
        NavigationView {
            List(spells) { spell in
                NavigationLink(destination: self.viewFactory?.provideSpellDetailView(spell: spell)) {
                    Text(spell.name)
                }
            }
            .accessibility(label: Text("Spell Table View"))
            .accessibility(identifier: "SpellTableView")
            .onAppear(perform: loadData)
            .navigationBarTitle("Spell Book", displayMode: .inline)
        }
    }

    // MARK: - Loading
    private func loadData() {
        dataLayer?.retrieveSpellList()
        .sink(receiveCompletion: { _ in
        }, receiveValue: { spellList in
            self.spells = spellList
        })
        .store(in: &bag)
    }
}

struct SpellListView_Previews: PreviewProvider {
    static var previews: some View {
        return SpellListView(dataLayer: AppModule.provideDataLayer())
    }
}
