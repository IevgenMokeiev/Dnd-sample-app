//
//  FakeNetworkService.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 22.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

@testable import SpellBook

class FakeNetworkService: NetworkService {

    static var spellListHandler: (() -> Result<[SpellDTO], NetworkClientError>)?

    static var spellDetailHandler: (() -> Result<SpellDTO, NetworkClientError>)?

    func spellListPublisher() -> NetworkSpellPublisher {
        guard let handler = Self.spellListHandler else {
            fatalError("Handler is unavailable.")
        }
        let result = handler()
        return Result.Publisher(result).eraseToAnyPublisher()
    }

    func spellDetailPublisher(for path: String) -> NetworkSpellDetailPublisher {
        guard let handler = Self.spellDetailHandler else {
            fatalError("Handler is unavailable.")
        }
        let result = handler()
        return Result.Publisher(result).eraseToAnyPublisher()
    }
}
