//
//  Dnd5eAppUITests.swift
//  Dnd5eAppUITests
//
//  Created by Yevhen Mokeiev on 4/17/19.
//  Copyright © 2019 Yevhen Mokeiev. All rights reserved.
//

import XCTest

class Dnd5eAppUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    func testIntegration() {
        let app = XCUIApplication()
        app.launch()
        let tableView = app.otherElements["SpellTableView"]
        let firstCell = tableView.cells.element(boundBy: 0)
        firstCell.tap()

        let spellLabel = app.staticTexts["Acid Arrow"]
        XCTAssertTrue(spellLabel.exists)
    }
}
