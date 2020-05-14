//
//  SpellDetailViewModel.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 14.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import Combine

class SpellDetailViewModel: ObservableObject {

    @Published var spellDTO: [SpellDTO] = []

    private let publisher: AnyPublisher<SpellDTO, Error>
    private var cancellableSet: Set<AnyCancellable> = []

    init(publisher: AnyPublisher<SpellDTO, Error>) {
        self.publisher = publisher
    }

    func onAppear() {
        let _ = publisher
        .assertNoFailure()
        .assign(to: \.spellDTO, on: self)
        .store(in: &cancellableSet)
    }
}

