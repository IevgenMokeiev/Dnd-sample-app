//
//  FavoritesViewModel.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 20.05.2020.
//  Copyright © 2020 Ievgen. All rights reserved.
//

import Foundation
import Combine

class FavoritesViewModel: ObservableObject {

    @Published var spellDTOs: [SpellDTO] = []

    let spellDetailViewConstructor: SpellDetailViewConstructor
    
    func onAppear() {
    }

    init(spellDetailViewConstructor: @escaping SpellDetailViewConstructor) {
        self.spellDetailViewConstructor = spellDetailViewConstructor
    }
}
