//
//  ExampleAppUITests.swift
//  ExampleAppUITests
//
//  Created by Andrey Fidrya on 04/07/15.
//  Copyright © 2015 Zabiyaka. All rights reserved.
//

import Foundation
import XCTest

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
        let app = XCUIApplication()
        let tabBar = app.tabBars
        tabBar.buttons["Second"].tap()
        wait(5)
        tabBar.buttons["First"].tap()
        wait(5)
        
    }

    // - MARK: wait()
    
    var waitExpectation: XCTestExpectation?
    
    func wait(duration: NSTimeInterval) {
        waitExpectation = expectationWithDescription("wait")
        NSTimer.scheduledTimerWithTimeInterval(duration, target: self,
            selector: Selector("onTimer"), userInfo: nil, repeats: false)
        waitForExpectationsWithTimeout(duration + 3, handler: nil)
    }
    
    func onTimer() {
        waitExpectation?.fulfill()
    }
}
