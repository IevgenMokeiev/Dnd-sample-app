//
//  Spell+Equatable.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 13.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation

extension Spell {
    static func == (lhs: Spell, rhs: Spell) -> Bool {
        return lhs.name == rhs.name &&
            lhs.path == rhs.path &&
            lhs.level == rhs.level &&
            lhs.desc == rhs.desc &&
            lhs.casting_time == rhs.casting_time &&
            lhs.concentration == rhs.concentration
    }
}
