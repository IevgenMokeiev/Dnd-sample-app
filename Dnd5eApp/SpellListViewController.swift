//
//  ViewController.swift
//  Dnd5eApp
//
//  Created by Ievgen on 4/17/19.
//  Copyright © 2019 Ievgen. All rights reserved.
//

import UIKit

class SpellListViewController: UITableViewController {

    static let cellReuseIdentifier = "spellCell"
    var isLoading: Bool = false {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var spellsDictionary: [String: Any]?
    
    internal var urlSessionProtocolClasses: [AnyClass]?
    
    // Mark: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Spell Book"
        
        self.loadData()
    }
    
    // MARK: - NSURLSession
    
    private func loadData() {
        self.isLoading = true
        
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = self.urlSessionProtocolClasses
        let session = URLSession(configuration: configuration)
        
        guard let spellsUrl  = URL(string: "http://dnd5eapi.co/api/spells") else { return }
        
        session.dataTask(with: spellsUrl) { (data, response, error) in
            guard let jsonData = data else { return }
            DispatchQueue.main.async {
                self.spellsDictionary = try? JSONSerialization.jsonObject(with: jsonData) as? Dictionary<String, Any>
                self.isLoading = false
            }
        }.resume()
    }
    
    // Mark: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.isLoading ? 0: 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var value = 0
        
        if let dict = self.spellsDictionary, let count = dict["count"] as? Int{
            value = count
        }
        
        return value
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: type(of: self).cellReuseIdentifier, for: indexPath)
        
        guard let dict = self.spellsDictionary else { return cell }
        guard let array: [[String: Any]] = dict["results"] as? [[String: Any]] else { return cell }
        let spellDict = array[indexPath.row]
        guard let string = spellDict["name"] as? String else { return cell }
        
        cell.textLabel?.text = string
        
        return cell
    }
}

