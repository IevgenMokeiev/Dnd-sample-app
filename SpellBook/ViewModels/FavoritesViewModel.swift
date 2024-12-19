//
//  FavoritesViewModel.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 20.05.2020.
//  Copyright © 2020 Ievgen. All rights reserved.
//

import Combine
import Foundation

class FavoritesViewModel: ObservableObject {
    @Published var spellDTOs: [SpellDTO] = []

    private let publisher: NoErrorSpellListPublisher
    private var cancellableSet: Set<AnyCancellable> = []

    init(publisher: NoErrorSpellListPublisher) {
        self.publisher = publisher
    }

    func onAppear() {
        publisher
            .replaceError(with: [])
            .assign(to: \.spellDTOs, on: self)
            .store(in: &cancellableSet)
    }
}
