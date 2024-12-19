//
//  SpellDetailViewModel.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 14.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

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
            saveBlock(newDTO)
        }
    }

    func onAppear() {
        publisher
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    print("\(error)")
                    self.state = .error
                }
            }, receiveValue: { spellDTO in
                self.state = .spell(spellDTO)
            })
            .store(in: &cancellableSet)
    }
}
