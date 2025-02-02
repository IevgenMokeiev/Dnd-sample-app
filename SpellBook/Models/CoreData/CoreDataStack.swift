//
//  CoreDataStack.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 13.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import CoreData
import Foundation

protocol CoreDataStack {
    var persistentContainer: NSPersistentContainer! { get }
    var managedObjectContext: NSManagedObjectContext! { get }

    func saveContext()
    func cleanupStack()
}

class CoreDataStackImpl: CoreDataStack {
    var persistentContainer: NSPersistentContainer!
    var managedObjectContext: NSManagedObjectContext!

    init() {
        persistentContainer = NSPersistentContainer(name: "DnDModel")
        persistentContainer.loadPersistentStores(completionHandler: { _, error in
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

    func cleanupStack() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Spell.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try persistentContainer.viewContext.execute(deleteRequest)
        } catch let error as NSError {
            print(error)
        }
    }
}
