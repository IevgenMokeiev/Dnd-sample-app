//
//  SpellDetailViewController.swift
//  Dnd5eApp
//
//  Created by Ievgen on 4/18/19.
//  Copyright © 2019 Ievgen. All rights reserved.
//

import UIKit

class SpellDetailViewController: UIViewController {

    public var spell: Spell?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var spellContentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = self.spell?.name
    }
}
