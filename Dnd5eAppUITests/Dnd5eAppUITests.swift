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
        continueAfterFailure = false
    }

    // TO DO: - Fix and re-enable
    func testIntegration() {
        let app = XCUIApplication()
        app.launch()
        let tableView = app.tables["SpellTableView"]
        let firstCell = tableView.cells.element(boundBy: 0)
        firstCell.tap()
        
        let spellLabel = app.staticTexts["Acid Arrow"]
        XCTAssertTrue(spellLabel.exists)
    }

    public func waitForElementToExist(element: XCUIElement, timeout: Double = 10) {
        expectation(for: NSPredicate(format: "exists == true"), evaluatedWith: element, handler: nil)
        waitForExpectations(timeout: timeout, handler: nil)
    }

    public func waitForElementToBeHittable(element: XCUIElement, timeout: Double = 10) {
        waitForElementToExist(element: element, timeout: timeout)
        expectation(for: NSPredicate(format: "isHittable == true"), evaluatedWith: element, handler: nil)
        waitForExpectations(timeout: 2, handler: nil)
    }
}
