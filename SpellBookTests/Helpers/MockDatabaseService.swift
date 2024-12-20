//
//  MockDatabaseService.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 22.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

@testable import SpellBook

class MockDatabaseService: DatabaseService {
    var spellListHandler: (() -> Result<[SpellDTO], CustomError>)?
    var spellDetailHandler: (() -> Result<SpellDTO, CustomError>)?
    var favoritesHandler: (() -> Result<[SpellDTO], Never>)?

    var spellListPublisher: SpellListPublisher {
        guard let spellListHandler else {
            fatalError("Handler is unavailable.")
        }
        return Result.Publisher(spellListHandler()).eraseToAnyPublisher()
    }

    var favoritesPublisher: NoErrorSpellListPublisher {
        guard let favoritesHandler else {
            fatalError("Handler is unavailable.")
        }
        return Result.Publisher(favoritesHandler()).eraseToAnyPublisher()
    }

    func spellDetailsPublisher(for _: String) -> SpellDetailPublisher {
        guard let spellDetailHandler else {
            fatalError("Handler is unavailable.")
        }
        return Result.Publisher(spellDetailHandler()).eraseToAnyPublisher()
    }

    func saveSpellList(_: [SpellDTO]) {}

    func saveSpellDetails(_: SpellDTO) {}

    func createSpell(_: SpellDTO) {}
}
