//
//  SpellDetailView.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 12.05.2020.
//  Copyright © 2020 Ievgen. All rights reserved.
//

import SwiftUI

struct SpellDetailView: View {

    var contentManagerService: ContentManagerService?
    @State var spell: SpellDTO?

    var body: some View {
        NavigationView {
            VStack {
                Text("Level: \(spell?.level ?? 0)").padding()
                Text("Description: \(spell?.description ?? "")").padding()
                Text("Casting time: \(spell?.castingTime ?? "")").padding()
                Text("Concentration: \(spell?.concentration ?? false ? "true" : "false")").padding()
            }
            .padding()
            .onAppear(perform: loadData)
        }
        .navigationBarTitle("Spell Details", displayMode: .inline)
    }

    // MARK: - Loading
    private func loadData() {
        contentManagerService?.retrieve(spell: self.spell, completionHandler: { (spell, error) in
            self.spell = spell
        })
    }
}

struct SpellDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SpellDetailView()
    }
}
