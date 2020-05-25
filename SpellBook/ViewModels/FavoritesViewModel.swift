//
//  FavoritesViewModel.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 20.05.2020.
//  Copyright © 2020 Ievgen. All rights reserved.
//

import Foundation
import Combine

class FavoritesViewModel: ObservableObject {

    @Published var spellDTOs: [SpellDTO] = []

    private let publisherConstructor: SpellPublisherConstructor
    private var cancellableSet: Set<AnyCancellable> = []

    init(publisherConstructor: @escaping SpellPublisherConstructor) {
        self.publisherConstructor = publisherConstructor
    }

    func onAppear() {
        publisherConstructor()
            .replaceError(with: [])
            .assign(to: \.spellDTOs, on: self)
            .store(in: &cancellableSet)
    }
}
