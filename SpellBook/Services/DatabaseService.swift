//
//  DatabaseService.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 4/19/19.
//  Copyright © 2019 Yevhen Mokeiev. All rights reserved.
//

import Combine
import CoreData
import Foundation

import Combine
import CoreData
import Foundation

typealias SaveBlock = (SpellDTO) -> Void

/// Service responsible for database communication
protocol DatabaseService {
    var spellListPublisher: SpellListPublisher { get }
    var favoritesPublisher: NoErrorSpellListPublisher { get }
    func spellDetailsPublisher(for path: String) -> SpellDetailPublisher
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

    var spellListPublisher: SpellListPublisher {
        databaseClient.fetchRecords(expectedType: Spell.self, predicate: nil)
            .map { self.translationService.convertToDTO(spellList: $0) }
            .eraseToAnyPublisher()
    }

    var favoritesPublisher: NoErrorSpellListPublisher {
        databaseClient.fetchRecords(
            expectedType: Spell.self,
            predicate: NSPredicate(format: "isFavorite == true")
        )
        .map { self.translationService.convertToDTO(spellList: $0) }
        .replaceError(with: [])
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
            .mapError {
                switch $0 {
                case let error as CustomError:
                    return error
                default:
                    return CustomError.other($0)
                }
            }
            .eraseToAnyPublisher()
    }

    func saveSpellList(_ spellDTOs: [SpellDTO]) {
        for spell in spellDTOs {
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
            .sink(receiveCompletion: { _ in
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

extension Publisher where Output == [SpellDTO] {
    func cacheOutput(service: DatabaseService) -> AnyPublisher<Self.Output, Self.Failure> {
        map {
            service.saveSpellList($0)
            return $0
        }
        .eraseToAnyPublisher()
    }
}

extension Publisher where Output == SpellDTO {
    func cacheOutput(service: DatabaseService) -> AnyPublisher<Self.Output, Self.Failure> {
        map {
            service.saveSpellDetails($0)
            return $0
        }
        .eraseToAnyPublisher()
    }
}
