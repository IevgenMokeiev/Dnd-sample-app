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

    @ObservedObject var viewModel: AddSpellViewModel = AddSpellViewModel()
    @State var addDisabled: Bool = true
    @State private var showingAlert = false

    var body: some View {
        NavigationView {
            VStack {
                Image("scroll-add")
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
                AddSpellEntry(title: "Name: ", enteredText: $viewModel.name)
                AddSpellEntry(title: "Level: ", enteredText: $viewModel.level)
                AddSpellEntry(title: "Casting Time: ", enteredText: $viewModel.castingTime)
                AddSpellEntry(title: "Concentration: ", enteredText: $viewModel.concentration)
                AddSpellEntry(title: "Description: ", enteredText: $viewModel.description)
                AddSpellEntry(title: "Classes: ", enteredText: $viewModel.classes)
                AddSpellEntry(title: "Higher Level: ", enteredText: $viewModel.higherLevel)
            }
            .navigationBarTitle("Add Spell", displayMode: .inline)
            .navigationBarItems(trailing:
                Button("Add") {
                    self.add()
                }
                .foregroundColor(addDisabled ? .red : .orange)
                .disabled(addDisabled)
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Message"), message: Text("Spell Added"), dismissButton: .default(Text("Got it!")))
                }
            )
            .onReceive(viewModel.buttonEnabled, perform: validateButton)
        }
    }

    private func add() {
        store.send(.addSpell(viewModel.spellDTO))
        showingAlert = true
    }

    private func validateButton(_ value: Bool) {
        addDisabled = !value
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
