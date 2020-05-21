//
//  SpellBookUITests.swift
//  SpellBookUITests
//
//  Created by Yevhen Mokeiev on 4/17/19.
//  Copyright © 2019 Yevhen Mokeiev. All rights reserved.
//

import XCTest

class SpellBookUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    func testSelection() {
        let app = XCUIApplication()
        app.launch()
        let tableView = app.otherElements["SpellTableView"]
        let firstCell = tableView.cells.element(boundBy: 0)
        firstCell.tap()

        let spellLabel = app.staticTexts["Acid Arrow"]
        XCTAssertTrue(spellLabel.waitForExistence(timeout: 3))
    }

    func testSearch() {
        let app = XCUIApplication()
        app.launch()
        let tableView = app.otherElements["SpellTableView"]
        let searchView = app.textFields["SpellSearchView"]
        searchView.tap()
        searchView.typeText("Acid Arrow")
        let firstCell = tableView.cells.element(boundBy: 0)
        firstCell.tap()

        let spellLabel = app.staticTexts["Acid Arrow"]
        XCTAssertTrue(spellLabel.waitForExistence(timeout: 3))
    }
}
