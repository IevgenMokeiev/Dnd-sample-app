//
//  SpellDetailViewModel.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 14.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class SpellDetailViewModel: ObservableObject {

    @Published var spellDTO: SpellDTO = SpellDTO.placeholder {
        didSet {
            loading = false
        }
    }
    @Published var loading: Bool = true

    private let publisher: AnyPublisher<SpellDTO, Error>
    private var cancellableSet: Set<AnyCancellable> = []

    init(publisher: AnyPublisher<SpellDTO, Error>) {
        self.publisher = publisher
    }

    func onAppear() {
        publisher
            .replaceError(with: SpellDTO.placeholder)
            .assign(to: \.spellDTO, on: self)
            .store(in: &cancellableSet)
    }
}

