//
//  FakeRefinementsService.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 22.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

@testable import SpellBook

class FakeRefinementsService: RefinementsService {
  func sortedSpells(spells: [SpellDTO], sort: Sort) -> [SpellDTO] {
    return spells
  }
  
  func filteredSpells(spells: [SpellDTO], by searchTerm: String) -> [SpellDTO] {
    return spells
  }
}
