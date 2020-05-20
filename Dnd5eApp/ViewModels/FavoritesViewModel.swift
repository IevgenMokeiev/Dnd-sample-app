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
    private let publisher: SpellPublisher
    private var cancellableSet: Set<AnyCancellable> = []

    init(publisher: SpellPublisher, spellDetailViewConstructor: @escaping SpellDetailViewConstructor) {
        self.publisher = publisher
        self.spellDetailViewConstructor = spellDetailViewConstructor
    }

    func onAppear() {
        publisher
            .replaceError(with: [])
            .assign(to: \.spellDTOs, on: self)
            .store(in: &cancellableSet)
    }
}
