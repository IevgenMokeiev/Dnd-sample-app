//
//  Store.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 25.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import Combine

final class Store<State, Action, Environment>: ObservableObject {
    @Published private(set) var state: State

    private let environment: Environment
    private let reducer: Reducer<State, Action, Environment>
    private var effectCancellables: Set<AnyCancellable> = []

    init(initialState: State, reducer: @escaping Reducer<State, Action, Environment>, environment: Environment) {
        self.state = initialState
        self.reducer = reducer
        self.environment = environment
    }

    func send(_ action: Action) {
        reducer(&state, action, environment)
            .receive(on: RunLoop.main)
            .sink(receiveValue: send)
            .store(in: &effectCancellables)
    }
}
