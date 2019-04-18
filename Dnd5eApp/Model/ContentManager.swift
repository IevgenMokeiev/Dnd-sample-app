//
//  ContentManager.swift
//  Dnd5eApp
//
//  Created by Ievgen on 4/18/19.
//  Copyright © 2019 Ievgen. All rights reserved.
//

import Foundation
import CoreData

class ContentManager {
    
    public static let sharedManager = ContentManager()
    private var isDownloaded: Bool = false
    private var contentDownloader: ContentDownloader?
    
    public func retrieveContent(for path: ContentPath, completionHandler: @escaping (_ result: [String: Any]?, _ error: DownloadingError?) -> Void) {
        
    }
}
