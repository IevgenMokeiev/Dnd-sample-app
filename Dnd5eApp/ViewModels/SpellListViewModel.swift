//
//  SpellListViewModel.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 14.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import Combine

class SpellListViewModel: ObservableObject {

    @Published var publishedSpellDTOs: [SpellDTO] = []

    var searchTerm: String = "" {
        didSet {
            refineSpells()
        }
    }

    var selectedSort: Sort = .name {
        didSet {
            refineSpells()
        }
    }

    private var spellDTOs: [SpellDTO] = [] {
        didSet {
            refineSpells()
        }
    }

    let spellDetailViewConstructor: SpellDetailViewConstructor

    private let refinementsBlock: RefinementsBlock
    private let publisher: SpellListPublisher
    private var cancellableSet: Set<AnyCancellable> = []

    init(publisher: SpellListPublisher, refinementsBlock: @escaping RefinementsBlock, spellDetailViewConstructor: @escaping SpellDetailViewConstructor) {
        self.publisher = publisher
        self.refinementsBlock = refinementsBlock
        self.spellDetailViewConstructor = spellDetailViewConstructor
    }

    func onAppear() {
        publisher
            .replaceError(with: [])
            .assign(to: \.spellDTOs, on: self)
            .store(in: &cancellableSet)
    }

    private func refineSpells() {
        publishedSpellDTOs = refinementsBlock(spellDTOs, selectedSort, searchTerm)
    }
}

