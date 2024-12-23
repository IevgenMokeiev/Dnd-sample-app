//
//  DatabaseClient.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 22.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import SwiftData
import UIKit

enum DatabaseClientError: Error {
    case noMatchedEntity
    case modelActor(BackgroundModelActorError)
}

protocol DatabaseClient: Sendable {
    func fetchRecords(predicate: Predicate<Spell>?) async throws -> [SpellDTO]
    func createRecord(spellDTO: SpellDTO) async throws
    func updateRecord(predicate: Predicate<Spell>?, spellDTO: SpellDTO) async throws
    func save() async
}

@available(iOS 17, *)
final class DatabaseClientImpl: DatabaseClient {
    private let modelContainer: ModelContainer
    private let modelActor: BackgroundModelActor

    init() throws {
        modelContainer = try ModelContainer(for: Spell.self)
        modelActor = BackgroundModelActor(modelContainer: modelContainer)
    }

    func fetchRecords(predicate: Predicate<Spell>?) async throws -> [SpellDTO] {
        try await modelActor.fetchSpellList(predicate: predicate)
    }
    
    func updateRecord(predicate: Predicate<Spell>?, spellDTO: SpellDTO) async throws {
        try await modelActor.updateSpell(predicate: predicate, spellDTO: spellDTO)
    }
    
    func createRecord(spellDTO: SpellDTO) async throws {
        try await modelActor.createSpell(spellDTO: spellDTO)
    }
    
    func save() async {
        try? await modelActor.save()
    }
}
