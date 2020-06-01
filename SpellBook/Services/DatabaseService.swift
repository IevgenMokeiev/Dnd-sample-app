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

typealias DatabaseSpellPublisher = AnyPublisher<[SpellDTO], DatabaseClientError>
typealias DatabaseSpellDetailPublisher = AnyPublisher<SpellDTO, Error>
typealias DatabaseFavoritesPublisher = AnyPublisher<[SpellDTO], Never>

/// Service responsible for database communication
protocol DatabaseService {
    func spellListPublisher() -> DatabaseSpellPublisher
    func spellDetailsPublisher(for path: String) -> DatabaseSpellDetailPublisher
    func favoritesPublisher() -> DatabaseFavoritesPublisher
    func saveSpellList(_ spellDTOs: [SpellDTO])
    func saveSpellDetails(_ spellDTO: SpellDTO)
}

class DatabaseServiceImpl: DatabaseService {
    
    private var databaseClient: DatabaseClient
    private var translationService: TranslationService
    private var cancellableSet: Set<AnyCancellable> = []
    
    init(databaseClient: DatabaseClient, translationService: TranslationService) {
        self.databaseClient = databaseClient
        self.translationService = translationService
    }
    
    func spellListPublisher() -> DatabaseSpellPublisher {
        return databaseClient.fetchRecords(expectedType: Spell.self, predicate: nil)
            .map { self.translationService.convertToDTO(spellList: $0) }
            .eraseToAnyPublisher()
    }
    
    func spellDetailsPublisher(for path: String) -> DatabaseSpellDetailPublisher {
        let predicate = NSPredicate(format: "path == %@", path)
        return databaseClient.fetchRecords(expectedType: Spell.self, predicate: predicate)
            .tryMap { spells in
                if let spell = spells.first, spell.desc != nil {
                    return self.translationService.convertToDTO(spell: spell)
                } else {
                    throw DatabaseClientError.noMatchedEntity
                }
            }
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
    
    func favoritesPublisher() -> DatabaseFavoritesPublisher {
        return databaseClient.fetchRecords(expectedType: Spell.self, predicate: NSPredicate(format: "isFavorite == true"))
            .map { self.translationService.convertToDTO(spellList: $0) }
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
}
