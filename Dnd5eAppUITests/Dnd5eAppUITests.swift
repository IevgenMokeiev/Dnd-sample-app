//
//  Dnd5eAppUITests.swift
//  Dnd5eAppUITests
//
//  Created by Ievgen on 4/17/19.
//  Copyright © 2019 Ievgen. All rights reserved.
//

import XCTest

class Dnd5eAppUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }

    func testInteraction() {
        let app = XCUIApplication()
        app.launch()
        let tableView = app.tables.matching(identifier: "SpellTableView").firstMatch
        let firstCell = tableView.cells.element(boundBy: 0)
        firstCell.tap()
        
        let spellLabel = app.staticTexts["Acid Arrow"]
        XCTAssertEqual(spellLabel.exists, true)
    }
}
