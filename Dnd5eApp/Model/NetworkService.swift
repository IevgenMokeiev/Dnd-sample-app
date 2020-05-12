//
//  NetworkService.swift
//  Dnd5eApp
//
//  Created by Ievgen on 4/18/19.
//  Copyright © 2019 Ievgen. All rights reserved.
//

import Foundation

private enum ContentPath: String {
    case spells = "spells"
}

public enum NetworkServiceError: Error {
    case incorrectURL
    case downloadFailed
    case invalidResponseStatusCode
    case invalidResponseData
}

protocol NetworkService {
    func downloadSpellList(_ completionHandler: @escaping (_ result: [[String: Any]]?, _ error: NetworkServiceError?) -> Void)
    func downloadSpell(with path: String, _ completionHandler: @escaping (_ result: [String: Any]?, _ error: NetworkServiceError?) -> Void)
}

class NetworkServiceImpl: NetworkService {
    
    private static let rootAPIPath = "http://dnd5eapi.co/api/"
    private static let rootPath = "http://dnd5eapi.co"
    internal var urlSessionProtocolClasses: [AnyClass]?
    
    public func downloadSpellList(_ completionHandler: @escaping (_ result: [[String: Any]]?, _ error: NetworkServiceError?) -> Void){
        self.downloadContent(with: URL(string: (type(of: self).rootAPIPath + ContentPath.spells.rawValue))) { (resultDict, error) in
            guard let array = resultDict?["results"] as? [[String: Any]] else { completionHandler(nil, .invalidResponseData); return }
            completionHandler(array, error)
        }
    }
    
    public func downloadSpell(with path: String, _ completionHandler: @escaping (_ result: [String: Any]?, _ error: NetworkServiceError?) -> Void) {
            let url = URL(string: (type(of: self).rootPath + path))
            self.downloadContent(with: url) { (resultDict, error) in
            completionHandler(resultDict, error)
        }
    }
    
    private func downloadContent(with url: URL?, completionHandler: @escaping (_ result: [String: Any]?, _ error: NetworkServiceError?) -> Void) {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = self.urlSessionProtocolClasses
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        
        guard let spellsUrl = url else { completionHandler(nil, .incorrectURL); return }
        
        session.dataTask(with: spellsUrl) { (data, response, error) in
            guard let jsonData = data else { completionHandler(nil, .invalidResponseData); return }
            do {
                let dictionary = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any]
                completionHandler(dictionary, nil)
            } catch {
                completionHandler(nil, .invalidResponseData)
            }
        }.resume()
    }
}
