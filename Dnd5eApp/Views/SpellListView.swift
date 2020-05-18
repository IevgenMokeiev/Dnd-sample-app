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

    @ObservedObject var viewModel: SpellListViewModel
    var viewFactory: ViewFactory?

    var body: some View {
        NavigationView {
            VStack {
                TextField("type spell here...", text: $viewModel.searchTerm)
                .padding()
                List(viewModel.spellDTOs) { spell in
                    NavigationLink(destination: self.viewFactory?.provideSpellDetailView(spell: spell)) {
                        Text(spell.name)
                    }
                }
                .accessibility(label: Text("Spell Table View"))
                .accessibility(identifier: "SpellTableView")
                .navigationBarTitle("Spell Book", displayMode: .inline)
                .onAppear(perform: viewModel.onAppear)
            }
        }
    }
}

struct SpellListView_Previews: PreviewProvider {
    static var previews: some View {
        return AppCoordinator().viewFactory.provideSpellListView()
    }
}
