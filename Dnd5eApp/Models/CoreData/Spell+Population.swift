//
//  Spell+Population.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 21.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation

/// Extension which allows spell population with DTO object
extension Spell {
    func populate(with dto: SpellDTO) {
        name = dto.name
        level = Int16(dto.level ?? 0)
        desc = dto.description
        casting_time = dto.castingTime
        concentration = dto.concentration ?? false
        path = dto.path
        isFavorite = dto.isFavorite
    }
}
