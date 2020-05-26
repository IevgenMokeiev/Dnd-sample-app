//
//  FakeSpellProviderService.swift
//  SpellBookTests
//
//  Created by Yevhen Mokeiev on 25.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

@testable import SpellBook

class FakeSpellProviderService: SpellProviderService {

    static var spellListHandler: (() -> Result<[SpellDTO], Error>)?
    static var spellDetailHandler: (() -> Result<SpellDTO, Error>)?
    static var favoritesHandler: (() -> Result<[SpellDTO], Never>)?

    func spellListPublisher() -> SpellPublisher {
        guard let handler = Self.spellListHandler else {
            fatalError("Handler is unavailable.")
        }
        return Result.Publisher(handler()).eraseToAnyPublisher()
    }

    func spellDetailsPublisher(for path: String) -> SpellDetailPublisher {
        guard let handler = Self.spellDetailHandler else {
            fatalError("Handler is unavailable.")
        }
        return Result.Publisher(handler()).eraseToAnyPublisher()
    }

    func favoritesPublisher() -> FavoritesPublisher {
        guard let handler = Self.favoritesHandler else {
            fatalError("Handler is unavailable.")
        }
        return Result.Publisher(handler()).eraseToAnyPublisher()
    }

    func saveSpellDetails(_ spellDTO: SpellDTO) {
    }
}
