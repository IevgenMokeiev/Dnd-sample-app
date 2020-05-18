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
        NavigationView {
            if viewModel.loading {
                ProgressView(isAnimating: $viewModel.loading)
                .onAppear(perform: viewModel.onAppear)
            } else {
                VStack {
                    Text("\(viewModel.spellDTO.name)")
                        .fontWeight(.bold)
                        .font(.system(size: 30))
                        .foregroundColor(Color.orange)
                    Image("scroll").padding()
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
                .padding()
            }
        }
        .navigationBarTitle("Spell Details", displayMode: .inline)
    }
}

struct SpellDetailView_Previews: PreviewProvider {
    static var previews: some View {
        return AppCoordinator().viewFactory.provideSpellDetailView(spell: SpellDTO(name: "name", path: "path", level: 1, description: "description", castingTime: "1 action", concentration: false))
    }
}
