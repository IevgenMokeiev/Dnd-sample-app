//
//  StubRefinementsService.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 22.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

@testable import SpellBook

final class StubRefinementsService: RefinementsServiceProtocol {
    func refineSpells(spells: [SpellDTO], sort _: Sort, searchTerm _: String) -> [SpellDTO] {
        return spells
    }
}
