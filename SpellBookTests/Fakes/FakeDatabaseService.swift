//
//  FakeDatabaseService.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 22.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

@testable import SpellBook

class FakeDatabaseService: DatabaseService {
    static var spellListHandler: (() -> Result<[SpellDTO], CustomError>)?
    static var spellDetailHandler: (() -> Result<SpellDTO, CustomError>)?
    static var favoritesHandler: (() -> Result<[SpellDTO], Never>)?
    
    var spellListPublisher: SpellListPublisher {
        guard let handler = Self.spellListHandler else {
            fatalError("Handler is unavailable.")
        }
        return Result.Publisher(handler()).eraseToAnyPublisher()
    }
    
    var favoritesPublisher: NoErrorSpellListPublisher {
        guard let handler = Self.favoritesHandler else {
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
    
    func saveSpellList(_ spellDTOs: [SpellDTO]) {
    }
    
    func saveSpellDetails(_ spellDTO: SpellDTO) {
    }
    
    func createSpell(_ spellDTO: SpellDTO) {
    }
}

