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
    
    @IBOutlet weak var spellContentView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!

    var contentManagerService: ContentManagerService?
    
    public var spell: SpellDTO?
    private var viewModel: ViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.spell?.name
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
        if nil == self.spell?.description {
            self.contentManagerService?.retrieve(spell: self.spell, completionHandler: { (result, error) in
                self.populateContentView()
            })
        } else {
            self.populateContentView()
        }
    }
    
    private func populateContentView() {
        self.viewModel = .displayingSpell
        self.view.setNeedsLayout()

        guard let level = self.spell?.level else { return }
        guard let desc = self.spell?.description else { return }
        guard let castingTime = self.spell?.castingTime else { return }
        guard let concentration = self.spell?.concentration else { return }
        
        let levelString = "Level: \(level)\n\n"
        let descString = "Description: \(desc))\n\n"
        let castingTimeString = "Casting time: \(castingTime)\n\n"
        let concentrationstring = "Concentration: \(concentration)\n\n"
        
        self.descriptionLabel.text = levelString + descString + castingTimeString + concentrationstring
        self.view.setNeedsLayout()
    }
    
    private func showLoadingHUD() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "Loading Spell..."
    }
    
    private func hideLoadingHUD() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
}
