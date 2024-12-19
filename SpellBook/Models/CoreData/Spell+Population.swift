//
//  Spell+Population.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 21.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation

/// Extension which allows spell population with DTO object
extension Spell {
    func populate(with dto: SpellDTO) {
        name = dto.name
        path = dto.path
        level = Int16(dto.level ?? 0)
        casting_time = dto.castingTime
        concentration = dto.concentration ?? false
        classes = dto.classes
        desc = dto.description
        higherLevel = dto.higherLevel
        isFavorite = dto.isFavorite
    }
}

