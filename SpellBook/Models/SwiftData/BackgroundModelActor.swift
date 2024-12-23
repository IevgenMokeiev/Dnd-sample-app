//
//  BackgroundModelActor.swift
//  SpellBook
//
//  Created by Eugene Mokeiev on 23.12.2024.
//  Copyright © 2024 Ievgen. All rights reserved.
//

import Foundation
import SwiftData

enum BackgroundModelActorError: Error {
    case noData
    case fetchFailed(Error)
    case contextNotSaved
}

@ModelActor
actor BackgroundModelActor {
    private var context: ModelContext { modelExecutor.modelContext }
    
    func fetchSpellList(predicate: Predicate<Spell>?) throws -> [SpellDTO] {
        let spells = try fetchSpells(predicate: predicate)
        return spells.map { $0.convertToDTO() }
    }
    
    func createSpell(spellDTO: SpellDTO) throws {
        modelContext.insert(Spell(with: spellDTO))
    }
    
    func updateSpell(predicate: Predicate<Spell>?, spellDTO: SpellDTO)  throws {
        let spells = try fetchSpells(predicate: predicate)
        guard let spell = spells.first else {
            throw BackgroundModelActorError.noData
        }
        spell.populate(with: spellDTO)
    }
    
    func save() throws {
        do {
            try context.save()
        } catch {
            throw BackgroundModelActorError.contextNotSaved
        }
    }
    
    // MARK: - Private
    
    private func fetchSpells(predicate: Predicate<Spell>?) throws -> [Spell] {
        var spells = FetchDescriptor<Spell>(
            predicate: predicate,
            sortBy: [
                .init(\.name)
            ]
        )
        spells.fetchLimit = 400
        spells.includePendingChanges = true

        do {
            let fetchResult = try context.fetch(spells)
            if fetchResult.isEmpty {
                throw BackgroundModelActorError.noData
            } else {
                return fetchResult
            }
        } catch let error as NSError {
            throw BackgroundModelActorError.fetchFailed(error)
        }
    }
}
