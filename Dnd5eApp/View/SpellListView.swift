//
//  SpellListView.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 08.05.2020.
//  Copyright © 2020 Ievgen. All rights reserved.
//

import SwiftUI

struct SpellListView: View {

    @State var contentManagerService: ContentManagerService?
    @State var spells: [SpellDTO] = []

    var body: some View {
        NavigationView {
            VStack {
                Text("Spell Book")
                List(spells) { spell in
                    Text(spell.name ?? "")
                }.onAppear(perform: loadData)
            }
        }.onAppear {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            self.contentManagerService = appDelegate.contentManagerService
        }
    }

    // MARK: - Loading
    private func loadData() {
        contentManagerService?.retrieveSpellList { (result, error) in
            self.spells = result ?? []
        }
    }
}

struct SpellListView_Previews: PreviewProvider {
    static var previews: some View {
        SpellListView()
    }
}
