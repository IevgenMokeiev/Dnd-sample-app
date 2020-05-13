//
//  NetworkService.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 4/18/19.
//  Copyright © 2019 Yevhen Mokeiev. All rights reserved.
//

import Foundation

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

    let parsingService: ParsingService

    init(parsingService: ParsingService) {
        self.parsingService = parsingService
    }
    
    func downloadSpellList(_ completionHandler: @escaping (Result<[SpellDTO], NetworkServiceError>) -> Void) {

        guard let url = URL(string: Endpoints.spellList.rawValue) else {
            completionHandler(.failure(.incorrectURL)); return
        }
        
        downloadContent(with: url) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let rawData):
                let result = self.parsingService.parseFrom(spellListData: rawData)
                switch result {
                case .success(let spellList):
                    completionHandler(.success(spellList))
                case .failure(_):
                    completionHandler(.failure(.invalidResponseData))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func downloadSpell(with path: String, _ completionHandler: @escaping (Result<SpellDTO, NetworkServiceError>) -> Void) {

        guard let url = URL(string: Endpoints.spellDetails.rawValue + path) else {
            completionHandler(.failure(.incorrectURL)); return
        }

        downloadContent(with: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let rawData):
                let result = self.parsingService.parseFrom(spellDetailData: rawData)
                switch result {
                case .success(let spell):
                    completionHandler(.success(spell))
                case .failure(_):
                    completionHandler(.failure(.invalidResponseData))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func downloadContent(with url: URL, completionHandler: @escaping (Result<Data, NetworkServiceError>) -> Void) {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = self.urlSessionProtocolClasses
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)

        session.dataTask(with: url) { (data, _, _) in
            if let jsonData = data {
                completionHandler(.success(jsonData))
            } else {
                completionHandler(.failure(.invalidResponseData))
            }
        }.resume()
    }
}
