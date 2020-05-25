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
    var spellList: [SpellDTO] = []
    var refinedSpellList: [SpellDTO] = []
    var favorites: [SpellDTO] = []
    var selectedSpell: SpellDTO? = nil
    var error: Error? = nil
}

enum Sort {
    case name
    case level
}

enum AppAction {
    case requestSpellList
    case requestFavorites
    case requestSpell(path: String)
    case search(query: String)
    case sort(by: Sort)
    case showSpellList(spells: [SpellDTO])
    case showFavorites(spells: [SpellDTO])
    case showSpell(spell: SpellDTO)
    case showError(error: Error)
}
