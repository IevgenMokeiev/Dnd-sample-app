//
//  SpellDetailView.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 12.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import SwiftUI
import Combine

struct SpellDetailView: View {
  var spellPath: String
  @EnvironmentObject var store: AppStore

  var body: some View {
    content
      .padding(.top, 5)
      .onAppear(perform: fetch)
      .navigationBarTitle("Spell Detail")
      .navigationBarItems(trailing:
                            Button(favoriteButtonText) {
        self.store.send(.toggleFavorite)
      }.foregroundColor(.orange)
                            .accessibility(identifier: "FavoritesButton")
      )
  }

  @ViewBuilder private var content: some View {
    switch store.state.spellDetailState {
    case let .selectedSpell(spellDTO):
      loadedView(spellDTO)
    case .error:
      ErrorView()
    case .initial:
      ProgressView(isAnimating: true)
    }
  }

  private var favoriteButtonText: String {
    guard case let .selectedSpell(spellDTO) = store.state.spellDetailState else { return "" }
    return spellDTO.isFavorite ? "Remove from Favorites" : "Add to Favorites"
  }

  private func fetch() {
    store.send(.spellDetail(.requestSpell(path: spellPath)))
  }
}

extension SpellDetailView {
  func loadedView(_ spellDTO: SpellDTO) -> some View {
    ScrollView {
      VStack(alignment: .leading) {
        Text("\(spellDTO.name)")
          .fontWeight(.bold)
          .font(.system(size: 30))
          .foregroundColor(.orange)
          .frame(maxWidth: .infinity, alignment: .center)
        Image("scroll")
          .padding()
          .frame(maxWidth: .infinity, alignment: .center)
        Text("Level: \(spellDTO.level ?? 0)")
          .fontWeight(.bold)
          .padding(.vertical, 5)
          .padding(.horizontal)
        Text("Casting time: \(spellDTO.castingTime ?? "")")
          .padding(.vertical, 5)
          .padding(.horizontal)
        Text("Concentration: \(spellDTO.concentration ?? false ? "true" : "false")")
          .padding(.vertical, 5)
          .padding(.horizontal)
        Text("Classes: \(spellDTO.classes ?? "")")
          .padding(.vertical, 5)
          .padding(.horizontal)
        Divider().background(Color.orange)
        Text("\(spellDTO.description ?? "")").padding()
        if spellDTO.higherLevel != nil {
          Divider().background(Color.orange)
          Text("At Higher Levels: \(spellDTO.higherLevel ?? "")").padding()
        }
      }
    }
  }
}

struct SpellDetailView_Previews: PreviewProvider {
  static var previews: some View {
    let store = AppStore(initialState: AppState(spellListState: .initial, spellDetailState: .initial, favoritesState: .initial), reducer: appReducer, environment: ServiceContainerImpl())
    let factory = ViewFactory()
    return factory.createSpellDetailView(path: "path").environmentObject(store).environmentObject(factory)
  }
}
