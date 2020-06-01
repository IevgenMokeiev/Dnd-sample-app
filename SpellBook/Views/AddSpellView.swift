//
//  AddSpellView.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 01.06.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import SwiftUI

struct AddSpellView: View {
    @EnvironmentObject var store: AppStore
    @EnvironmentObject var factory: ViewFactory

    @State var name: String = ""
    @State var level: String = ""
    @State var castingTime: String = ""
    @State var concentration: String = ""
    @State var classes: String = ""
    @State var description: String = ""
    @State var higherLevel: String = ""

    var body: some View {
        NavigationView {
            VStack {
                AddSpellEntry(title: "Name: ", enteredText: $name)
                AddSpellEntry(title: "Level: ", enteredText: $level)
                AddSpellEntry(title: "Casting Time: ", enteredText: $castingTime)
                AddSpellEntry(title: "Concentration: ", enteredText: $concentration)
                AddSpellEntry(title: "Classes: ", enteredText: $classes)
                AddSpellEntry(title: "Description: ", enteredText: $description)
                AddSpellEntry(title: "Higher Level: ", enteredText: $higherLevel)
            }
            .navigationBarTitle("Add Spell", displayMode: .inline)
            .navigationBarItems(trailing:
                Button("Add") {

                }.foregroundColor(.orange)
            )
        }
    }

    private func add() {
        let spellDTO = SpellDTO(name: name, path: "api/spells/" + name, level: Int(level), castingTime: castingTime, concentration: concentration == "true" ? true : false, classes: classes, description: description, higherLevel: higherLevel, isFavorite: false)
        store.send(.addSpell(spellDTO))
    }
}

struct AddSpellEntry: View {
    let title: String
    @Binding var enteredText: String
    var body: some View {
        HStack {
            Text(title)
            TextField("enter text...", text: $enteredText)
        }.padding()
    }
}

struct AddSpellView_Previews: PreviewProvider {
    static var previews: some View {
        let store = AppStore(initialState: AppState(spellListState: .initial, spellDetailState: .initial, favoritesState: .initial), reducer: appReducer, environment: ServiceContainerImpl())
        let factory = ViewFactory()
        return factory.createAddSpellView().environmentObject(store).environmentObject(factory)
    }
}
