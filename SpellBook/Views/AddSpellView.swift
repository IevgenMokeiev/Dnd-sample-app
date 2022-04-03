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
  @State private var addButtonDisabled = true
  @State private var isShowingAlert = false
  
  var body: some View {
    NavigationView {
      VStack(alignment: .leading) {
        Image("scroll-add")
          .frame(maxWidth: .infinity, alignment: .center)
          .padding()
        AddSpellEntryView(title: "Name: ", enteredText: $viewModel.name)
        AddSpellEntryView(title: "Level: ", enteredText: $viewModel.level)
        AddSpellEntryView(title: "Casting Time: ", enteredText: $viewModel.castingTime)
        CheckMarkEntryView(title: "Concentration: ", isChecked: $viewModel.concentration)
        AddSpellEntryView(title: "Description: ", enteredText: $viewModel.description)
        AddSpellEntryView(title: "Classes: ", enteredText: $viewModel.classes)
        AddSpellEntryView(title: "Higher Level: ", enteredText: $viewModel.higherLevel)
      }
      .navigationBarTitle("Add Spell", displayMode: .inline)
      .navigationBarItems(
        trailing:Button("Add") {
          self.add()
        }
          .foregroundColor(addButtonDisabled ? .red : .orange)
          .disabled(addButtonDisabled)
          .alert(isPresented: $isShowingAlert) {
            Alert(
              title: Text("Message"),
              message: Text("Spell Added"),
              dismissButton: .default(Text("Got it!")
                                     )
            )
          }
      )
      .onReceive(viewModel.buttonEnabled, perform: validateButton)
    }
  }
  
  private func toggleCheckmark() {
    viewModel.concentration = !viewModel.concentration
  }
  
  private func add() {
    store.send(.addSpell(viewModel.spellDTO))
    isShowingAlert = true
  }
  
  private func validateButton(_ value: Bool) {
    addButtonDisabled = !value
  }
}

struct AddSpellEntryView: View {
  let title: String
  @Binding var enteredText: String
  
  var body: some View {
    HStack {
      Text(title)
      TextField("enter text...", text: $enteredText)
    }.padding()
  }
}

struct CheckMarkEntryView: View {
  let title: String
  @Binding var isChecked: Bool
  @State private var isEnabled: Bool = false
  
  var body: some View {
    HStack {
      Text(title)
      Button(action: {
        self.isEnabled.toggle()
        self.isChecked.toggle()
      }){
        Image(systemName: isEnabled ? "checkmark.square.fill" : "square")
          .foregroundColor(.orange)
      }
    }.padding()
  }
}

struct AddSpellView_Previews: PreviewProvider {
  static var previews: some View {
    let store = AppStore(
      initialState: AppState(
        spellListState: .initial,
        spellDetailState: .initial,
        favoritesState: .initial
      ),
      reducer: appReducer,
      environment: ServiceContainerImpl()
    )
    let factory = ViewFactory()
    return factory.createAddSpellView().environmentObject(store).environmentObject(factory)
  }
}
