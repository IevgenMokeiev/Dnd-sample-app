//
//  TranslationService.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 08.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation

/// Service responsible for translation between DTO's and CoreData generated models
protocol TranslationService {
  func convertToDTO(spell: Spell) -> SpellDTO
  func convertToDTO(spellList: [Spell]) -> [SpellDTO]
}

class TranslationServiceImpl: TranslationService {

  func convertToDTO(spell: Spell) -> SpellDTO {
    return SpellDTO(name: spell.name ?? "", path: spell.path ?? "", level: Int(spell.level), castingTime: spell.casting_time, concentration: spell.concentration, classes: spell.classes, description: spell.desc, isFavorite: spell.isFavorite)
  }

  func convertToDTO(spellList: [Spell]) -> [SpellDTO] {
    return spellList.map { convertToDTO(spell: $0) }
  }
}
