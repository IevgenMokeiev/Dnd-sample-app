//
//  ViewController.swift
//  Dnd5eApp
//
//  Created by Ievgen on 4/17/19.
//  Copyright © 2019 Ievgen. All rights reserved.
//

import UIKit
import MBProgressHUD

enum ViewModel {
    case loading
    case spells
}

class SpellListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    static let cellReuseIdentifier = "spellCell"
    var viewModel: ViewModel?
    var spellsArray: [Spell]?
    
    // Mark: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Spell Book"
        self.viewModel = .loading
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        switch self.viewModel {
        case .loading?:
            self.tableView.isHidden = true
            self.showLoadingHUD()
        case .spells?:
            self.tableView.isHidden = false
            self.tableView.reloadData()
            self.hideLoadingHUD()
        default: break
        }
    }
    
    // MARK: - NSURLSession
    
    private func loadData() {
        ContentManager.shared.retrieveSpellList { (result, error) in
            self.spellsArray = result
            self.viewModel = .spells
            self.view.setNeedsLayout()
        }
    }
    
    private func showLoadingHUD() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "Loading..."
    }
    
    private func hideLoadingHUD() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
}

extension SpellListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return .loading == self.viewModel ? 0: 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.spellsArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: type(of: self).cellReuseIdentifier, for: indexPath)
        return cell
    }
}

extension SpellListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let array = self.spellsArray else { return }
        let spell = array[indexPath.row]
        cell.textLabel?.text = spell.name
    }
}

