//
//  DatabaseServiceTests.swift
//  SpellBookTests
//
//  Created by Yevhen Mokeiev on 13.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import XCTest
import CoreData
import Combine
@testable import SpellBook

class DatabaseServiceTests: XCTestCase {
  
  var context: NSManagedObjectContext?
  private var cancellableSet: Set<AnyCancellable> = []
  
  func test_spellList_fetch() {
    let sut = makeSUT()
    guard let context = context else { XCTFail("no context"); return }
    _ = FakeDataFactory.provideFakeSpellList(context: context)
    sut.spellListPublisher()
      .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
          break
        case .failure(let error):
          XCTFail("\(error)")
        }
      }) { spellDTOs in
        XCTAssertTrue(spellDTOs == FakeDataFactory.provideFakeSpellListDTO())
      }
      .store(in: &cancellableSet)
  }
  
  func test_spell_fetch() {
    let sut = makeSUT()
    guard let context = context else { XCTFail("no context"); return }
    let spell = FakeDataFactory.provideFakeSpell(context: context)
    sut.spellDetailsPublisher(for: spell.path!)
      .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
          break
        case .failure(let error):
          XCTFail("\(error)")
        }
      }) { spellDTO in
        XCTAssertTrue(spellDTO == FakeDataFactory.provideFakeSpellDTO())
      }
      .store(in: &cancellableSet)
  }
  
  func test_favorites_fetch_no_favorites() {
    let sut = makeSUT()
    guard let context = context else { XCTFail("no context"); return }
    _ = FakeDataFactory.provideFakeSpellList(context: context)
    sut.favoritesPublisher()
      .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
          break
        case .failure(let error):
          XCTFail("\(error)")
        }
      }) { spellDTOs in
        XCTAssertTrue(spellDTOs.count == 0)
      }
      .store(in: &cancellableSet)
  }
  
  func test_favorites_fetch_has_favorites() {
    let sut = makeSUT(testFavorites: true)
    guard let context = context else { XCTFail("no context"); return }
    _ = FakeDataFactory.provideFakeFavoritesList(context: context)
    sut.favoritesPublisher()
      .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
          break
        case .failure(let error):
          XCTFail("\(error)")
        }
      }) { spellDTOs in
        XCTAssertTrue(spellDTOs == FakeDataFactory.provideFakeFavoritesListDTO())
      }
      .store(in: &cancellableSet)
  }
  
  private func makeSUT(testFavorites: Bool = false) -> DatabaseService {
    let fakeStack = FakeCoreDataStack()
    context = fakeStack.persistentContainer.viewContext
    return DatabaseServiceImpl(databaseClient: DatabaseClientImpl(coreDataStack: fakeStack), translationService: FakeTranslationService(testFavorites: testFavorites))
  }
}
