//
//  FakeTranslationService.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 22.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

@testable import SpellBook

class FakeTranslationService: TranslationService {
    let testFavorites: Bool

    init(testFavorites: Bool) {
        self.testFavorites = testFavorites
    }

    func convertToDTO(spell _: Spell) -> SpellDTO {
        return FakeDataFactory.provideFakeSpellDTO()
    }

    func convertToDTO(spellList _: [Spell]) -> [SpellDTO] {
        return testFavorites ? FakeDataFactory.provideFakeFavoritesListDTO() : FakeDataFactory.provideFakeSpellListDTO()
    }
}
