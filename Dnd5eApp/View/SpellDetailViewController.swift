//
//  SpellDetailViewController.swift
//  Dnd5eApp
//
//  Created by Ievgen on 4/18/19.
//  Copyright © 2019 Ievgen. All rights reserved.
//

import UIKit
import MBProgressHUD

private enum ViewModel {
    case loading
    case displayingSpell
}

class SpellDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var spellContentView: UIView!
    
    public var spell: Spell?
    private var viewModel: ViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = self.spell?.name
        self.viewModel = .loading
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadDataIfNeeded()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        switch self.viewModel {
        case .loading?:
            self.spellContentView.isHidden = true
            self.showLoadingHUD()
        case .displayingSpell?:
            self.spellContentView.isHidden = false
            self.hideLoadingHUD()
        default: break
        }
    }
    
    // MARK: - Loading
    private func loadDataIfNeeded() {
        if nil == self.spell?.desc {
            ContentManager.shared.retrieve(spell: self.spell, completionHandler: { (result, error) in
                self.viewModel = .displayingSpell
                self.view.setNeedsLayout()
            })
        } else {
            self.viewModel = .displayingSpell
            self.view.setNeedsLayout()
        }
    }
    
    private func showLoadingHUD() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "Loading Spell..."
    }
    
    private func hideLoadingHUD() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
}
