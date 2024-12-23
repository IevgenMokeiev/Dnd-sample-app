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

    private let interactor: InteractorProtocol
    private var cancellableSet: Set<AnyCancellable> = []

    init(interactor: InteractorProtocol) {
        self.interactor = interactor
    }

    @MainActor
    func onAppear() {
        Task {
            let favorites = try? await interactor.getFavorites()
            self.spellDTOs = favorites ?? []
        }
    }
}
