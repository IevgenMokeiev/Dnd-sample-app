//
//  TranslationService.swift
//  Dnd5eApp
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
        return SpellDTO(name: spell.name ?? "", path: spell.path ?? "", level: Int(spell.level), description: spell.desc, castingTime: spell.casting_time, concentration: spell.concentration, isFavorite: spell.isFavorite)
    }

    func convertToDTO(spellList: [Spell]) -> [SpellDTO] {
        return spellList.map { convertToDTO(spell: $0) }
    }
}
