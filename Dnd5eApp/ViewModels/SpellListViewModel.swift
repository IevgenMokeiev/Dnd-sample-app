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

    private let publisherConstructor: SpellListPublisherConstructor
    private var activePublisher: AnyPublisher<[SpellDTO], Error>?
    private var cancellableSet: Set<AnyCancellable> = []

    init(publisherConstructor: @escaping SpellListPublisherConstructor) {
        self.publisherConstructor = publisherConstructor
    }

    func onAppear() {
        search()
    }

    private func search() {
        let publisher = publisherConstructor(searchTerm)
        activePublisher = publisher
        publisher
            .replaceError(with: [])
            .assign(to: \.spellDTOs, on: self)
            .store(in: &cancellableSet)
    }
}

