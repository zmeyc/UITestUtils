# TestUtils

UITestUtils extend Xcode7 UI Testing framework (XCTest).

```swift
func testExample() {
	let app = XCUIApplication()

	//uiTestServerAddress = "http://localhost:5000" // device IP address or localhost for Simulator

	overrideStatusBar() // Set 9:41 AM, 100% battery

	app.textFields["Enter text"].typeText("Alert text")

	waitForDuration(2) // Wait 2 seconds

	orientation = .LandscapeLeft // Rotate the simulator

	app.buttons["Alert"].tap()

	saveScreenshot("\(realHomeDirectory)/Screenshots/\(deviceType)_\(screenResolution)_Screenshot1.png")

	restoreStatusBar() // Restore original status bar
}
```

# Features

* Automate screenshot capture for AppStore submission
* Rotate the simulator programmatically
* Delay test execution for a specified number of seconds
* Override statusbar to show 9:41 AM, 100% battery like on Apple product photos

# System requirements

Xcode 7.2+, Swift 2.0+, iOS 9+

Tested only on Simulators, but should work with devices as well.

## About

Xcode7 introduced UI testing as a new major feature of XCTest framework.

Currently, it has some limitations. UI elements can be accessed using various selectors such as `app.buttons["My Button"]`, but there is no direct access to app's classes. It's not possible to call an arbitrary function in the app.

Also, it's not yet possible to capture screenshots in a controlled manner while running the test. It would be very handy to group them by device or screen size for AppStore submission.

This library adds a set of helper functions to solve these issues.

## How it works

The library consists of two subprojects:

 * **UITestUtils** is to be used in UI tests. It contains extensions to XCTestCase. Some functions use sockets to communicate with the app being tested if something needs to be done on the app side. 

 * **UITestServer** is to be be linked with the app being tested to serve UITestUtils requests. It uses private APIs for screenshot capture and screen rotation, but they're commented out in non-Debug builds.

## Contacts

- If you **need help**, **found a bug** or **have a feature request**, please open an issue.
- If you **want to contribute**, submit a pull request.

## Installation

Add UITestUtils to your project:

```
cd MyProject
mkdir ThirdParty
cd ThirdParty
git clone --recursive https://github.com/zmeyc/UITestUtils.git
```

Open your project in Xcode.

From Finder, drag `ThirdParty/UITestUtils/UITestServer/UITestServer.xcodeproj` into your project in Xcode.
Put it into any location in the tree below the project root.

Drag `ThirdParty/UITestUtils/UITestUtils/UITestUtils.xcodeproj` into your project in Xcode.
I recommend putting it into "MyProject UI Tests" folder.

In Xcode, click the project name at the top of the project tree.

On the left sidebar, choose `Target: MyProject`.
On `General` tab, scroll to `Embedded Binaries` section.
Add `TestServer.framework` as Embedded Binary.
This will automatically add it to `Link Binary with Libraries` section on `Build Phases` tab.

On the left sidebar, choose `Target: MyProject UI Tests`.
On `Build Phases` tab, add `TestUtils.framework` to `Link Binary With Libraries` section.

If you're stuck with any of the steps above, please check the example project:
`UITestUtils/ExampleApp/ExampleApp.xcodeproj`

Section below describes the next steps.

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

If imports are highlighted in red color, clean Xcode build folder by pressing `Option+Shift+Command+K` then try building the project again.

The following functions will be available:

### waitForDuration

```swift
func waitForDuration(seconds: NSTimeInterval)
```

Pauses execution of the test for a specified number of seconds. Example:

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

### realHomeDirectory

```swift
let realHomeDirectory: String
```

NSHomeDirectory returns Simulator's sandbox directory such as:
```
(lldb) p NSHomeDirectory()
(String) $R0 = "/Users/user/Library/Developer/CoreSimulator/Devices/666C2BE9-D22D-4261-9A45-F5EE577FF797/data/Containers/Data/Application/C3F3A59F-DA7D-4B3C-9EA2-BC9DD94934F0"
```

realHomeDirectory drops everything after "/Library/Developer" including that string itself and returns "/Users/user".

Example: save a screenshot to "~/MyAppScreenshots":

```swift
saveScreenshot("\(realHomeDirectory)/MyAppScreenshots/screenshot.png")
```

### screenResolution

```swift
let screenResolution: String
```

Screen resolution in the format "640x960". Rotation is taken into account.
Local UIScreen object returns incorrect resolution, so the resolution is retrieved from the app.
Requires UITestServer to be running on the app side.

### deviceType

```swift
let deviceType: String
```

Returns 'pad' or 'phone'.
Requires UITestServer to be running on the app side.

### orientation

```swift
var orientation: UIInterfaceOrientation
```

Assign this property to rotate the simulator. Read the property to determine current orientation.
Requires UITestServer to be running on the app side.

Example:

```switch
orientation = .LandscapeLeft
```

## Utilities

Use `Scripts/reset_simulators.sh` to reset all simulators to their original state.

## Sample code

Sample code is located in `ExampleApp/ExampleAppUITests/ExampleAppUITests.swift`

Check the `testExample()` test.

## Licensing

UITestUtils (except third party components) is available under the MIT license.
Please see LICENSE file for details.

UITestUtils uses:

* Swifter HTTP server engine. License: UITestServer/ThirdParty/swifter/LICENSE
* SimulatorStatusMagic. MIT License: UITestUtils/ThirdParty/SimulatorStatusMagic/LICENSE



