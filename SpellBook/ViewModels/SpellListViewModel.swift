//
//  SpellListViewModel.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 14.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import Combine

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
    private let publisherConstructor: SpellPublisherConstructor
    private var cancellableSet: Set<AnyCancellable> = []

    init(publisherConstructor: @escaping SpellPublisherConstructor, refinementsBlock: @escaping RefinementsBlock) {
        self.publisherConstructor = publisherConstructor
        self.refinementsBlock = refinementsBlock
    }

    func onAppear() {
        publisherConstructor()
            .sink(receiveCompletion: { completion in
                switch completion {
                case.finished:
                    break
                case .failure(let error):
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

