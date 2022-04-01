//
//  RefinementsService.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 19.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation

/// Service responsible for refining arrays of DTOs using sort and search term
protocol RefinementsService {
  func sortedSpells(spells: [SpellDTO], sort: Sort) -> [SpellDTO]
  func filteredSpells(spells: [SpellDTO], by searchTerm: String) -> [SpellDTO]
}

class RefinementsServiceImpl: RefinementsService {

  func sortedSpells(spells: [SpellDTO], sort: Sort) -> [SpellDTO] {
    let sortRule: (SpellDTO, SpellDTO) -> Bool = {
      switch sort {
      case .name:
        return $0.name < $1.name
      case .level:
        return ($0.level ?? 0) < ($1.level ?? 0)
      }
    }

    return spells.sorted(by: sortRule)
  }

  func filteredSpells(spells: [SpellDTO], by searchTerm: String) -> [SpellDTO] {
    if searchTerm.isEmpty {
      return spells
    } else {
      return spells.filter { $0.name.contains(searchTerm) }
    }
  }
}
