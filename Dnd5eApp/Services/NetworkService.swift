//
//  NetworkService.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 4/18/19.
//  Copyright © 2019 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import Combine

struct Response: Codable {
    public let results: [SpellDTO]
}

private enum Endpoints: String {
    case spellList = "http://dnd5eapi.co/api/spells"
    case spellDetails = "http://dnd5eapi.co"
}

public enum NetworkServiceError: Error {
    case incorrectURL
    case downloadFailed
    case invalidResponseStatusCode
    case invalidResponseData
}

protocol NetworkService {
    func downloadSpellList(_ completionHandler: @escaping (Result<[SpellDTO], NetworkServiceError>) -> Void)
    func downloadSpell(with path: String, _ completionHandler: @escaping (Result<SpellDTO, NetworkServiceError>) -> Void)
}

class NetworkServiceImpl: NetworkService {
    internal var urlSessionProtocolClasses: [AnyClass]?

    private var cancellable: AnyCancellable?
    
    func downloadSpellList(_ completionHandler: @escaping (Result<[SpellDTO], NetworkServiceError>) -> Void) {

        guard let url = URL(string: Endpoints.spellList.rawValue) else {
            completionHandler(.failure(.incorrectURL)); return
        }

        downloadContent(with: url, decodingType: Response.self) { result in
            switch result {
            case .success(let response):
                let spells = response.results
                completionHandler(.success(spells))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func downloadSpell(with path: String, _ completionHandler: @escaping (Result<SpellDTO, NetworkServiceError>) -> Void) {

        guard let url = URL(string: Endpoints.spellDetails.rawValue + path) else {
            completionHandler(.failure(.incorrectURL)); return
        }

        downloadContent(with: url, decodingType: SpellDTO.self) { result in
            switch result {
            case .success(let spell):
                completionHandler(.success(spell))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func downloadContent<T: Decodable>(with url: URL, decodingType: T.Type, completionHandler: @escaping (Result<T, NetworkServiceError>) -> Void) {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = self.urlSessionProtocolClasses

        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)

        self.cancellable = session.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: decodingType.self , decoder: JSONDecoder())
            .eraseToAnyPublisher()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    completionHandler(.failure(.invalidResponseData))
                }
            }, receiveValue: { result in
                completionHandler(.success(result))
            })
    }
}
