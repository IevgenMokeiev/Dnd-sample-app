//
//  SpellListViewModel.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 14.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import Combine

enum State {
    case loading
    case spells([SpellDTO])
}

class SpellListViewModel: ObservableObject {

    @Published var state: State = .loading

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
    private let publisherConstructor: SpellPublisherConstructor
    private var cancellableSet: Set<AnyCancellable> = []

    init(publisherConstructor: @escaping SpellPublisherConstructor, refinementsBlock: @escaping RefinementsBlock, spellDetailViewConstructor: @escaping SpellDetailViewConstructor) {
        self.publisherConstructor = publisherConstructor
        self.refinementsBlock = refinementsBlock
        self.spellDetailViewConstructor = spellDetailViewConstructor
    }

    func onAppear() {
        publisherConstructor()
            .replaceError(with: [])
            .assign(to: \.spellDTOs, on: self)
            .store(in: &cancellableSet)
    }

    private func refineSpells() {
        state = .spells(refinementsBlock(spellDTOs, selectedSort, searchTerm))
    }
}

