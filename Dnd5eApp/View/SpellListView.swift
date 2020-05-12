//
//  SpellListView.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 08.05.2020.
//  Copyright © 2020 Ievgen. All rights reserved.
//

import SwiftUI

struct SpellListView: View {

    var contentManagerService: ContentManagerService?
    @State var spells: [SpellDTO] = []

    var body: some View {
        NavigationView {
            VStack {
                List(spells) { spell in
                    NavigationLink(destination: SpellDetailView(contentManagerService: self.contentManagerService, spell: spell)) {
                        Text(spell.name ?? "")
                    }
                }
                .onAppear(perform: loadData)
            }
            .navigationBarTitle("Spell Book", displayMode: .inline)
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
        let coreDataServiceImpl = CoreDataServiceImpl()
        let contentDownloaderServiceImpl = ContentDownloaderServiceImpl()
        let contentManagerServiceImpl = ContentManagerServiceImpl(coreDataService: coreDataServiceImpl, contentDownloaderService: contentDownloaderServiceImpl)
        return SpellListView(contentManagerService: contentManagerServiceImpl)
    }
}
