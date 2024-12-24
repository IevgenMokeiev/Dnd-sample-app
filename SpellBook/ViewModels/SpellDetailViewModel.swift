//
//  SpellDetailViewModel.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 14.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import SwiftUI

enum SpellDetailState {
    case loading
    case spell(SpellDTO)
    case error
}

@MainActor
class SpellDetailViewModel: ObservableObject {
    @Published var state: SpellDetailState = .loading

    private let interactor: InteractorProtocol
    private let path: String

    init(interactor: InteractorProtocol, path: String) {
        self.interactor = interactor
        self.path = path
    }

    var favoriteButtonText: String {
        if case let .spell(spellDTO) = state {
            return spellDTO.isFavorite ? "Remove from Favorites" : "Add to Favorites"
        } else {
            return ""
        }
    }

    func toggleFavorite() {
        if case let .spell(spellDTO) = state {
            let newDTO = spellDTO.toggleFavorite(value: !spellDTO.isFavorite)
            state = .spell(newDTO)
            Task {
                await saveSpell(spellDTO: newDTO)
            }
        }
    }

    func onAppear() async {
        do {
            state = .spell(try await interactor.getSpellDetails(for: path))
        } catch {
            state = .error
        }
    }
    
    private func saveSpell(spellDTO: SpellDTO) async {
        try? await interactor.saveSpell(spellDTO)
    }
}
