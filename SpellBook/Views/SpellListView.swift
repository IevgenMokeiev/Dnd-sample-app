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
    @EnvironmentObject var factory: ViewFactory

    var body: some View {
        NavigationView {
            content
            .navigationBarTitle("Spell Book", displayMode: .inline)
            .navigationBarItems(trailing:
                Button("Sort by Level") {
                    self.viewModel.selectedSort = .level
                }.foregroundColor(.orange)
            )
        }.onAppear(perform: viewModel.onAppear)
    }

    @ViewBuilder private var content: some View {
        switch viewModel.state {
        case .loading:
          ProgressView(isAnimating: true)
        case .spells(let spellDTOs):
          loadedView(spellDTOs, searchTerm: $viewModel.searchTerm)
        case .error:
          ErrorView()
        }
    }
}

extension SpellListView {
   func loadedView(_ spellDTOs: [SpellDTO], searchTerm: Binding<String>) -> some View {
        VStack {
            SearchView(searchTerm: searchTerm)
            Divider().background(Color.orange)
            List(spellDTOs) { spell in
                NavigationLink(destination: self.factory.createSpellDetailView(path: spell.path)) {
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
        return AppCoordinator().viewFactory.createSpellListView()
    }
}
