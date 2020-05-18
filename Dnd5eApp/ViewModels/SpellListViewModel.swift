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

    @Published var spellDTOs: [SpellDTO] = []

    @Published var searchTerm: String = "" {
        didSet {
            searchTermPublisher = filteredSpellListPublisher(for: publisher, by: searchTerm)
            searchTermPublisher?
                .replaceError(with: [])
                .assign(to: \.spellDTOs, on: self)
                .store(in: &cancellableSet)
        }
    }

    private var searchTermPublisher: AnyPublisher<[SpellDTO], Error>?
    private let publisher: AnyPublisher<[SpellDTO], Error>
    private var cancellableSet: Set<AnyCancellable> = []

    init(publisher: AnyPublisher<[SpellDTO], Error>) {
        self.publisher = publisher
    }

    func onAppear() {
        publisher
            .replaceError(with: [])
            .assign(to: \.spellDTOs, on: self)
            .store(in: &cancellableSet)
    }

    // TODO: - Move those to another place
    func filteredSpellListPublisher(for publisher: AnyPublisher<[SpellDTO], Error>, by searchTerm: String) -> AnyPublisher<[SpellDTO], Error> {
        return publisher
            .map { self.filteredSpells(spells: $0, by: searchTerm) }
            .eraseToAnyPublisher()
    }

    func filteredSpells(spells: [SpellDTO], by searchTerm: String) -> [SpellDTO] {
        if searchTerm.isEmpty {
            return spells
        } else {
            return spells.filter { $0.name.starts(with: searchTerm) }
        }
    }
}

