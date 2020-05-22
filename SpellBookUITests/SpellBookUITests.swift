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

    func test_selection() {
        let app = XCUIApplication()
        app.launch()
        let tableView = app.otherElements["SpellTableView"]
        tableView.cells.element(boundBy: 0).tap()

        let spellLabel = app.staticTexts["Acid Arrow"]
        XCTAssertTrue(spellLabel.waitForExistence(timeout: 3))
    }

    func test_search() {
        let app = XCUIApplication()
        app.launch()
        let tableView = app.otherElements["SpellTableView"]
        let searchView = app.textFields["SpellSearchView"]
        searchView.tap()
        searchView.typeText("Acid Arrow")

        tableView.cells.element(boundBy: 0).tap()

        let spellLabel = app.staticTexts["Acid Arrow"]
        XCTAssertTrue(spellLabel.waitForExistence(timeout: 3))
    }

    func test_add_favorite() {
        let app = XCUIApplication()
        app.launch()
        let tableView = app.otherElements["SpellTableView"]
        tableView.cells.element(boundBy: 0).tap()

        let spellLabel = app.staticTexts["Acid Arrow"]
        XCTAssertTrue(spellLabel.waitForExistence(timeout: 3))

        app.buttons["FavoritesButton"].tap()
        app.navigationBars.buttons.element(boundBy: 0).tap()

        app.tabBars.buttons.element(boundBy: 1).tap()

        let favoritesTableView = app.otherElements["FavoritesTableView"]
        favoritesTableView.cells.element(boundBy: 0).tap()
        
        let favoriteSpellLabel = app.staticTexts["Acid Arrow"]
        XCTAssertTrue(favoriteSpellLabel.waitForExistence(timeout: 3))
    }
}
