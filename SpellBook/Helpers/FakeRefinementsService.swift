//
//  FakeRefinementsService.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 22.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

@testable import SpellBook

class FakeRefinementsService: RefinementsService {
    func refineSpells(spells: [SpellDTO], sort: Sort, searchTerm: String) -> [SpellDTO] {
        return spells
    }
}
