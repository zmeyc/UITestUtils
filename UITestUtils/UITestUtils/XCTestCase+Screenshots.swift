//
//  XCTestCase+Screenshots.swift
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

extension XCTestCase {
    private struct ScreenshotsData {
        static var uiTestServerAddress = "http://localhost:5000"
        
        static var session: NSURLSession?
    }
    
    public var uiTestServerAddress: String {
        get { return ScreenshotsData.uiTestServerAddress }
        set { ScreenshotsData.uiTestServerAddress = newValue }
    }
    
    public func saveScreenshot(filename: String) {
        let urlString = "\(ScreenshotsData.uiTestServerAddress)/screenshot.png"
        let endpoint = NSURL(string: urlString)
        guard let url = endpoint else {
            XCTFail("Invalid URL: \(urlString)")
            return
        }
        if ScreenshotsData.session == nil {
            let sessionConfig = NSURLSessionConfiguration.ephemeralSessionConfiguration()
            //ScreenshotsData.session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
            ScreenshotsData.session = NSURLSession(configuration: sessionConfig)
        }
        let session = ScreenshotsData.session!
        let request = NSURLRequest(URL: url)
        
        let expectation = expectationWithDescription("dataTask")
        let dataTask = session.dataTaskWithRequest(request) { data, response, error in
            // WARNING: NOT a main queue
            guard let imageData = data else {
                XCTFail("No data received (UITestServer not running?)")
                return
            }
            if imageData.length == 0 {
                XCTFail("Empty screenshot received")
                return
            }
            imageData.writeToFile("/Users/user/Temp/Screenshots/test.png", atomically: false)
            expectation.fulfill()
        }
        guard let task = dataTask else {
            XCTFail("Unable to create dataTask")
            return
        }
        task.resume()
        waitForExpectationsWithTimeout(10.0, handler: nil)
    }
}
