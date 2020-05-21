//
//  TabbarViewModel.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 20.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation

class TabbarViewModel {
    let spellListConstructor: SpellListViewConstructor
    let favoritesConstructor: FavoritesViewConstructor

    init(spellListConstructor: @escaping SpellListViewConstructor, favoritesConstructor: @escaping FavoritesViewConstructor) {
        self.spellListConstructor = spellListConstructor
        self.favoritesConstructor = favoritesConstructor
    }
}
