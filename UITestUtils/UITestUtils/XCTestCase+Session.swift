//
//  XCTestCase+Session.swift
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
    private struct SessionData {
        static var uiTestServerAddress = "http://localhost:5000"
        
        static var session: NSURLSession?
    }
    
    public var uiTestServerAddress: String {
        get { return SessionData.uiTestServerAddress }
        set { SessionData.uiTestServerAddress = newValue }
    }
    
    var session: NSURLSession {
        get {
            if SessionData.session == nil {
                let sessionConfig = NSURLSessionConfiguration.ephemeralSessionConfiguration()
                //SessionData.session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
                SessionData.session = NSURLSession(configuration: sessionConfig)
            }
            return SessionData.session!
        }
    }
    
    func urlForEndpoint(endpoint: String) -> NSURL? {
        let urlString = "\(SessionData.uiTestServerAddress)/\(endpoint)"
        let endpoint = NSURL(string: urlString)
        guard let url = endpoint else {
            XCTFail("Invalid URL: \(urlString)")
            return nil
        }
        return url
    }
    
    func callRemoteEndpoint(endpoint: String) {
        guard let url = urlForEndpoint(endpoint) else {
            return
        }
        
        let request = NSURLRequest(URL: url)
        
        let expectation = expectationWithDescription("dataTask")
        let dataTask = session.dataTaskWithRequest(request) { data, response, error in
            // WARNING: NOT a main queue
            if error != nil {
                XCTFail("dataTaskWithRequest error (please check if UITestServer is running): \(error)")
                return
            }
            if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    XCTFail("dataTaskWithRequest: status code \(httpResponse.statusCode) received, please check if UITestServer is running")
                    return
                }
            }
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

