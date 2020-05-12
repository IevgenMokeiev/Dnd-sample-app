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
    func retrieveSpellList(_ completionHandler: @escaping (_ result: [SpellDTO]?, _ error: Error?) -> Void)
    func retrieveSpellDetails(_ spell: SpellDTO, completionHandler: @escaping (_ result: SpellDTO?, _ error: Error?) -> Void)
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
    
    func retrieveSpellList(_ completionHandler: @escaping (_ result: [SpellDTO]?, _ error: Error?) -> Void) {
        
        databaseService.fetchSpellList { (resultSpells, error) in
            if let resultSpells = resultSpells {
                let sortedSpells = self.sortedSpells(spells: resultSpells)
                completionHandler(sortedSpells, nil)
            } else {
                // need to download the data first
                self.networkService.downloadSpellList { (resultArray, error) in
                    guard let resultArray = resultArray else { completionHandler(nil, nil); return }
                    let spellDTOs = self.translationService.convertToDTO(dictArray: resultArray)
                    self.databaseService.saveDownloadedSpellList(spellDTOs)
                    let sortedSpells = self.sortedSpells(spells: spellDTOs)
                    completionHandler(sortedSpells, nil)
                }
            }
        }
    }
    
    func retrieveSpellDetails(_ spell: SpellDTO, completionHandler: @escaping (_ result: SpellDTO?, _ error: Error?) -> Void) {
        networkService.downloadSpell(with: spell.path) { (downloadResult, error) in
            guard let dict = downloadResult else { completionHandler(nil, nil); return }
            let spellDTO = self.translationService.convertToDTO(dict: dict)
            self.databaseService.saveDownloadedSpell(spellDTO)
            completionHandler(spellDTO, nil)
        }
    }

    func sortedSpells(spells: [SpellDTO]) -> [SpellDTO] {
        return spells.sorted(by: { $0.name.caseInsensitiveCompare($1.name) == ComparisonResult.orderedAscending })
    }
}
