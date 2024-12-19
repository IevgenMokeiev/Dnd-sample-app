//
//  SpellListViewModel.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 14.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Combine
import Foundation

enum SpellListState {
    case loading
    case spells([SpellDTO])
    case error
}

class SpellListViewModel: ObservableObject {
    @Published var state: SpellListState = .loading

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

    private let refinementsBlock: RefinementsBlock
    private let publisher: SpellListPublisher
    private var cancellableSet: Set<AnyCancellable> = []

    init(
        publisher: SpellListPublisher,
        refinementsBlock: @escaping RefinementsBlock
    ) {
        self.publisher = publisher
        self.refinementsBlock = refinementsBlock
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
            }, receiveValue: { spellDTOs in
                self.spellDTOs = spellDTOs
            })
            .store(in: &cancellableSet)
    }

    private func refineSpells() {
        state = .spells(refinementsBlock(spellDTOs, selectedSort, searchTerm))
    }
}
