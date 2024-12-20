//
//  Publisher+Spy.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 13.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Combine

extension Publisher {
    func spy() async -> (PublisherSpy<Output>, AnyCancellable) {
        let spy = PublisherSpy<Output>()
        var cancellable = AnyCancellable {}
        
        await withCheckedContinuation { continuation in
            cancellable = sink(receiveCompletion: { completion in
                continuation.resume()
                switch completion {
                case .finished:
                    spy.setCompleted()
                case .failure(let error):
                    spy.setError(error: error)
                    spy.setCompleted()
                }
            }, receiveValue: { value in
                spy.append(value: value)
            })
        }
        return (spy, cancellable)
    }
}

class PublisherSpy<Output> {
    
    private(set) var values: [Output]
    private(set) var error: Error?
    private(set) var completed: Bool
            
    fileprivate init() {
        self.values = []
        self.error = nil
        self.completed = false
    }
        
    fileprivate func append(value: Output) {
        values.append(value)
    }
    
    fileprivate func setError(error: Error) {
        self.error = error
    }
    
    fileprivate func setCompleted() {
        completed = true
    }
}
