//
//  SpellDetail.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 27.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation

enum SpellDetailState {
    case initial
    case selectedSpell(SpellDTO)
    case error(Error)
}

enum SpellDetaiAction {
    case requestSpell(path: String)
    case showSpell(SpellDTO)
    case showSpellLoadError(Error)
}

