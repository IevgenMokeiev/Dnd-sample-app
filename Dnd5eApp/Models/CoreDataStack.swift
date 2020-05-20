//
//  CoreDataStack.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 13.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import CoreData

/// Defines core data stack which is used in a Database service
protocol CoreDataStack {
    var persistentContainer: NSPersistentContainer! {get}
    var managedObjectContext: NSManagedObjectContext! {get}
    func saveContext()
}

class CoreDataStackImpl: CoreDataStack {
    var persistentContainer: NSPersistentContainer!
    var managedObjectContext: NSManagedObjectContext!

    init() {
        persistentContainer = NSPersistentContainer(name: "DnDModel")
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        managedObjectContext = persistentContainer.viewContext
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
