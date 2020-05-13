//
//  NetworkServiceTests.swift
//  Dnd5eAppTests
//
//  Created by Yevhen Mokeiev on 13.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import XCTest
@testable import Dnd5eApp

class NetworkServiceTests: XCTestCase {

    func test_download_spellList() {
        let sut = makeSUT()

        let apiURL = URL(string: "http://dnd5eapi.co/api/spells")!
        let data = FakeDataFactory.provideFakeSpellListRawData()

        MockURLProtocol.requestHandler = { request in
            XCTAssertTrue(request.url == apiURL)
            let response = HTTPURLResponse(url: apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }

        let expectatation = expectation(description: "wait for network call")

        sut.downloadSpellList { result in
            switch result {
            case .success(let spellDTOs):
                XCTAssertTrue(spellDTOs == FakeDataFactory.provideFakeSpellListDTO())
            case .failure(let error):
                XCTFail("\(error)")
            }
            expectatation.fulfill()
        }

        waitForExpectations(timeout: 5)
    }

    func test_download_spellDetail() {
        let sut = makeSUT()

        let apiURL = URL(string: "http://dnd5eapi.co/api/spells/acid-arrow")!
        let data = FakeDataFactory.provideFakeSpellDetailsRawData()

        MockURLProtocol.requestHandler = { request in
            XCTAssertTrue(request.url == apiURL)
            let response = HTTPURLResponse(url: apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }

        let expectatation = expectation(description: "wait for network call")

        sut.downloadSpell(with: "/api/spells/acid-arrow") { result in
            switch result {
            case .success(let spellDTO):
                XCTAssertTrue(spellDTO == FakeDataFactory.provideFakeSpellDTO())
            case .failure(let error):
                XCTFail("\(error)")
            }
            expectatation.fulfill()
        }

        waitForExpectations(timeout: 5)
    }

    private func makeSUT() -> NetworkService {
        let sut = NetworkServiceImpl(parsingService: FakeParsingService())
        sut.urlSessionProtocolClasses = [MockURLProtocol.self]

        return sut
    }
}
