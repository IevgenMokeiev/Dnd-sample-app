//
//  DataLayer.swift
//  Dnd5eApp
//
//  Created by Ievgen on 4/18/19.
//  Copyright © 2019 Ievgen. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol DataLayer {
    func retrieveSpellList(_ completionHandler: @escaping (_ result: Result<[SpellDTO], Error>) -> Void)
    func retrieveSpellDetails(_ spell: SpellDTO, completionHandler: @escaping (_ result: Result<SpellDTO, Error>) -> Void)
}

class DataLayerImpl: DataLayer {
    private var isDownloaded: Bool = false
    private var databaseService: DatabaseService
    private var networkService: NetworkService

    init(databaseService: DatabaseService, networkService: NetworkService) {
        self.databaseService = databaseService
        self.networkService = networkService
    }
    
    func retrieveSpellList(_ completionHandler: @escaping (_ result: Result<[SpellDTO], Error>) -> Void) {
        let fetchResult = databaseService.fetchSpellList()
        switch fetchResult {
        case .success(let spellList):
            let sortedSpells = self.sortedSpells(spells: spellList)
            completionHandler(.success(sortedSpells))
        case .failure(_):
            // need to download the data first
            self.networkService.downloadSpellList { [weak self] downloadResult in
                guard let self = self else { return }

                switch downloadResult {
                case .success(let spellDTOs):
                    self.databaseService.saveDownloadedSpellList(spellDTOs)
                    let sortedSpells = self.sortedSpells(spells: spellDTOs)
                    completionHandler(.success(sortedSpells))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        }
    }
    
    func retrieveSpellDetails(_ spell: SpellDTO, completionHandler: @escaping (_ result: Result<SpellDTO, Error>) -> Void) {
        let fetchResult = databaseService.fetchSpell(by: spell.name)

        switch fetchResult {
        case .success(let spell):
           completionHandler(.success(spell))
        case .failure(_):
            // need to download the data first
            networkService.downloadSpell(with: spell.path) { [weak self] downloadResult in
                guard let self = self else { return }

                switch downloadResult {
                case .success(let spellDTO):
                    self.databaseService.saveDownloadedSpell(spellDTO)
                    completionHandler(.success(spellDTO))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        }
    }

    func sortedSpells(spells: [SpellDTO]) -> [SpellDTO] {
        return spells.sorted(by: { $0.name.caseInsensitiveCompare($1.name) == ComparisonResult.orderedAscending })
    }
}
