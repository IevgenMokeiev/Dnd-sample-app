//
//  Spell+Equatable.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 13.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation

extension Spell {
    static func == (lhs: Spell, rhs: Spell) -> Bool {
        return lhs.path == rhs.path
    }
}
