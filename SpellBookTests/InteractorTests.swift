//
//  InteractorTests.swift
//  SpellBookTests
//
//  Created by Yevhen Mokeiev on 22.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import XCTest
import Combine
@testable import SpellBook

class InteractorTests: XCTestCase {

    func test_spellList_fetch() {
        let sut = makeSUT()
    }
    
    private func makeSUT() -> Interactor {
        let fakeDatabaseService = FakeDatabaseService()
        let fakeNetworkService = FakeNetworkService()
        let fakeRefinementsService = FakeRefinementsService()
        return InteractorImpl(databaseService: fakeDatabaseService, networkService: fakeNetworkService, refinementsService: fakeRefinementsService)
    }
}
