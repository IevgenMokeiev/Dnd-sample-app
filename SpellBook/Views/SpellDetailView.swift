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
    
    @ObservedObject var viewModel: SpellDetailViewModel

    var body: some View {
        VStack {
            if viewModel.loading {
                ProgressView(isAnimating: true)
            } else {
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("\(viewModel.spellDTO.name)")
                        .fontWeight(.bold)
                        .font(.system(size: 30))
                        .foregroundColor(.orange)
                        .frame(maxWidth: .infinity, alignment: .center)
                        Image("scroll")
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                        Text("Level: \(viewModel.spellDTO.level ?? 0)")
                        .fontWeight(.bold)
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                        Text("Casting time: \(viewModel.spellDTO.castingTime ?? "")")
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                        Text("Concentration: \(viewModel.spellDTO.concentration ?? false ? "true" : "false")")
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                        Text("Classes: \(viewModel.spellDTO.classes ?? "")")
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                        Divider().background(Color.orange)
                        Text("\(viewModel.spellDTO.description ?? "")").padding()
                    }
                }
            }
        }
        .padding(.top, 5)
        .onAppear(perform: viewModel.onAppear)
        .navigationBarTitle("Spell Detail")
        .navigationBarItems(trailing:
            Button(viewModel.favoriteButtonText) {
                self.viewModel.toggleFavorite()
            }.foregroundColor(.orange)
            .accessibility(identifier: "FavoritesButton")
        )
    }
}

struct SpellDetailView_Previews: PreviewProvider {
    static var previews: some View {
        return AppCoordinator().viewFactory.createSpellDetailView(path: "path")
    }
}
