//
//  RickAndMortyWikiUITests.swift
//  RickAndMortyWikiUITests
//
//  Created by Beka Gelashvili on 11.01.24.
//

import XCTest

class RickAndMortyWikiUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    // NOTE: for UI tests to work the keyboard of simulator must be on.
    // Keyboard shortcut COMMAND + SHIFT + K while simulator has focus
    func testOpenCharacterDetails_whenSearchRickSanchezAndTapOnFirstResultRow_thenCharacterDetailsViewOpensWithTitleRickSanchez() {
        let app = XCUIApplication()

        // Search for Rick Sanchez
        let searchText = "Rick Sanchez"

        app.searchFields[AccessibilityIdentifier.searchField].tap()

        if !app.keys["A"].waitForExistence(timeout: 5) {
            XCTFail("The keyboard could not be found. Use keyboard shortcut COMMAND + SHIFT + K while simulator has focus on text input")
        }

        _ = app.searchFields[AccessibilityIdentifier.searchField].waitForExistence(timeout: 10)

        app.searchFields[AccessibilityIdentifier.searchField].typeText(searchText)
        app.buttons["search"].tap()

        // Tap on first result row
        app.tables.cells.staticTexts[searchText].tap()

        // Make sure character details view
        XCTAssertTrue(app.otherElements[AccessibilityIdentifier.characterDetailsView].waitForExistence(timeout: 5))
        XCTAssertTrue(app.navigationBars[searchText].waitForExistence(timeout: 5))
    }
}
