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

    @ObservedObject var viewModel: SpellListViewModel

    var body: some View {
        NavigationView {
                self.content
                .navigationBarTitle("Spell Book", displayMode: .inline)
                .navigationBarItems(trailing:
                    Button("Sort by Level") {
                        self.viewModel.selectedSort = .level
                    }.foregroundColor(.orange)
                )
            }.onAppear(perform: viewModel.onAppear)
        }
    }

    private var content: AnyView {
        switch viewModel.state {
        case .loading: return AnyView(ProgressView(isAnimating: true))
        case .spells(let spellDTOs): return AnyView(SpellContentView)
        }
    }
}

struct SpellContentView: View {

    @Binding var searchTerm: String
    @Binding var spellDTOs: [SpellDTO]

    var body: some View {
        VStack {
            SearchView(searchTerm: $searchTerm)
            Divider().background(Color.orange)
            List(spellDTOs) { spell in
//                NavigationLink(destination: self.viewModel.spellDetailViewConstructor(spell.path)) {
                    Text(spell.name)
//                }
            }
            .accessibility(label: Text("Spell Table View"))
            .accessibility(identifier: "SpellTableView")
        }
    }
}

struct SpellListView_Previews: PreviewProvider {
    static var previews: some View {
        return AppCoordinator().viewFactory.createSpellListView()
    }
}
