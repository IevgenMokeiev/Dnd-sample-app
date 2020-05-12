//
//  TranslationService.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 08.05.2020.
//  Copyright © 2020 Ievgen. All rights reserved.
//

import Foundation

protocol TranslationService {
    func populateSpellWith(dto: SpellDTO, spell: Spell)
    func convertToDTO(spell: Spell) -> SpellDTO
    func convertToDTO(spells: [Spell]) -> [SpellDTO]
}

class TranslationServiceImpl: TranslationService {
    func populateSpellWith(dto: SpellDTO, spell: Spell) {
        spell.name = dto.name
        spell.level = Int16(dto.level ?? 0)
        spell.desc = dto.description
        spell.casting_time = dto.castingTime
        spell.concentration = dto.concentration ?? false
        spell.path = dto.path
    }

    func convertToDTO(spell: Spell) -> SpellDTO {
        return SpellDTO(name: spell.name ?? "", path: spell.path ?? "", level: Int(spell.level), description: spell.desc, castingTime: spell.casting_time, concentration: spell.concentration)
    }

    func convertToDTO(spells: [Spell]) -> [SpellDTO] {
        return spells.map { convertToDTO(spell: $0) }
    }
}
