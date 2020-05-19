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

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image("search")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .padding(.trailing, 5)
                    TextField("type spell here...", text: $viewModel.searchTerm)
                        .accessibility(identifier: "SpellSearchView")
                }
                .padding([.horizontal, .top], 15)
                Divider()
                    .background(Color.orange)
                List(viewModel.spellDTOs) { spell in
                    NavigationLink(destination: self.viewModel.spellDetailConstructor(spell.path)) {
                        Text(spell.name)
                    }
                }
                    .accessibility(label: Text("Spell Table View"))
                    .accessibility(identifier: "SpellTableView")
                    .navigationBarTitle("Spell Book", displayMode: .inline)
                    .navigationBarItems(trailing:
                        Button("Sort by Level") {
                            self.viewModel.selectedSort = .level
                        }
                        .foregroundColor(.orange)
                    )
                    .onAppear(perform: viewModel.onAppear)
            }
        }
    }
}

struct SpellListView_Previews: PreviewProvider {
    static var previews: some View {
        return AppCoordinator().viewFactory.createSpellListView()
    }
}
