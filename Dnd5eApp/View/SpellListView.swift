//
//  SpellListView.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 08.05.2020.
//  Copyright © 2020 Ievgen. All rights reserved.
//

import SwiftUI

struct SpellListView: View {

    var dataLayer: DataLayer?
    @State var spells: [SpellDTO] = []

    var body: some View {
        NavigationView {
            List(spells) { spell in
                NavigationLink(destination: SpellDetailView(dataLayer: self.dataLayer, spell: spell)) {
                    Text(spell.name)
                }
            }
            .accessibility(identifier: "SpellTableView")
            .onAppear(perform: loadData)
            .navigationBarTitle("Spell Book", displayMode: .inline)
        }
    }

    // MARK: - Loading
    private func loadData() {
        dataLayer?.retrieveSpellList { (result, error) in
            self.spells = result ?? []
        }
    }
}

struct SpellListView_Previews: PreviewProvider {
    static var previews: some View {
        let translationServiceImpl = TranslationServiceImpl()
        let databaseServiceImpl = DatabaseServiceImpl(translationService: translationServiceImpl)
        let networkserviceImpl = NetworkServiceImpl()
        let dataLayer = DataLayerImpl(databaseService: databaseServiceImpl, networkService: networkserviceImpl, translationService: translationServiceImpl)
        return SpellListView(dataLayer: dataLayer)
    }
}
