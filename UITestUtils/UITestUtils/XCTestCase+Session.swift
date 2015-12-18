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
    
    func urlForEndpoint(endpoint: String, args: [String]) -> NSURL? {
        var urlString = "\(SessionData.uiTestServerAddress)/\(endpoint)"
        for arg in args {
            urlString += "/"
            urlString += arg.urlencode()
        }
        let endpoint = NSURL(string: urlString)
        guard let url = endpoint else {
            XCTFail("Invalid URL: \(urlString)")
            return nil
        }
        return url
    }
    
    func dataFromRemoteEndpoint(endpoint: String, method: String, args: [String]) -> NSData? {
        guard let url = urlForEndpoint(endpoint, args: args) else {
            return nil
        }
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = method
        
        var result: NSData? = nil
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
            guard let responseData = data else {
                XCTFail("No data received (UITestServer not running?)")
                return
            }
            result = responseData
            expectation.fulfill()
        }
        dataTask.resume()
        waitForExpectationsWithTimeout(10.0, handler: nil)
        return result
    }
    
    func dataFromRemoteEndpoint(endpoint: String, method: String = "GET", args: String...) -> NSData? {
        return dataFromRemoteEndpoint(endpoint, method: method, args: args)
    }
    
    func stringFromRemoteEndpoint(endpoint: String, method: String, args: [String]) -> String {
        let data = dataFromRemoteEndpoint(endpoint, method: method, args: args)
        if let stringData = data {
            let resolution = NSString(data: stringData, encoding: NSUTF8StringEncoding) ?? ""
            return resolution as String
        }
        return ""
    }

    func stringFromRemoteEndpoint(endpoint: String, method: String = "GET", args: String...) -> String {
        return stringFromRemoteEndpoint(endpoint, method: method, args: args)
    }

    func callRemoteEndpoint(endpoint: String, method: String, args: [String]) {
        let _ = dataFromRemoteEndpoint(endpoint, method: method, args: args)
    }

    func callRemoteEndpoint(endpoint: String, method: String = "GET", args: String...) {
        callRemoteEndpoint(endpoint, method: method, args: args)
    }
}

