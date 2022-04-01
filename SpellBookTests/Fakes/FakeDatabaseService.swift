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
  static var favoritesHandler: (() -> Result<[SpellDTO], Never>)?
  
  func spellListPublisher() -> DatabaseSpellPublisher {
    guard let handler = Self.spellListHandler else {
      fatalError("Handler is unavailable.")
    }
    return Result.Publisher(handler()).eraseToAnyPublisher()
  }
  
  func spellDetailsPublisher(for path: String) -> DatabaseSpellDetailPublisher {
    guard let handler = Self.spellDetailHandler else {
      fatalError("Handler is unavailable.")
    }
    return Result.Publisher(handler()).eraseToAnyPublisher()
  }
  
  func favoritesPublisher() -> DatabaseFavoritesPublisher {
    guard let handler = Self.favoritesHandler else {
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

