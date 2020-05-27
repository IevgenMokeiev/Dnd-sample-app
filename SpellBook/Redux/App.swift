//
//  App.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 25.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Combine

typealias AppStore = Store<AppState, AppAction, ServiceContainer>

struct AppState {
    var spellListState: SpellListState
    var spellDetailState: SpellDetailState
    var favoriteSpells: [SpellDTO] = []
}

enum AppAction {
    case requestSpellList
    case requestFavorites
    case requestSpell(path: String)
    case search(query: String)
    case sort(by: Sort)
    case toggleFavorite
    case showSpellList([SpellDTO])
    case showFavorites([SpellDTO])
    case showSpell(SpellDTO)
    case showSpellListLoadError(Error)
    case showSpellLoadError(Error)
}

enum SpellListState {
    case initial
    case spellList(displayedSpells: [SpellDTO], allSpells: [SpellDTO])
    case error(Error)
}

enum SpellDetailState {
    case initial
    case selectedSpell(SpellDTO)
    case error(Error)
}

enum Sort {
    case name
    case level
}
