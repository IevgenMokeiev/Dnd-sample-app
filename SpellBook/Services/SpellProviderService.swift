//
//  SpellProviderService.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 25.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation

/// Service responsible for data providing
/// If data is requested, tries to get it from the database service
/// If it's not available, fallback to network service
protocol SpellProviderService {
  func spellListPublisher() -> SpellListPublisher
  func spellDetailsPublisher(for path: String) -> SpellDetailPublisher
  func favoritesPublisher() -> NoErrorSpellListPublisher
  func saveSpellDetails(_ spellDTO: SpellDTO)
  func createSpell(_ spellDTO: SpellDTO)
}

class SpellProviderServiceImpl: SpellProviderService {
  
  let databaseService: DatabaseService
  let networkService: NetworkService
  
  init(databaseService: DatabaseService, networkService: NetworkService) {
    self.databaseService = databaseService
    self.networkService = networkService
  }
  
  func spellListPublisher() -> SpellListPublisher {
    return databaseService.spellListPublisher()
      .catch { (error) -> SpellListPublisher in
        print("Could not retrieve. \(error)")
        
        let downloadPublisher = self.networkService.spellListPublisher()
          .receive(on: RunLoop.main)
          .map { (spellDTOs) -> [SpellDTO] in
            self.databaseService.saveSpellList(spellDTOs)
            return spellDTOs
          }
          .eraseToAnyPublisher()
        
        return downloadPublisher
      }
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }
  
  func spellDetailsPublisher(for path: String) -> SpellDetailPublisher {
    return databaseService.spellDetailsPublisher(for: path)
      .catch { error -> SpellDetailPublisher in
        print("Could not retrieve. \(error)")
        let downloadPublisher = self.networkService.spellDetailPublisher(for: path)
          .receive(on: RunLoop.main)
          .map { (spellDTO) -> SpellDTO in
            self.databaseService.saveSpellDetails(spellDTO)
            return spellDTO
          }
          .eraseToAnyPublisher()
        
        return downloadPublisher
      }
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }
  
  func favoritesPublisher() -> NoErrorSpellListPublisher {
    return databaseService.favoritesPublisher()
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }
  
  func saveSpellDetails(_ spellDTO: SpellDTO) {
    databaseService.saveSpellDetails(spellDTO)
  }
  
  func createSpell(_ spellDTO: SpellDTO) {
    databaseService.createSpell(spellDTO)
  }
}
