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
    private let saveClosure: SaveClosure

    init(interactor: InteractorProtocol, path: String, saveClosure: @escaping SaveClosure) {
        self.interactor = interactor
        self.path = path
        self.saveClosure = saveClosure
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
            saveClosure(newDTO)
        }
    }

    func onAppear() {
        Task {
            do {
                let spellDTO = try await interactor.getSpellDetails(for: self.path)
                self.state = .spell(spellDTO)
            } catch {
                self.state = .error
            }
        }
    }
}
