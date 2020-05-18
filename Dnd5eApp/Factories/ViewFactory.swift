//
//  ViewFactory.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 13.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import SwiftUI

protocol ViewFactory {
    func provideSpellListView() -> SpellListView
    func provideSpellDetailView(spell: SpellDTO) -> SpellDetailView
}

class ViewFactoryImpl: ViewFactory {

    let dataLayer: DataLayer

    init(dataLayer: DataLayer) {
        self.dataLayer = dataLayer
    }

    func provideSpellListView() -> SpellListView {
        let viewModel = SpellListViewModel(publisherConstructor: { self.dataLayer.spellListPublisher(for: $0) }) { self.provideSpellDetailView(spell: $0) }
        return SpellListView(viewModel: viewModel)
    }

    func provideSpellDetailView(spell: SpellDTO) -> SpellDetailView {
        let viewModel = SpellDetailViewModel(publisher: dataLayer.spellDetailsPublisher(for: spell))
        return SpellDetailView(viewModel: viewModel)
    }
}
