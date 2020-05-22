//
//  NetworkServiceTests.swift
//  SpellBookTests
//
//  Created by Yevhen Mokeiev on 13.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import XCTest
import Combine
@testable import SpellBook

class NetworkServiceTests: XCTestCase {

    private var cancellableSet: Set<AnyCancellable> = []

    func test_download_spellList() {
        let sut = makeSUT()

        let apiURL = URL(string: "http://dnd5eapi.co/api/spells")!
        let response = HTTPURLResponse(url: apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let data = FakeDataFactory.provideFakeSpellListRawData()

        FakeURLProtocol.requestHandler = { request in
            XCTAssertTrue(request.url == apiURL)
            return (response, data)
        }

        let networkExpectation = expectation(description: "wait for network call")

        sut.spellListPublisher()
        .sink(receiveCompletion: { completion in
            networkExpectation.fulfill()
            switch completion {
            case .finished:
                break
            case .failure(let error):
                XCTFail("\(error)")
            }
        }, receiveValue: { spellDTOs in
            XCTAssertTrue(spellDTOs == FakeDataFactory.provideEmptySpellListDTO())
        })
        .store(in: &cancellableSet)

        waitForExpectations(timeout: 5)
    }

    func test_download_spellDetail() {
        let sut = makeSUT()

        let apiURL = URL(string: "http://dnd5eapi.co/api/spells/acid-arrow")!
        let data = FakeDataFactory.provideFakeSpellDetailsRawData()

        FakeURLProtocol.requestHandler = { request in
            XCTAssertTrue(request.url == apiURL)
            let response = HTTPURLResponse(url: apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }

        let networkExpectation = expectation(description: "wait for network call")

        sut.spellDetailPublisher(for: "/api/spells/acid-arrow")
        .sink(receiveCompletion: { completion in
            networkExpectation.fulfill()
            switch completion {
            case .finished:
                break
            case .failure(let error):
                XCTFail("\(error)")
            }
        }, receiveValue: { spellDTO in
            XCTAssertTrue(spellDTO == FakeDataFactory.provideFakeSpellDTO())
        })
        .store(in: &cancellableSet)

        waitForExpectations(timeout: 5)
    }

    private func makeSUT() -> NetworkService {
        let networkClient = NetworkClientImpl(protocolClasses: [FakeURLProtocol.self])
        let sut = NetworkServiceImpl(networkClient: networkClient)

        return sut
    }
}
