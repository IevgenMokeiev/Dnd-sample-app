//
//  ContentDownloader.swift
//  Dnd5eApp
//
//  Created by Ievgen on 4/18/19.
//  Copyright © 2019 Ievgen. All rights reserved.
//

import Foundation

enum DownloadingError: Error {
    case incorrectURL
    case downloadFailed
    case invalidResponseStatusCode
    case invalidResponseData
}

class ContentDownloader {
    
    private static let rootPath = "http://dnd5eapi.co/api/"
    internal var urlSessionProtocolClasses: [AnyClass]?
    
    public func downloadSpellList(_ completionHandler: @escaping (_ result: [[String: Any]]?, _ error: DownloadingError?) -> Void) {
        self.downloadContent(with: .spells) { (resultDict, error) in
            guard let array = resultDict?["results"] as? [[String: Any]] else { completionHandler(nil, .invalidResponseData); return }
            completionHandler(array, nil)
        }
    }
    
    private func downloadContent(with path: ContentPath, completionHandler: @escaping (_ result: [String: Any]?, _ error: DownloadingError?) -> Void) {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = self.urlSessionProtocolClasses
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        
        guard let spellsUrl  = URL(string: type(of: self).rootPath + path.rawValue) else { completionHandler(nil, .incorrectURL); return }
        
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
