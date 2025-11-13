//
//  BitriseBankingiOSDemoUITestsLaunchTests.swift
//  BitriseBankingiOSDemoUITests
//
//  Created by Balazs Ilsinszki on 2025. 03. 15..
//

import XCTest

final class BitriseBankingiOSDemoUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        false
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Wait for Login button to be present
        let loginButton = app.buttons["Login"]
        XCTAssertTrue(loginButton.waitForExistence(timeout: 5), "Login button should be present")
        
        // Find email text field
        let emailTextField = app.textFields.element(matching: NSPredicate(format: "placeholderValue == 'Email'"))
        XCTAssertTrue(emailTextField.waitForExistence(timeout: 5), "Email text field should be present")
        
        // Enter email
        emailTextField.tap()
        emailTextField.typeText("test@test.com")
        
        // Find password text field
        let passwordTextField = app.secureTextFields.element(matching: NSPredicate(format: "placeholderValue == 'Password'"))
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5), "Password text field should be present")
        
        // Enter password
        passwordTextField.tap()
        passwordTextField.typeText("12345")
        
        // Tap Login button
        loginButton.tap()
        
        // Wait and check for Currencies text
        let currenciesText = app.staticTexts["Currencies"]
        XCTAssertTrue(currenciesText.waitForExistence(timeout: 10), "Currencies text should appear after login")

        // No CardSubViews in the beginning
        sleep(7) // Wait for network call
        let cardSubViewPredicate = NSPredicate(format: "identifier == 'CardSubView'")
        let cardSubViewElements = app.descendants(matching: .any).containing(cardSubViewPredicate)
        //XCTAssertEqual(cardSubViewElements.count, 0, "No CardViewSub elements should be displayed")
        
        
        // Wait for button to exist
        //let plusButton = app.buttons.images["plus"]
        //XCTAssertTrue(plusButton.waitForExistence(timeout: 5), "Plus button should be present")
        
        //let plusButton = app.buttons.containing(.image, identifier: "plus")
        //XCTAssertTrue(buttons.element.exists, "Button with plus image should exist")
        
        let plusButton = app.buttons["PlusButton"]
        XCTAssertTrue(plusButton.waitForExistence(timeout: 5), "Plus button should be present")
        
        plusButton.tap()
        
        // Wait and check for Currencies text
        let currencySelector = app.staticTexts["Select Currency"]
        XCTAssertTrue(currencySelector.waitForExistence(timeout: 10), "Currencies text should appear after login")
        
        // Wait for the currency list
        let usdCell = app.buttons["🇺🇸 USD"]
        XCTAssertTrue(usdCell.exists, "USD cell should be present")
        usdCell.tap()

        // One cardSubViews is present
        sleep(7) // Wait for network call
        let UScardSubViewElements = app.descendants(matching: .any).containing(cardSubViewPredicate)
        //XCTAssertEqual(UScardSubViewElements.count, 1, "One CardViewSub elements should be displayed")
    }
}
