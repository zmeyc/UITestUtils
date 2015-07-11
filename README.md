# TestUtils

UITestUtils extend Xcode7 UI Testing framework (XCTest).

# Features

* Automate screenshot capture for AppStore submission
* Delay test execution for a specified number of seconds

# System requirements

Xcode 7+, Swift 2.0+, iOS 9+

Tested only on Simulators, but should work with devices as well.

## About

Xcode7 introduced UI testing as a new major feature of XCTest framework.

Currently, it has some limitations. UI elements can be accessed using various selectors such as `app.buttons["My Button"]`, but there is no direct access to app's classes. It's not possible to call an arbitrary function in the app.

Also, it's not yet possible to capture screenshots in a controlled manner while running the test. It would be very handy to group them by device or screen size for AppStore submission.

This library adds some helper functions to solve these issues.

## How it works

This framework consists of two subprojects:

 * **UITestUtils** is to be used in UI tests. It contains extensions to XCTestCase. Some functions use sockets to communicate with the app being tested if something needs to be done on the app side. 

 * **UITestServer** is to be be linked with the app being tested to serve UITestUtils requests. It uses private APIs for screenshot capture, but they're commented out in non-Debug builds.

## Contacts

- If you **need help**, feel free to contact the developer or use [Stack Overflow](http://stackoverflow.com/questions/tagged/xctest).
- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Installation

// TODO

## Usage

On application start, run the server. This is usually done in AppDelegate.swift, `application:didFinishLaunchingWithOptions` method:

```swift
import UITestServer

func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
  ...
  let server = UITestServer.sharedInstance
  server.listen()
  ...
}
```

In UI Tests import UITestUtils:

```swift
import UITestUtils
```

Use any of the functions described below:

### waitForDuration

```swift
func waitForDuration(seconds: NSTimeInterval)
```

Pauses execution of the test for specified number of seconds. Example:

```swift
waitForDuration(5)
```

### saveScreenshot

```swift
func saveScreenshot(filename: String, createDirectory: Bool = true)
```

Captures screenshot and saves it as *filename* on local disk.
Requires UITestServer to be running on the app side.

If createDirectory is true (default), tries to create all parent
directories specified in filename.

Example:

```swift
saveScreenshot("/Users/user/Temp/Screenshots/screenshot.png")
```

### uiTestServerAddress

```swift
var uiTestServerAddress: String = 'http://localhost:5000'
```

Override UITestServer address and/or port by setting this property.
When running the app on device, this property should be set to device's IP address.

## Sample code

Sample code is located in `ExampleApp/ExampleAppUITests/ExampleAppUITests.swift`

Check the `testExample()` test.

## Licensing

UITestUtils (except third party components) is available under the MIT license.
Please see LICENSE file for details.

UITestUtils uses:

* Swifter HTTP server engine. License: UITestServer/ThirdParty/swifter/LICENSE
* SimulatorStatusMagic. MIT License: UITestUtils/ThirdParty/SimulatorStatusMagic/LICENSE



