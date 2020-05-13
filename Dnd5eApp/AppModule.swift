//
//  AppModule.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 13.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation

class AppModule {

    let dataLayer: DataLayer
    let viewFactory: ViewFactory

    init() {
        self.dataLayer = Self.provideDataLayer()
        self.viewFactory = ViewFactoryImpl(dataLayer: self.dataLayer)
    }

    static func provideDataLayer() -> DataLayer {
        let translationServiceImpl = TranslationServiceImpl()
        let coreDataStackImpl = CoreDataStackImpl()
        let databaseServiceImpl = DatabaseServiceImpl(coreDataStack: coreDataStackImpl, translationService: translationServiceImpl)
        let parsingServiceImpl = ParsingServiceImpl()
        let networkServiceImpl = NetworkServiceImpl(parsingService: parsingServiceImpl)
        let dataLayer = DataLayerImpl(databaseService: databaseServiceImpl, networkService: networkServiceImpl)
        return dataLayer
    }
}
