//
//  AppModule.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 13.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation

class AppModule {

    let viewFactory: ViewFactory

    init() {
        let translationServiceImpl = TranslationServiceImpl()
        let coreDataStackImpl = CoreDataStackImpl()
        let databaseServiceImpl = DatabaseServiceImpl(coreDataStack: coreDataStackImpl, translationService: translationServiceImpl)
        let networkServiceImpl = NetworkServiceImpl()
        let dataLayer = DataLayerImpl(databaseService: databaseServiceImpl, networkService: networkServiceImpl)
        self.viewFactory = ViewFactoryImpl(dataLayer: dataLayer)
    }
}
