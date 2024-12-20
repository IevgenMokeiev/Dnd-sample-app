//
//  NetworkServiceTests.swift
//  SpellBookTests
//
//  Created by Yevhen Mokeiev on 13.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Combine
@testable import SpellBook
import Foundation
import Testing

@Suite
final class NetworkServiceTests {
    private var cancellableSet: Set<AnyCancellable> = []
    
    @Test
    func whenDownloadSpellList_thenReturnsCorrectValue() async {
        let sut = makeSUT()
        
        let apiURL = URL(string: "http://dnd5eapi.co/api/spells")!
        let response = HTTPURLResponse(url: apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let data = FakeDataFactory.provideFakeSpellListRawData()
        await MockURLProtocol.responsesMap.setResponse(response: (data: data, response: response, error: nil), for: apiURL)
        let (spy, cancellable) = await sut.spellListPublisher.spy()
        cancellable.store(in: &cancellableSet)
        #expect(spy.values.first == FakeDataFactory.provideEmptySpellListDTO())
    }
    
    @Test
    func whenDownloadSpellDetail_thenReturnsCorrectValue() async {
        let sut = makeSUT()
        
        let apiURL = URL(string: "http://dnd5eapi.co/api/spells/acid-arrow")!
        let data = FakeDataFactory.provideFakeSpellDetailsRawData()
        let response = HTTPURLResponse(url: apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        await MockURLProtocol.responsesMap.setResponse(response: (data: data, response: response, error: nil), for: apiURL)
        
        let (spy, cancellable) = await sut.spellDetailPublisher(for: "/api/spells/acid-arrow").spy()
        cancellable.store(in: &cancellableSet)
        #expect(spy.values.first == FakeDataFactory.provideFakeSpellDTO())
    }
    
    private func makeSUT() -> NetworkService {
        let networkClient = NetworkClientImpl(protocolClasses: [MockURLProtocol.self])
        return NetworkServiceImpl(networkClient: networkClient)
    }
}
