//
//  ViewController.swift
//  Dnd5eApp
//
//  Created by Ievgen on 4/17/19.
//  Copyright © 2019 Ievgen. All rights reserved.
//

import UIKit
import MBProgressHUD

class SpellListViewController: UITableViewController {

    static let cellReuseIdentifier = "spellCell"
    var isLoading: Bool = false
    
    var spellsDictionary: [String: Any]?
    
    // Mark: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Spell Book"
        
        self.loadData()
    }
    
    // MARK: - NSURLSession
    
    private func loadData() {
        self.isLoading = true
        self.showLoadingHUD()
        
        ContentDownloader().downloadContent(with: .spells) { (result, error) in
            self.spellsDictionary = result
            self.isLoading = false
            self.tableView.reloadData()
            self.hideLoadingHUD()
        }
    }
    
    private func showLoadingHUD() {
        let hud = MBProgressHUD.showAdded(to: self.tableView, animated: true)
        hud.label.text = "Loading..."
    }
    
    private func hideLoadingHUD() {
        MBProgressHUD.hide(for: self.tableView, animated: true)
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
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let dict = self.spellsDictionary else { return }
        guard let array: [[String: Any]] = dict["results"] as? [[String: Any]] else { return }
        let spellDict = array[indexPath.row]
        guard let string = spellDict["name"] as? String else { return }
        
        cell.textLabel?.text = string
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
    }
}

