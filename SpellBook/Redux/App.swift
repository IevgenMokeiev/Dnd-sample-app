//
//  App.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 25.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Combine

typealias AppStore = Store<AppState, AppAction, ServiceContainer, ViewFactory>

struct AppState {
    var displayedSpells: [SpellDTO] = []
    var allSpells: [SpellDTO] = []
    var favoriteSpells: [SpellDTO] = []
    var selectedSpell: SpellDTO? = nil
    var error: Error? = nil
}

enum AppAction {
    case requestSpellList
    case requestFavorites
    case requestSpell(path: String)
    case search(query: String)
    case sort(by: Sort)
    case toggleFavorite
    case showSpellList(spells: [SpellDTO])
    case showFavorites(spells: [SpellDTO])
    case showSpell(spell: SpellDTO)
    case showError(error: Error)
}

enum Sort {
    case name
    case level
}
