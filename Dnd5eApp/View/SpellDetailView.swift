//
//  SpellDetailView.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 12.05.2020.
//  Copyright © 2020 Ievgen. All rights reserved.
//

import SwiftUI

struct SpellDetailView: View {

    var dataLayer: DataLayer?
    @State var spell: SpellDTO

    var body: some View {
        NavigationView {
            VStack {
                Image("scroll").padding()
                Text("Level: \(spell.level ?? 0)").padding()
                Text("Description: \(spell.description ?? "")").padding()
                Text("Casting time: \(spell.castingTime ?? "")").padding()
                Text("Concentration: \(spell.concentration ?? false ? "true" : "false")").padding()
            }
            .padding()
            .onAppear(perform: loadData)
        }
        .navigationBarTitle("Spell Details", displayMode: .inline)
    }

    // MARK: - Loading
    private func loadData() {
        dataLayer?.retrieveSpellDetails(self.spell, completionHandler: { (result, error) in
            if let spell = result {
                self.spell = spell
            }
        })
    }
}

struct SpellDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SpellDetailView(spell: SpellDTO(name: "name", path: "path", level: 1, description: "description", castingTime: "1 action", concentration: false))
    }
}
