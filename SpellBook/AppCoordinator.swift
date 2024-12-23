//
//  AppCoordinator.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 13.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation
@MainActor
class AppCoordinator {
    let viewFactory: ViewFactory

    init(configureForTesting: Bool = false) {
        guard let databaseClientImpl = try? DatabaseClientImpl() else {
            fatalError()
        }
        let databaseServiceImpl = DatabaseServiceImpl(databaseClient: databaseClientImpl)
        let networkServiceImpl = NetworkServiceImpl(networkClient: NetworkClientImpl())
        let refinementsServiceImpl = RefinementsServiceImpl()
        let interactor = Interactor(databaseService: databaseServiceImpl, networkService: networkServiceImpl, refinementsService: refinementsServiceImpl)
        viewFactory = ViewFactory(interactor: interactor)

//        if configureForTesting {
//            coreDataStackImpl.cleanupStack()
//        }
    }
}
