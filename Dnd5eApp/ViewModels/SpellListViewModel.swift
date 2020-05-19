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
            search()
        }
    }

    @Published var selectedSort: Sort = .name {
        didSet {
            search()
        }
    }

    let spellDetailConstructor: SpellDetailConstructor

    private let publisherConstructor: SpellListPublisherConstructor
    private var activePublisher: SpellListPublisher?
    private var cancellableSet: Set<AnyCancellable> = []

    init(publisherConstructor: @escaping SpellListPublisherConstructor, spellDetailConstructor: @escaping SpellDetailConstructor) {
        self.publisherConstructor = publisherConstructor
        self.spellDetailConstructor = spellDetailConstructor
    }

    func onAppear() {
        search()
    }

    private func search() {
        let publisher = publisherConstructor(searchTerm, selectedSort)
        activePublisher = publisher
        publisher
            .replaceError(with: [])
            .assign(to: \.spellDTOs, on: self)
            .store(in: &cancellableSet)
    }
}

