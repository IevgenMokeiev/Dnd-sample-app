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
  @EnvironmentObject var factory: ViewFactory
  @ObservedObject private var searchStore = SearchStore()
  
  var body: some View {
    NavigationView {
      content
        .navigationBarTitle("Spell Book", displayMode: .inline)
        .navigationBarItems(trailing:
                              Button("Sort by Level") {
          self.store.send(.spellList(.sort(by: .level)))
        }.foregroundColor(.orange)
        )
    }
    .onAppear(perform: fetch)
    .onReceive(searchStore.$query.dropFirst()) { self.search(query: $0) }
  }
  
  @ViewBuilder private var content: some View {
    switch store.state.spellListState {
    case let .spellList(displayedSpells, _):
      loadedView(displayedSpells)
    case .error:
      ErrorView()
    case .initial:
      ProgressView(isAnimating: true)
    }
  }
  
  private func fetch() {
    store.send(.spellList(.requestSpellList))
  }
  
  private func search(query: String) {
    store.send(.spellList(.search(query: query)))
  }
}

extension SpellListView {
  func loadedView(_ spellDTOs: [SpellDTO]) -> some View {
    VStack {
      SearchView(query: $searchStore.query)
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
    let store = AppStore(initialState: AppState(spellListState: .initial, spellDetailState: .initial, favoritesState: .initial), reducer: appReducer, environment: ServiceContainerImpl())
    let factory = ViewFactory()
    return factory.createSpellListView().environmentObject(store).environmentObject(factory)
  }
}
