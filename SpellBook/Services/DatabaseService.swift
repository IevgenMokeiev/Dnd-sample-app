//
//  DatabaseService.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 4/19/19.
//  Copyright © 2019 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import CoreData
import Combine

/// Service responsible for database communication
protocol DatabaseService {
  func spellListPublisher() -> SpellListPublisher
  func spellDetailsPublisher(for path: String) -> SpellDetailPublisher
  func favoritesPublisher() -> NoErrorSpellListPublisher
  func saveSpellList(_ spellDTOs: [SpellDTO])
  func saveSpellDetails(_ spellDTO: SpellDTO)
  func createSpell(_ spellDTO: SpellDTO)
}

class DatabaseServiceImpl: DatabaseService {
  
  private let databaseClient: DatabaseClient
  private let translationService: TranslationService
  private var cancellableSet: Set<AnyCancellable> = []
  
  init(databaseClient: DatabaseClient, translationService: TranslationService) {
    self.databaseClient = databaseClient
    self.translationService = translationService
  }
  
  func spellListPublisher() -> SpellListPublisher {
    return databaseClient.fetchRecords(expectedType: Spell.self, predicate: nil)
      .map { self.translationService.convertToDTO(spellList: $0) }
      .eraseToAnyPublisher()
  }
  
  func spellDetailsPublisher(for path: String) -> SpellDetailPublisher {
    let predicate = NSPredicate(format: "path == %@", path)
    return databaseClient
      .fetchRecords(expectedType: Spell.self, predicate: predicate)
      .tryMap { spells -> SpellDTO in
        if let spell = spells.first, spell.desc != nil {
          return self.translationService.convertToDTO(spell: spell)
        } else {
          throw CustomError.database(.noMatchedEntity)
        }
      }
      .mapError { $0.transformToCustom }
      .eraseToAnyPublisher()
  }
  
  func favoritesPublisher() -> NoErrorSpellListPublisher {
    return databaseClient.fetchRecords(expectedType: Spell.self, predicate: NSPredicate(format: "isFavorite == true"))
      .map { self.translationService.convertToDTO(spellList: $0) }
      .replaceError(with: [])
      .eraseToAnyPublisher()
  }
  
  func saveSpellList(_ spellDTOs: [SpellDTO]) {
    spellDTOs.forEach { (spell) in
      let spellEntity = databaseClient.createRecord(expectedType: Spell.self)
      spellEntity.name = spell.name
      spellEntity.path = spell.path
    }
    databaseClient.save()
  }
  
  func saveSpellDetails(_ spellDTO: SpellDTO) {
    let predicate = NSPredicate(format: "path == %@", spellDTO.path)
    databaseClient.fetchRecords(expectedType: Spell.self, predicate: predicate)
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { completion in
      }, receiveValue: { spells in
        let matchedSpell = spells.first
        matchedSpell?.populate(with: spellDTO)
        self.databaseClient.save()
      })
      .store(in: &cancellableSet)
  }
  
  func createSpell(_ spellDTO: SpellDTO) {
    let spellEntity = databaseClient.createRecord(expectedType: Spell.self)
    spellEntity.populate(with: spellDTO)
    databaseClient.save()
  }
}
