//
//  SpellList.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 27.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation

enum SpellListState {
    case initial
    case spellList(displayedSpells: [SpellDTO], allSpells: [SpellDTO])
    case error(Error)
}

enum SpellListAction {
    case requestSpellList
    case showSpellList([SpellDTO])
    case showSpellListLoadError(Error)
    case search(query: String)
    case sort(by: Sort)
}

enum Sort {
    case name
    case level
}

