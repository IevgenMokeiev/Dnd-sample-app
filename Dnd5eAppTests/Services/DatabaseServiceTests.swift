//
//  DatabaseServiceTests.swift
//  Dnd5eAppTests
//
//  Created by Yevhen Mokeiev on 13.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import XCTest
@testable import Dnd5eApp

class DatabaseServiceTests: XCTestCase {

    func test_spellList_fetch() {
        let sut = makeSUT()
        let result = sut.fetchSpellList()

        switch result {
        case .success(let spellDTOs):
            XCTAssertEqual(spellDTOs, FakeDataFactory.provideFakeSpellListDTO())
        case .failure(let error):
            XCTFail("\(error)")
        }
    }

    private func makeSUT() -> DatabaseService {
        return DatabaseServiceImpl(coreDataStack: FakeCoreDataStack(), translationService: FakeTranslationService())
    }
}
