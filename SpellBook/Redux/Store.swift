//
//  Store.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 25.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import Combine

final class Store<State, Action, Environment, Factory>: ObservableObject {
    @Published private(set) var state: State

    let factory: Factory
    private let environment: Environment
    private let reducer: Reducer<State, Action, Environment>
    private var effectCancellables: Set<AnyCancellable> = []

    init(
        initialState: State,
        reducer: @escaping Reducer<State, Action, Environment>,
        environment: Environment,
        factory: Factory
    ) {
        self.state = initialState
        self.reducer = reducer
        self.environment = environment
        self.factory = factory
    }

    func send(_ action: Action) {
        guard let effect = reducer(&state, action, environment) else {
            return
        }

        effect
            .receive(on: RunLoop.main)
            .sink(receiveValue: send)
            .store(in: &effectCancellables)
    }
}
