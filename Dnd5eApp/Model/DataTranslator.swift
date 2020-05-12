//
//  DataTranslator.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 08.05.2020.
//  Copyright © 2020 Ievgen. All rights reserved.
//

import Foundation

class DataTraslator {

    static func populateSpellWith(dto: SpellDTO, spell: Spell) -> Spell {
        spell.name = dto.name
        spell.level = Int16(dto.level ?? 0)
        spell.desc = dto.description
        spell.casting_time = dto.castingTime
        spell.concentration = dto.concentration ?? false
        spell.path = dto.path

        return spell
    }

    static func convertToDTO(spell: Spell) -> SpellDTO {
        return SpellDTO(name: spell.name ?? "", level: Int(spell.level), description: spell.desc, castingTime: spell.casting_time, concentration: spell.concentration, path: spell.path ?? "")
    }
}
