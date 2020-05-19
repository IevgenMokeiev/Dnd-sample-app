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

    private let publisher: SpellListPublisher
    private var cancellableSet: Set<AnyCancellable> = []

    init(publisher: SpellListPublisher, spellDetailViewConstructor: @escaping SpellDetailViewConstructor) {
        self.publisher = publisher
        self.spellDetailViewConstructor = spellDetailViewConstructor
    }

    func onAppear() {
        publisher
            .replaceError(with: [])
            .assign(to: \.spellDTOs, on: self)
            .store(in: &cancellableSet)
    }

    // MARK: - Private

    private func refineSpells() {
        let sortedDTOs = sortedSpells(spells: spellDTOs, sort: selectedSort)
        let filteredDTOs = filteredSpells(spells: sortedDTOs, by: searchTerm)
        
        publishedSpellDTOs = filteredDTOs
    }

    private func sortedSpells(spells: [SpellDTO], sort: Sort) -> [SpellDTO] {
        let sortRule: (SpellDTO, SpellDTO) -> Bool = {
            switch sort {
            case .name:
                return $0.name < $1.name
            case .level:
                return ($0.level ?? 0) < ($1.level ?? 0)
            }
        }

        return spells.sorted(by: sortRule)
    }

    func filteredSpells(spells: [SpellDTO], by searchTerm: String) -> [SpellDTO] {
        if searchTerm.isEmpty {
            return spells
        } else {
            return spells.filter { $0.name.contains(searchTerm) }
        }
    }
}

