//
//  SpellDetailViewModel.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 14.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

enum SpellDetailState {
    case loading
    case spell(SpellDTO)
    case error
}

class SpellDetailViewModel: ObservableObject {

    @Published var state: SpellDetailState = .loading

    private let publisher: SpellDetailPublisher
    private let saveBlock: SaveBlock
    private var cancellableSet: Set<AnyCancellable> = []

    init(publisher: SpellDetailPublisher, saveBlock: @escaping SaveBlock) {
        self.publisher = publisher
        self.saveBlock = saveBlock
    }

    var favoriteButtonText: String {
        if case .spell(let spellDTO) = state {
            return spellDTO.isFavorite ? "Remove from Favorites" : "Add to Favorites"
        } else {
            return ""
        }
    }

    func toggleFavorite() {
        if case .spell(var spellDTO) = state {
            spellDTO.isFavorite = !spellDTO.isFavorite
            state = .spell(spellDTO)
            saveBlock(spellDTO)
        }
    }

    func onAppear() {
        publisher
            .sink(receiveCompletion: { completion in
                switch completion {
                case.finished:
                    break
                case .failure(let error):
                    print("\(error)")
                    self.state = .error
                }
            }, receiveValue: { spellDTO in
                self.state = .spell(spellDTO)
            })
            .store(in: &cancellableSet)
    }
}

