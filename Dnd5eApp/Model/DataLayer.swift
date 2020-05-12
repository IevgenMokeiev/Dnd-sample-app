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
    private var translationService: TranslationService

    init(databaseService: DatabaseService, networkService: NetworkService, translationService: TranslationService) {
        self.databaseService = databaseService
        self.networkService = networkService
        self.translationService = translationService
    }
    
    func retrieveSpellList(_ completionHandler: @escaping (_ result: Result<[SpellDTO], Error>) -> Void) {
        databaseService.fetchSpellList { [weak self] (fetchResult) in
            guard let self = self else { return }

            switch fetchResult {
            case .success(let spellList):
                let sortedSpells = self.sortedSpells(spells: spellList)
                completionHandler(.success(sortedSpells))
            case .failure(_):
                // need to download the data first
                self.networkService.downloadSpellList { [weak self] (downloadResult) in
                    guard let self = self else { return }

                    switch downloadResult {
                    case .success(let spellList):
                        let spellDTOs = self.translationService.convertToDTO(dictArray: spellList)
                        self.databaseService.saveDownloadedSpellList(spellDTOs)
                        let sortedSpells = self.sortedSpells(spells: spellDTOs)
                        completionHandler(.success(sortedSpells))
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                }
            }
        }
    }
    
    func retrieveSpellDetails(_ spell: SpellDTO, completionHandler: @escaping (_ result: Result<SpellDTO, Error>) -> Void) {
        networkService.downloadSpell(with: spell.path) { [weak self] (downloadResult) in
            guard let self = self else { return }

            switch downloadResult {
            case .success(let spell):
                let spellDTO = self.translationService.convertToDTO(dict: spell)
                self.databaseService.saveDownloadedSpell(spellDTO)
                completionHandler(.success(spellDTO))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }

    func sortedSpells(spells: [SpellDTO]) -> [SpellDTO] {
        return spells.sorted(by: { $0.name.caseInsensitiveCompare($1.name) == ComparisonResult.orderedAscending })
    }
}
