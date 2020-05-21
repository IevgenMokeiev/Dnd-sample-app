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
            VStack {
                if viewModel.loading {
                    ProgressView(isAnimating: $viewModel.loading)
                } else {
                    SearchView(searchTerm: $viewModel.searchTerm)
                    Divider().background(Color.orange)
                    List(viewModel.publishedSpellDTOs) { spell in
                        NavigationLink(destination: self.viewModel.spellDetailViewConstructor(spell.path)) {
                            Text(spell.name)
                        }
                    }
                    .accessibility(label: Text("Spell Table View"))
                    .accessibility(identifier: "SpellTableView")
                    .navigationBarTitle("Spell Book", displayMode: .inline)
                    .navigationBarItems(trailing:
                        Button("Sort by Level") {
                            self.viewModel.selectedSort = .level
                        }.foregroundColor(.orange)
                    )
                }
            }.onAppear(perform: viewModel.onAppear)
        }
    }
}

struct SpellListView_Previews: PreviewProvider {
    static var previews: some View {
        return AppCoordinator().viewFactory.createSpellListView()
    }
}