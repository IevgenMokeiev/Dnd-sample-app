//
//  ViewController.swift
//  Dnd5eApp
//
//  Created by Ievgen on 4/17/19.
//  Copyright © 2019 Ievgen. All rights reserved.
//

import UIKit
import MBProgressHUD

private enum ViewState {
    case loading
    case displayingSpells
}

class SpellListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    static let cellReuseIdentifier = "spellCell"
    private var viewState: ViewState?

    var contentManagerService: ContentManagerService?
    
    // Mark: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Spell Book"
        self.viewState = .loading
        self.tableView.accessibilityIdentifier = "SpellTableView"

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        contentManagerService = appDelegate.contentManagerService
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        switch self.viewState {
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
            detailViewController.spell = contentManagerService?.spell(at: indexPath)
            detailViewController.contentManagerService = contentManagerService
        }
    }
    
    // MARK: - Loading
    private func loadData() {
        contentManagerService?.retrieveSpellList { (result, error) in
            self.viewState = .displayingSpells
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
        return .loading == self.viewState ? 0: 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return contentManagerService?.numberOfSpells ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: type(of: self).cellReuseIdentifier, for: indexPath)
        return cell
    }
}

extension SpellListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let spell = contentManagerService?.spell(at: indexPath)
        cell.textLabel?.text = spell?.name
    }
}

