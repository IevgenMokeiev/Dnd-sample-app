//
//  SpellDetailView.swift
//  Dnd5eApp
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
                ProgressView(isAnimating: $viewModel.loading)
                    .onAppear(perform: viewModel.onAppear)
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
                            .padding()
                        Text("Description: \(viewModel.spellDTO.description ?? "")")
                            .padding()
                        Text("Casting time: \(viewModel.spellDTO.castingTime ?? "")")
                            .padding()
                        Text("Concentration: \(viewModel.spellDTO.concentration ?? false ? "true" : "false")")
                            .padding()
                    }
                }
            }
        }
        .padding(.top, 5)
        .navigationBarTitle("Spell Detail")
        .navigationBarItems(trailing:
            Button("Add to Favorites") {
                self.viewModel.markFavorite()
            }
            .foregroundColor(.orange)
        )
    }
}

struct SpellDetailView_Previews: PreviewProvider {
    static var previews: some View {
        return AppCoordinator().viewFactory.createSpellDetailView(path: "path")
    }
}
