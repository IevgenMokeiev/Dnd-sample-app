//
//  SpellProviderService.swift
//  SpellBookTests
//
//  Created by Yevhen Mokeiev on 22.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import XCTest
import Combine
@testable import SpellBook

class SpellProviderServiceTests: XCTestCase {
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    func test_spellList_fetch_no_local_data() {
        let sut = makeSUT()
        let interactorExpectation = expectation(description: "wait for interactor")
        
        let fakeData = FakeDataFactory.spellListDTO
        
        FakeNetworkService.spellListHandler = {
            Result.success(fakeData)
        }
        
        FakeDatabaseService.spellListHandler = {
            Result.failure(.database(.noData))
        }
        
        sut.spellListPublisher
            .sink(receiveCompletion: { completion in
                interactorExpectation.fulfill()
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("\(error)")
                }
            }) { spellDTOs in
                XCTAssertEqual(spellDTOs, fakeData)
            }
            .store(in: &cancellableSet)
        
        waitForExpectations(timeout: 5)
    }
    
    func test_spellList_fetch_from_local_data() {
        let sut = makeSUT()
        let interactorExpectation = expectation(description: "wait for interactor")
        
        let fakeData = FakeDataFactory.spellListDTO
        
        FakeNetworkService.spellListHandler = {
            Result.failure(.network(.decodingFailed))
        }
        
        FakeDatabaseService.spellListHandler = {
            Result.success(fakeData)
        }
        
        sut.spellListPublisher
            .sink(receiveCompletion: { completion in
                interactorExpectation.fulfill()
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("\(error)")
                }
            }) { spellDTOs in
                XCTAssertEqual(spellDTOs, fakeData)
            }
            .store(in: &cancellableSet)
        
        waitForExpectations(timeout: 5)
    }
    
    func test_spellDetail_fetch_no_local_data() {
        let sut = makeSUT()
        let interactorExpectation = expectation(description: "wait for interactor")
        
        let fakeData = FakeDataFactory.spellDTO
        
        FakeNetworkService.spellDetailHandler = {
            Result.success(fakeData)
        }
        
        FakeDatabaseService.spellDetailHandler = {
            Result.failure(.database(.noMatchedEntity))
        }
        
        sut.spellDetailsPublisher(for: "/api/spells/fake")
            .sink(receiveCompletion: { completion in
                interactorExpectation.fulfill()
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("\(error)")
                }
            }) { spellDTO in
                XCTAssertEqual(spellDTO, fakeData)
            }
            .store(in: &cancellableSet)
        
        waitForExpectations(timeout: 5)
    }
    
    func test_spellDetail_fetch_from_local_data() {
        let sut = makeSUT()
        let interactorExpectation = expectation(description: "wait for interactor")
        
        let fakeData = FakeDataFactory.spellDTO
        
        FakeNetworkService.spellDetailHandler = {
            Result.failure(.network(.decodingFailed))
        }
        
        FakeDatabaseService.spellDetailHandler = {
            Result.success(fakeData)
        }
        
        sut.spellDetailsPublisher(for: "/api/spells/fake")
            .sink(receiveCompletion: { completion in
                interactorExpectation.fulfill()
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("\(error)")
                }
            }) { spellDTO in
                XCTAssertEqual(spellDTO, fakeData)
            }
            .store(in: &cancellableSet)
        
        waitForExpectations(timeout: 5)
    }
    
    private func makeSUT() -> SpellProviderService {
        let fakeDatabaseService = FakeDatabaseService()
        let fakeNetworkService = FakeNetworkService()
        return SpellProviderServiceImpl(databaseService: fakeDatabaseService, networkService: fakeNetworkService)
    }
}

