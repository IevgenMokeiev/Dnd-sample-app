//
//  ViewController.swift
//  Dnd5eApp
//
//  Created by Ievgen on 4/17/19.
//  Copyright © 2019 Ievgen. All rights reserved.
//

import UIKit
import MBProgressHUD

private enum ViewModel {
    case loading
    case displayingSpells
}

class SpellListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    static let cellReuseIdentifier = "spellCell"
    private var viewModel: ViewModel?
    
    // Mark: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Spell Book"
        self.viewModel = .loading
        self.tableView.accessibilityIdentifier = "SpellTableView"
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
        case .displayingSpells?:
            self.tableView.isHidden = false
            self.tableView.reloadData()
            self.hideLoadingHUD()
        default: break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let detailViewController = segue.destination as? SpellDetailViewController else { return }
            guard let cell = sender as? UITableViewCell else { return }
            guard let indexPath = self.tableView.indexPath(for: cell) else { return }
            detailViewController.spell = ContentManager.shared.spell(at: indexPath)
        }
    }
    
    // MARK: - Loading
    private func loadData() {
        ContentManager.shared.retrieveSpellList { (result, error) in
            self.viewModel = .displayingSpells
            self.view.setNeedsLayout()
        }
    }
    
    private func showLoadingHUD() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "Loading Spells..."
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
        
        return ContentManager.shared.numberOfSpells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: type(of: self).cellReuseIdentifier, for: indexPath)
        return cell
    }
}

extension SpellListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let spell = ContentManager.shared.spell(at: indexPath)
        cell.textLabel?.text = spell?.name
    }
}

