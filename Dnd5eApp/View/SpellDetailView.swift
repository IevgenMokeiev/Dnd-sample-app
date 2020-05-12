//
//  SpellDetailView.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 12.05.2020.
//  Copyright © 2020 Ievgen. All rights reserved.
//

import SwiftUI

struct SpellDetailView: View {

    @State var contentManagerService: ContentManagerService?
    @State var spell: SpellDTO?

    var body: some View {
        VStack {
            Text("Spell Details").foregroundColor(Color.purple)
            Text(spell?.name ?? "")
            Text(spell?.description ?? "")
        }.onAppear(perform: loadData)
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
