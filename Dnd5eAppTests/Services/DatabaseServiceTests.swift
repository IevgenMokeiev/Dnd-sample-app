//
//  DatabaseServiceTests.swift
//  Dnd5eAppTests
//
//  Created by Yevhen Mokeiev on 13.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import XCTest
import CoreData
import Combine
@testable import Dnd5eApp

class DatabaseServiceTests: XCTestCase {

    var context: NSManagedObjectContext?
    var bag = Set<AnyCancellable>()

    func test_spellList_fetch() {
        let sut = makeSUT()
        guard let context = context else { XCTFail("no context"); return }
        _ = FakeDataFactory.provideFakeSpellList(context: context)
        sut.fetchSpellList()
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
        .store(in: &bag)
    }

    func test_spell_fetch() {
        let sut = makeSUT()
        guard let context = context else { XCTFail("no context"); return }
        let spell = FakeDataFactory.provideFakeSpell(context: context)
        sut.fetchSpell(by: spell.name!)
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
        .store(in: &bag)
    }

    func test_save_spellList() {
        let sut = makeSUT()
        sut.saveDownloadedSpellList(FakeDataFactory.provideFakeSpellListDTO())
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
        .store(in: &bag)
    }

    func test_save_spell() {
        let sut = makeSUT()
        guard let context = context else { XCTFail("no context"); return }
        _ = FakeDataFactory.provideFakeSpell(context: context)
        sut.saveDownloadedSpell(FakeDataFactory.provideFakeSpellDTO())
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
        .store(in: &bag)
    }

    private func makeSUT() -> DatabaseService {
        let fakeStack = FakeCoreDataStack()
        context = fakeStack.persistentContainer.viewContext
        return DatabaseServiceImpl(coreDataStack: fakeStack, translationService: FakeTranslationService())
    }
}
