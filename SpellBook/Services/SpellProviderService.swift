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
    var spellListPublisher: SpellListPublisher { get }
    var favoritesPublisher: NoErrorSpellListPublisher { get }
    func spellDetailsPublisher(for path: String) -> SpellDetailPublisher
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
    
    var spellListPublisher: SpellListPublisher {
        
        let downloadPublisher = networkService.spellListPublisher
            .cacheOutput(service: databaseService)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
        
        return databaseService.spellListPublisher
            .fallback(downloadPublisher)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    var favoritesPublisher: NoErrorSpellListPublisher {
        return databaseService.favoritesPublisher
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func spellDetailsPublisher(for path: String) -> SpellDetailPublisher {
        
        let downloadPublisher = networkService.spellDetailPublisher(for: path)
            .cacheOutput(service: databaseService)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
        
        return databaseService.spellDetailsPublisher(for: path)
            .fallback(downloadPublisher)
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

