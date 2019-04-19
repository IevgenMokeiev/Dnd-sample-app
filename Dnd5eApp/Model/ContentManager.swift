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
    
    public func retrieveContent(for path: ContentPath, completionHandler: @escaping (_ result: [String: Any]?, _ error: Error?) -> Void) {
        
        CoreDataStack.shared.fetchContent(for: path) { (result, error) in
            if nil == result {
                // need to download the data first
                ContentDownloader().downloadContent(with: path) { (result, error) in
                    CoreDataStack.shared.saveContent(with: result)
                    completionHandler(result, error)
                }
            }
        }
    }
}
