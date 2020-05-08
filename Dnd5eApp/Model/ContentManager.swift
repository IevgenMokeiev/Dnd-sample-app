//
//  ContentManager.swift
//  Dnd5eApp
//
//  Created by Ievgen on 4/18/19.
//  Copyright © 2019 Ievgen. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol ContentManagerService {
    var numberOfSpells: Int { get }
    func spell(at indexPath:IndexPath) -> SpellDTO?
    func retrieveSpellList(_ completionHandler: @escaping (_ result: [SpellDTO]?, _ error: Error?) -> Void)
    func retrieve(spell: SpellDTO?, completionHandler: @escaping (_ result: SpellDTO?, _ error: Error?) -> Void)
}

class ContentManager: ContentManagerService {
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
                    let spells = self.coreDataService.saveDownloadedContent(from: result)
                    completionHandler(spells, nil)
                }
            } else {
                completionHandler(result, nil)
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
    
    public var numberOfSpells: Int {
        return coreDataService.numberOfSpells
    }
    
    public func spell(at indexPath:IndexPath) -> SpellDTO? {
        guard let spell = coreDataService.spell(at: indexPath) else { return nil }
        let spellDTO = DataTraslator.convertToDTO(spell: spell)
        return spellDTO
    }

}
