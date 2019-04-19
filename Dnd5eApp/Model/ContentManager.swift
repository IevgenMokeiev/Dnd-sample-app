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

class ContentManager {
    
    public static let shared = ContentManager()
    private var isDownloaded: Bool = false
    
    public func retrieveSpellList(_ completionHandler: @escaping (_ result: [Spell]?, _ error: Error?) -> Void) {
        
        CoreDataStack.shared.fetchSpellList { (result, error) in
        
            if nil == result {
                // need to download the data first
                ContentDownloader().downloadSpellList { (result, error) in
                    let spells = CoreDataStack.shared.convertDownloadedContent(from: result)
                    completionHandler(spells, nil)
                }
            } else {
                completionHandler(result, nil)
            }
        }
    }
}
