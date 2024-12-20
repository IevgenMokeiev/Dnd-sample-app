//
//  MockNetworkService.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 22.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

@testable import SpellBook

class MockNetworkService: NetworkService {
    var spellListHandler: (() -> Result<[SpellDTO], CustomError>)?
    var spellDetailHandler: (() -> Result<SpellDTO, CustomError>)?

    var spellListPublisher: SpellListPublisher {
        guard let spellListHandler else {
            fatalError("Handler is unavailable.")
        }
        return Result.Publisher(spellListHandler()).eraseToAnyPublisher()
    }

    func spellDetailPublisher(for _: String) -> SpellDetailPublisher {
        guard let spellDetailHandler else {
            fatalError("Handler is unavailable.")
        }
        return Result.Publisher(spellDetailHandler()).eraseToAnyPublisher()
    }
}
