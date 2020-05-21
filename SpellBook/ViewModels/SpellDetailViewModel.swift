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

class SpellDetailViewModel: ObservableObject {

    @Published var spellDTO: SpellDTO = SpellDTO.placeholder {
        didSet {
            loading = false
        }
    }
    @Published var loading: Bool = true

    private let publisher: SpellDetailPublisher
    private let saveBlock: SaveBlock
    private var cancellableSet: Set<AnyCancellable> = []

    init(publisher: SpellDetailPublisher, saveBlock: @escaping SaveBlock) {
        self.publisher = publisher
        self.saveBlock = saveBlock
    }

    var favoriteButtonText: String {
        spellDTO.isFavorite ? "Remove from Favorites" : "Add to Favorites"
    }

    func toggleFavorite() {
        spellDTO.isFavorite = !spellDTO.isFavorite
        saveBlock(spellDTO)
    }

    func onAppear() {
        publisher
            .replaceError(with: SpellDTO.placeholder)
            .assign(to: \.spellDTO, on: self)
            .store(in: &cancellableSet)
    }
}

