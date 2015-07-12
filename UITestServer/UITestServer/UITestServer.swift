//
//  UITestServer.swift
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

import UIKit

public class UITestServer {
    
    public static let sharedInstance = UITestServer()
    
    public func listen(port: in_port_t = 5000) {
        if PrivateUtils.debug() {
            print("WARNING: UITestServer disabled because DEBUG is not defined")
            return
        }
        let server = HttpServer()
        
        server["/screenshot.png"] = { request in
            var dataOrNil: NSData?
            dispatch_sync(dispatch_get_main_queue()) {
                if let screenshot = UITestServer.takeScreenshot() {
                    if let screenshotData = UIImagePNGRepresentation(screenshot) {
                        dataOrNil = screenshotData
                    }
                }
            }
            guard let data = dataOrNil else {
                print("Unable to create screenshot")
                return .InternalServerError
            }
            return .RAW(200, data)
        }
        
        server["/screenResolution"] = { request in
            var data = NSData()
            dispatch_sync(dispatch_get_main_queue()) {
                let resolution = UITestServer.screenResolution()
                if let resolutionData = resolution.dataUsingEncoding(NSUTF8StringEncoding) {
                    data = resolutionData
                }
            }
            return .RAW(200, data)
        }
        
        server["/deviceType"] = { request in
            var data = NSData()
            dispatch_sync(dispatch_get_main_queue()) {
                let deviceType = UITestServer.deviceType()
                if let deviceTypeData = deviceType.dataUsingEncoding(NSUTF8StringEncoding) {
                    data = deviceTypeData
                }
            }
            return .RAW(200, data)
        }
        
        server["/orientation"] = { request in
            var data = NSData()
            dispatch_sync(dispatch_get_main_queue()) {
                let orientationString = String(UIApplication.sharedApplication().statusBarOrientation.rawValue)
                if let orientationData = orientationString.dataUsingEncoding(NSUTF8StringEncoding) {
                    data = orientationData
                }
            }
            return .RAW(200, data)
        }
        
        server["/setOrientation/(.+)"] = { request in
            if let orientationString = request.capturedUrlGroups.first {
                let orientation = Int(orientationString)
                dispatch_async(dispatch_get_main_queue()) {
                    PrivateUtils.forceOrientation(Int32(orientation ?? UIInterfaceOrientation.Portrait.rawValue))
                }
            }
            return .RAW(200, NSData())
        }
        
        print("Starting UI Test server on port \(port)")
        server.start(port)
    }
    
    private class func takeScreenshot() -> UIImage? {
        return PrivateUtils.takeScreenshot()
    }
    
    private class func screenResolution() -> String {
        let screen = UIScreen.mainScreen()
        let bounds = screen.bounds
        let scale = screen.scale
        let width = Int(bounds.size.width * scale)
        let height = Int(bounds.size.height * scale)
        return "\(width)x\(height)"
    }
    
    private class func deviceType() -> String {
        return UIDevice.currentDevice().userInterfaceIdiom == .Pad ? "pad" : "phone"
    }
}