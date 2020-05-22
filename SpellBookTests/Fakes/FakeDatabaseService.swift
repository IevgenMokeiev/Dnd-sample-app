//
//  FakeDatabaseService.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 22.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

@testable import SpellBook

class FakeDatabaseService: DatabaseService {

    static var spellListHandler: (() -> Result<[SpellDTO], DatabaseClientError>)?
    static var spellDetailHandler: (() -> Result<SpellDTO, Error>)?
    static var favoritesHandler: (() -> Result<[SpellDTO], DatabaseClientError>)?

    func spellListPublisher() -> DatabaseSpellPublisher {
        guard let handler = Self.spellListHandler else {
            fatalError("Handler is unavailable.")
        }
        let result = handler()
        return Result.Publisher(result).eraseToAnyPublisher()
    }

    func spellDetailsPublisher(for path: String) -> DatabaseSpellDetailPublisher {
        guard let handler = Self.spellDetailHandler else {
            fatalError("Handler is unavailable.")
        }
        let result = handler()
        return Result.Publisher(result).eraseToAnyPublisher()
    }

    func favoritesPublisher() -> DatabaseSpellPublisher {
        guard let handler = Self.favoritesHandler else {
            fatalError("Handler is unavailable.")
        }
        let result = handler()
        return Result.Publisher(result).eraseToAnyPublisher()
    }

    func saveSpellList(_ spellDTOs: [SpellDTO]) {
    }

    func saveSpellDetails(_ spellDTO: SpellDTO) {
    }
}

