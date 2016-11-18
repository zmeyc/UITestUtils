//
//  ExampleAppUITests.swift
//
//  Copyright (c) 2015 Andrey Fidrya
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation
import XCTest
import UITestUtils

class ExampleAppUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        //uiTestServerAddress = "http://localhost:5000"
        
        let app = XCUIApplication()
        waitForDuration(2)
        
        overrideStatusBar() // Set 9:41 AM, 100% battery. This change is persistent
        waitForDuration(2)
        
        let tabBar = app.tabBars
        
        tabBar.buttons["Second"].tap()
        waitForDuration(2)
        
        saveScreenshot("\(realHomeDirectory)/Temp/Screenshots/\(deviceType)_\(screenResolution)_screenshot1.png")
        waitForDuration(2)

        orientation = .landscapeLeft
        waitForDuration(2)

        print("Current orientation (as Int): \(orientation.rawValue)")
        orientation = .portrait
        waitForDuration(2)

        let textField = app.textFields["Enter text"]
        textField.tap()
        textField.typeText("Alert text")
        waitForDuration(2)

        app.buttons["Alert"].tap()
        waitForDuration(2)
        
        app.sheets["Message"].buttons["Ok"].tap()
        waitForDuration(2)

        tabBar.buttons["First"].tap()
        waitForDuration(2)
        
        restoreStatusBar() // Restore original status bar
        waitForDuration(5)
    }
}
