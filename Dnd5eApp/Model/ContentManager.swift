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
    
    public static let sharedManager = ContentManager()
    private var isDownloaded: Bool = false
    
    public func retrieveContent(for path: ContentPath, completionHandler: @escaping (_ result: [String: Any]?, _ error: Error?) -> Void) {
        
        // try fetching results from Core Data stack
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Spell")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            
            if result.isEmpty {
                // need to download the data first
                ContentDownloader().downloadContent(with: path) { (result, error) in
                    self.saveCoreDataStack(with: result)
                    completionHandler(result, error)
                }
            } else {
                // we can use core data
                
            }
        } catch {
            ContentDownloader().downloadContent(with: path) { (result, error) in
                self.saveCoreDataStack(with: result)
                completionHandler(result, error)
            }
        }
    }
    
    private func saveCoreDataStack(with object:[String: Any]?) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let dict = object else { return }
        guard let array: [[String: Any]] = dict["results"] as? [[String: Any]] else { return }
        
        for entry in array {
            let entity = NSEntityDescription.entity(forEntityName: "Spell", in: managedContext)!
            let spell = NSManagedObject(entity: entity, insertInto: managedContext)
            guard let name = entry["name"] as? String else { return }
            spell.setValue(name, forKeyPath: "name")
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
