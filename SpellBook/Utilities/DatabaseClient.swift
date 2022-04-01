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
  func fetchRecords<T: NSManagedObject>(expectedType: T.Type, predicate: NSPredicate?) -> AnyPublisher<[T], CustomError>
  func createRecord<T: NSManagedObject>(expectedType: T.Type) -> T
  func save()
}

class DatabaseClientImpl: DatabaseClient {

  private let coreDataStack: CoreDataStack
  private var cancellableSet: Set<AnyCancellable> = []

  init(coreDataStack: CoreDataStack) {
    self.coreDataStack = coreDataStack
    NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)
      .sink { _ in coreDataStack.saveContext() }
      .store(in: &cancellableSet)
  }

  func fetchRecords<T: NSManagedObject>(expectedType: T.Type, predicate: NSPredicate?) -> AnyPublisher<[T], CustomError> {
    let context = coreDataStack.persistentContainer.viewContext
    let request = NSFetchRequest<T>(entityName: String(describing: T.self))
    if let predicate = predicate {
      request.predicate = predicate
    }
    request.returnsObjectsAsFaults = false

    do {
      let fetchResult = try context.fetch(request)
      if fetchResult.isEmpty {
        return Fail(error: .database(.noData))
          .eraseToAnyPublisher()
      } else {
        return Result.Publisher(fetchResult).eraseToAnyPublisher()
      }
    } catch let error as NSError {
      print("Could not retrieve. \(error), \(error.userInfo)")
      return Fail(error: .database(.fetchFailed(error)))
        .eraseToAnyPublisher()
    }
  }

  func createRecord<T: NSManagedObject>(expectedType: T.Type) -> T {
    return T(context: coreDataStack.persistentContainer.viewContext)
  }

  func save() {
    do {
      try coreDataStack.persistentContainer.viewContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }
}



