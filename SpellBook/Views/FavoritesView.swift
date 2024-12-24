//
//  FavoritesView.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 20.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: FavoritesViewModel
    @EnvironmentObject var factory: ViewFactory

    var body: some View {
        NavigationView {
            List(viewModel.spellDTOs) { spell in
                NavigationLink(destination: self.factory.createSpellDetailView(path: spell.path)) {
                    Text(spell.name)
                }
            }
            .accessibility(label: Text("Favorites Table"))
            .accessibility(identifier: "FavoritesTableView")
            .navigationBarTitle("Favorites", displayMode: .inline)
            .task {
                await viewModel.onAppear()
            }
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        return AppCoordinator().viewFactory.createFavoritesView()
    }
}
