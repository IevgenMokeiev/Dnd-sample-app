//
//  TranslationService.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 08.05.2020.
//  Copyright © 2020 Ievgen. All rights reserved.
//

import Foundation

enum Keys: String {
    case name = "name"
    case url = "url"
    case level = "level"
    case description = "desc"
    case castingTime = "casting_time"
    case concentration = "concentration"
}

protocol TranslationService {
    func populateSpellWith(dto: SpellDTO, spell: Spell)
    func convertToDTO(spell: Spell) -> SpellDTO
    func convertToDTO(spells: [Spell]) -> [SpellDTO]
    func convertToDTO(dict: [String: Any]) -> SpellDTO
    func convertToDTO(dictArray: [[String: Any]]) -> [SpellDTO]
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

    func convertToDTO(dict: [String: Any]) -> SpellDTO {
        let descriptionArray = dict[Keys.description.rawValue] as? [String]
        let description = descriptionArray?.first

        return SpellDTO(name: dict[Keys.name.rawValue] as? String ?? "", path: dict[Keys.url.rawValue] as? String ?? "", level: dict[Keys.level.rawValue] as? Int, description: description, castingTime: dict[Keys.castingTime.rawValue] as? String, concentration: dict[Keys.concentration.rawValue] as? Bool)
    }

    func convertToDTO(dictArray: [[String: Any]]) -> [SpellDTO] {
        return dictArray.map { convertToDTO(dict: $0) }
    }
}
