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
    @State var loading: Bool = true

    var body: some View {
        NavigationView {
            if self.loading {
                ProgressView(isAnimating: $loading)
                    .onAppear(perform: viewModel.onAppear)
            } else {
                VStack {
                    Text("\(viewModel.filledSpellDTO.name)")
                        .fontWeight(.bold)
                    Image("scroll").padding()
                    Text("Level: \(viewModel.filledSpellDTO.level ?? 0)")
                        .fontWeight(.bold)
                        .padding()
                    Text("Description: \(viewModel.filledSpellDTO.description ?? "")")
                        .padding()
                    Text("Casting time: \(viewModel.filledSpellDTO.castingTime ?? "")")
                        .padding()
                    Text("Concentration: \(viewModel.filledSpellDTO.concentration ?? false ? "true" : "false")")
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
        SpellDetailView()
    }
}
