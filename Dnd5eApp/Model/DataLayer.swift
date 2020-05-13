//
//  DataLayer.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 4/18/19.
//  Copyright © 2019 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Combine

protocol DataLayer {
    func retrieveSpellList(_ completionHandler: @escaping (_ result: Result<[SpellDTO], Error>) -> Void)
    func retrieveSpellDetails(_ spell: SpellDTO, completionHandler: @escaping (_ result: Result<SpellDTO, Error>) -> Void)
}

class DataLayerImpl: DataLayer {
    private var databaseService: DatabaseService
    private var networkService: NetworkService

    private var cancellable: AnyCancellable?

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
            self.cancellable = networkService.downloadSpellList()
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                }) { spellDTOs in
                    self.databaseService.saveDownloadedSpellList(spellDTOs)
                    let sortedSpells = self.sortedSpells(spells: spellDTOs)
                    completionHandler(.success(sortedSpells))
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
            self.cancellable = networkService.downloadSpell(with: spell.path)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                }) { spellDTO in
                    self.databaseService.saveDownloadedSpell(spellDTO)
                    completionHandler(.success(spellDTO)
                    )
            }
        }
    }

    func sortedSpells(spells: [SpellDTO]) -> [SpellDTO] {
        return spells.sorted(by: { $0.name.caseInsensitiveCompare($1.name) == ComparisonResult.orderedAscending })
    }
}
