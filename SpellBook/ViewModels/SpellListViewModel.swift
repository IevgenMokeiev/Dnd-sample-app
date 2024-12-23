//
//  SpellListViewModel.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 14.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation

enum SpellListState {
    case loading
    case spells([SpellDTO])
    case error
}

@MainActor
final class SpellListViewModel: ObservableObject {
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

    private let refinementsClosure: RefinementsClosure
    private let interactor: InteractorProtocol

    init(
        interactor: InteractorProtocol,
        refinementsClosure: @escaping RefinementsClosure
    ) {
        self.interactor = interactor
        self.refinementsClosure = refinementsClosure
    }

    func onAppear() {
        Task {
            do {
                let spellList = try await interactor.getSpellList()
                self.spellDTOs = spellList
            } catch {
                self.state = .error
            }
        }
    }

    private func refineSpells() {
        state = .spells(refinementsClosure(spellDTOs, selectedSort, searchTerm))
    }
}
