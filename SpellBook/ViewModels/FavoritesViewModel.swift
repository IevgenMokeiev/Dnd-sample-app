//
//  FavoritesViewModel.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 20.05.2020.
//  Copyright © 2020 Ievgen. All rights reserved.
//

import Foundation

@MainActor
class FavoritesViewModel: ObservableObject {
    @Published var spellDTOs: [SpellDTO] = []

    private let interactor: InteractorProtocol

    init(interactor: InteractorProtocol) {
        self.interactor = interactor
    }

    func onAppear() async {
        spellDTOs = (try? await interactor.getFavorites()) ?? []
    }
}
