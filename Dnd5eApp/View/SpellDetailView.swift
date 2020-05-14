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
    
    var dataLayer: DataLayer?
    @State var spell: SpellDTO
    @State var loading: Bool = true

    @State var bag = Set<AnyCancellable>()

    var body: some View {
        NavigationView {
            if self.loading {
                ProgressView(isAnimating: $loading)
                    .onAppear(perform: loadData)
            } else {
                VStack {
                    Text("\(spell.name)")
                        .fontWeight(.bold)
                    Image("scroll").padding()
                    Text("Level: \(spell.level ?? 0)")
                        .fontWeight(.bold)
                        .padding()
                    Text("Description: \(spell.description ?? "")")
                        .padding()
                    Text("Casting time: \(spell.castingTime ?? "")")
                        .padding()
                    Text("Concentration: \(spell.concentration ?? false ? "true" : "false")")
                        .padding()
                }
                .padding()
            }
        }
        .navigationBarTitle("Spell Details", displayMode: .inline)
    }

    // MARK: - Loading
    private func loadData() {
        dataLayer?.retrieveSpellDetails(spell: self.spell)
        .sink(receiveCompletion: { _ in
        }, receiveValue: { spell in
            self.spell = spell
            self.loading = false
        })
        .store(in: &bag)
    }
}

struct SpellDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SpellDetailView(spell: SpellDTO(name: "name", path: "path", level: 1, description: "description", castingTime: "1 action", concentration: false), loading: false)
    }
}
