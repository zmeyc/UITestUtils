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

open class UITestServer {
    typealias T = UITestServer
    
    open static let sharedInstance = UITestServer()
    
    open func listen(_ port: in_port_t = 5000) {
        if !PrivateUtils.debug() {
            print("WARNING: UITestServer disabled because DEBUG is not defined")
            return
        }
        let server = HttpServer()
        
        server["/screenshot.png"] = { request in
            var dataOrNil: Data?
            DispatchQueue.main.sync {
                if let screenshot = UITestServer.takeScreenshot() {
                    if let screenshotData = UIImagePNGRepresentation(screenshot) {
                        dataOrNil = screenshotData
                    }
                }
            }
            guard let data = dataOrNil else {
                print("Unable to create screenshot")
                return .internalServerError
            }
            return HttpResponse.raw(200, "OK", nil, T.dataToUInt8Array(data))
        }
        
        server["/screenResolution"] = { request in
            var data = Data()
            DispatchQueue.main.sync {
                let resolution = UITestServer.screenResolution()
                if let resolutionData = resolution.data(using: String.Encoding.utf8) {
                    data = resolutionData
                }
            }
            return .raw(200, "OK", nil, T.dataToUInt8Array(data))
        }
        
        server["/deviceType"] = { request in
            var data = Data()
            DispatchQueue.main.sync {
                let deviceType = UITestServer.deviceType()
                if let deviceTypeData = deviceType.data(using: String.Encoding.utf8) {
                    data = deviceTypeData
                }
            }
            return .raw(200, "OK", nil, T.dataToUInt8Array(data))
        }
        
        server["/orientation"] = { request in
            var data = Data()
            DispatchQueue.main.sync {
                let orientationString = String(UIApplication.shared.statusBarOrientation.rawValue)
                if let orientationData = orientationString.data(using: String.Encoding.utf8) {
                    data = orientationData
                }
            }
            return .raw(200, "OK", nil, T.dataToUInt8Array(data))
        }
        
        server["/setOrientation/:orientation"] = { request in
            if let orientationString = request.params["orientation"] {
                let orientation = Int(orientationString)
                DispatchQueue.main.async {
                    PrivateUtils.forceOrientation(Int32(orientation ?? UIInterfaceOrientation.portrait.rawValue))
                }
            }
            return .raw(200, "OK", nil, [UInt8]())
        }
        
        print("Starting UI Test server on port \(port)")
        do {
            try server.start(port)
        } catch {
            print("Failed to start the server")
        }
    }
    
    fileprivate class func dataToUInt8Array(_ data: Data) -> [UInt8] {
        let count = data.count / MemoryLayout<UInt8>.size
        var array = [UInt8](repeating: 0, count: count)
        (data as NSData).getBytes(&array, length:count * MemoryLayout<UInt8>.size)
        return array
    }
    
    fileprivate class func takeScreenshot() -> UIImage? {
        return PrivateUtils.takeScreenshot()
    }
    
    fileprivate class func screenResolution() -> String {
        let screen = UIScreen.main
        let bounds = screen.bounds
        let scale = screen.scale
        let width = Int(bounds.size.width * scale)
        let height = Int(bounds.size.height * scale)
        return "\(width)x\(height)"
    }
    
    fileprivate class func deviceType() -> String {
        return UIDevice.current.userInterfaceIdiom == .pad ? "pad" : "phone"
    }
}
