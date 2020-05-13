//
//  Fakes.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 13.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation
@testable import Dnd5eApp

class FakeParsingService: ParsingService {
    func parseFrom(spellListData: Data) -> Result<[SpellDTO], ParsingError> {
        return .success([FakeDataFactory.provideFakeSpellDTO()])
    }

    func parseFrom(spellDetailData: Data) -> Result<SpellDTO, ParsingError> {
        return .success(FakeDataFactory.provideFakeSpellDTO())
    }
}
