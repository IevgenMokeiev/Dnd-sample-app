//
//  SpellListView.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 08.05.2020.
//  Copyright © 2020 Ievgen. All rights reserved.
//

import SwiftUI

enum ViewState {
    case loading
    case displayingSpells
}

struct SpellListView: View {

    @State var viewState: ViewState = .loading

    var spells: [Spell] = []

    var body: some View {
        VStack {
            Text("Spell Book")
            List(spells) { spell in
                Text(spell.te)
            }
        }
    }
}

struct SpellListView_Previews: PreviewProvider {
    static var previews: some View {
        SpellListView()
    }
}
