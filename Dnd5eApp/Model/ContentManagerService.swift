//
//  ContentManagerService.swift
//  Dnd5eApp
//
//  Created by Ievgen on 4/18/19.
//  Copyright © 2019 Ievgen. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol ContentManagerService {
    func spells() -> [SpellDTO]?

    func retrieveSpellList(_ completionHandler: @escaping (_ result: [SpellDTO]?, _ error: Error?) -> Void)
    func retrieve(spell: SpellDTO?, completionHandler: @escaping (_ result: SpellDTO?, _ error: Error?) -> Void)
}

class ContentManagerServiceImpl: ContentManagerService {
    private var isDownloaded: Bool = false
    private var coreDataService: CoreDataService
    private var contentDownloaderService: ContentDownloaderService

    init(coreDataService: CoreDataService, contentDownloaderService: ContentDownloaderService) {
        self.coreDataService = coreDataService
        self.contentDownloaderService = contentDownloaderService
    }
    
    public func retrieveSpellList(_ completionHandler: @escaping (_ result: [SpellDTO]?, _ error: Error?) -> Void) {
        
        coreDataService.fetchSpellList { (result, error) in
            if nil == result {
                // need to download the data first
                self.contentDownloaderService.downloadSpellList { (result, error) in
                    self.coreDataService.saveDownloadedContent(from: result)
                    completionHandler(self.spells(), nil)
                }
            } else {
                completionHandler(self.spells(), nil)
            }
        }
    }
    
    public func retrieve(spell: SpellDTO?, completionHandler: @escaping (_ result: SpellDTO?, _ error: Error?) -> Void) {
        
        guard let path = spell?.path else { return } //to do
        
        contentDownloaderService.downloadSpell(with: path) { (downloadResult, error) in
            let spellDTO = self.coreDataService.saveDownloadedSpell(spell: spell, object: downloadResult)
            completionHandler(spellDTO, nil)
        }
    }
    
    // MARK: - Datasource support
    func spells() -> [SpellDTO]? {
        guard let spells = coreDataService.spells()?.map({ spell in
            return DataTraslator.convertToDTO(spell: spell)
        }) else { return nil }

        return spells.sorted(by: { $0.name.caseInsensitiveCompare($1.name) == ComparisonResult.orderedAscending })
    }
}
