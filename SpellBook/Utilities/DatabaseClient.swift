//
//  DatabaseClient.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 22.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import UIKit
import CoreData
import Combine

enum DatabaseClientError: Error {
    case noData
    case wrongRequest
    case noMatchedEntity
    case fetchFailed(Error)
}

protocol DatabaseClient {
    func fetchObjects<T: NSManagedObject>(expectedType: T.Type, predicate: NSPredicate?) -> AnyPublisher<[T], DatabaseClientError>
    func createObject<T: NSManagedObject>(expectedType: T.Type) -> T
    func saveChanges()
}

class DatabaseClientImpl: DatabaseClient {

    private var coreDataStack: CoreDataStack
    private var cancellableSet: Set<AnyCancellable> = []

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)
            .sink { _ in coreDataStack.saveContext() }
            .store(in: &cancellableSet)
    }

    func fetchObjects<T: NSManagedObject>(expectedType: T.Type, predicate: NSPredicate?) -> AnyPublisher<[T], DatabaseClientError> {
        let context = coreDataStack.persistentContainer.viewContext
        let request = NSFetchRequest<T>(entityName: String(describing: T.self))
        if let predicate = predicate {
            request.predicate = predicate
        }
        request.returnsObjectsAsFaults = false

        do {
            let fetchResult = try context.fetch(request)
            if fetchResult.isEmpty {
                return Fail(error: .noData).eraseToAnyPublisher()
            } else {
                return Result.Publisher(fetchResult).eraseToAnyPublisher()
            }
        } catch let error as NSError {
            print("Could not retrieve. \(error), \(error.userInfo)")
            return Fail(error: .fetchFailed(error)).eraseToAnyPublisher()
        }
    }

    func createObject<T: NSManagedObject>(expectedType: T.Type) -> T {
        let managedContext = coreDataStack.persistentContainer.viewContext
        return T(context: managedContext)
    }

    func saveChanges() {
        let managedContext = coreDataStack.persistentContainer.viewContext
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}



